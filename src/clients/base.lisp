(in-package :cl-statsd)

(cl-interpol:enable-interpol-syntax)

(defgeneric handler-handle-error (handler e)
  (:method ((handler (eql :ignore)) e)
    (declare (ignore handler e))
    (throw 'ignore-error nil))
  (:method ((handler (eql :throw)) e)
    (declare (ignore handler e))))

(defclass statsd-client-base ()
  ((error-handler :initform :ignore :initarg :error-handler :reader client-error-handler)))

(defclass statsd-client-with-prefix (statsd-client-base)
  ((prefix :initarg :prefix :initform nil :reader client-prefix)))

(defun client-handler-error (client e)
  (handler-handle-error (client-error-handler client) e))

(defmacro with-smart?-error-handling (client &body body)
  (with-gensyms (client-var)
    `(let ((,client-var ,client))
       (catch 'ignore-error
          (handler-bind ((error
                           (lambda (e)
                             (client-handler-error ,client-var e))))
            ,@body)))))

(defparameter *random-range* 100)

(defmacro maybe-send (rate &body body)
  (with-gensyms (body-fun rand)
    `(flet ((,body-fun ()
              ,@body))
       (if (and ,rate (/= *random-range* 0))
           (let ((,rand (random *random-range*)))
             (when (< ,rand (* rate *random-range*))
               (,body-fun)))
           (,body-fun)))))

(defgeneric serialize-metric (metric key value rate))

(defun serialize-metric% (metric key value rate)
  (if rate
      #?"${key}:${value}|${metric}|@${rate}"
      #?"${key}:${value}|${metric}"))

(defmethod serialize-metric ((metric (eql :counter)) key value rate)
  (serialize-metric% "c" key value rate))

(defmethod serialize-metric ((metric (eql :timing)) key value rate)
  (serialize-metric% "ms" key value rate))

(defmethod serialize-metric ((metric (eql :guage)) key value rate)
  (serialize-metric% "g" key value rate))

(defmethod serialize-metric ((metric (eql :set)) key value rate)
  (serialize-metric% "s" key value rate))

(defgeneric send (client metric key value rate))

(defmethod send :around ((client statsd-client-with-prefix) metric key value rate)
  (if-let ((prefix (client-prefix client)))
    (call-next-method client metric (concatenate 'string prefix "." key) value rate)
    (call-next-method)))

(defgeneric stop-client% (client timeout)
  (:method (client timeout)))

(defun stop-client (&key (client *client*) (timeout 10))
  (stop-client% client timeout))

(defclass statsd-client-with-transport (statsd-client-with-prefix)
  ((transport :initarg :transport :reader client-transport)))

(defmethod stop-client% ((client statsd-client-with-transport) timeout)
  (declare (ignore timeout))
  (transport.close (client-transport client)))
