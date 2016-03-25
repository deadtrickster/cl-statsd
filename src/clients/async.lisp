(in-package :cl-statsd)

(defconstant +async-client-reconnects-default+ 5)

(defclass async-client (statsd-client-with-transport)
  ((reconnects :initarg :reconnects :initform +async-client-reconnects-default+ :reader async-client-reconnects)
   (state :initform :created :reader async-client-state)
   (thread :reader async-client-thread)
   (mailbox :initform (safe-queue:make-mailbox) :reader async-client-mailbox)))

(defun make-async-client (&key (transport :usocket) (host "127.0.0.1") (port 8125) (reconnects +async-client-reconnects-default+) (protocol :datagram)) 
  (make-instance 'async-client :reconnects reconnects :transport (make-transport transport host port protocol)))

(defun async-client-thread-fun (client)
  (loop
    as recv = (safe-queue:mailbox-receive-message (async-client-mailbox client)) do
       (cond
         ((stringp recv)
          (transport.send client recv))
         ((eql recv :stop)
          (setf (slot-value client 'state) :stopped)
          (return)))))

(defun start-async-client (&optional (client *client*))
  (setf (slot-value client 'thread)
        (bt:make-thread (lambda () (async-client-thread-fun client))))
  client)

(defmethod stop-client% ((client async-client) timeout)
  (when (eql (async-client-state client) :running)
    (safe-queue:mailbox-send-message (async-client-mailbox client) :stop)
    (let ((thread (async-client-thread client)))
      #-sbcl
      (progn        
        (log:info "Careless abort")
        (sleep timeout)
        (when (bt:thread-alive-p thread)
          (bt:destroy-thread thread)))
      #+sbcl
      (if (and thread
               (sb-thread:thread-alive-p thread))
          (progn
            (handler-case
                (sb-thread:join-thread thread :timeout timeout)
              (sb-thread:join-thread-error (e)
                (case (sb-thread::join-thread-problem e)
                  (:timeout (log:error "Async StatsD client thread stalled?")
                   (sb-thread:terminate-thread thread))
                  (:abort (log:error "Async StatsD client thread aborted"))
                  (t (log:error "Async StatsD client thread state is unknown"))))))))
    (call-next-method)))

(defmethod send ((client async-client) metric key value rate)
  (maybe-send rate
    (case (async-client-state client)
      (:created (start-async-client client))
      (:stopped (error "Async Statsd client stopped"))
      (t))
    (safe-queue:mailbox-send-message (async-client-mailbox client) (serialize-metric metric key value rate))))
