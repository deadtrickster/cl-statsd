(in-package :cl-statsd)

(defclass usocket-transport (socket-transport)
  ())

(defmethod make-transport ((transport (eql :usocket)) host port tcp-p)
  (transport.connect
   (make-instance 'usocket-transport
                  :host host
                  :port port
                  :tcp-p tcp-p)))

(defmethod transport.connect ((transport usocket-transport))
  (when (transport-socket transport)
    (ignore-errors
     (usocket:socket-close (transport-socket transport))))
  (setf (slot-value transport 'socket)
        (usocket:socket-connect (transport-host transport)
                                (transport-port transport)
                                :protocol (if (transport-tcp-p transport)
                                              :stream
                                              :datagram)))
  transport)

(defmethod transport.send ((transport usocket-transport) metrics)
  (handler-bind ((usocket:socket-error
                   (lambda (e)
                     (error 'transport-error :error e))))
    (let ((buffer (trivial-utf-8:string-to-utf-8-bytes metrics)))
      (usocket:socket-send (transport-socket transport) buffer (length buffer)))))

(defmethod transport.close ((transport usocket-transport))
  (usocket:socket-close (transport-socket transport)))
