(in-package :cl-statsd)

(cl-interpol:enable-interpol-syntax)

(defclass statsd-client-base ()
  ())

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

(defgeneric stop-client% (client timeout)
  (:method (client timeout)))

(defun stop-client (&key (client *client*) (timeout 10))
  (stop-client% client timeout))

(defclass statsd-client-with-transport (statsd-client-base)
  ((transport :initarg :transport :reader client-transport)))

(defmethod stop-client% ((client statsd-client-with-transport) timeout)
  (declare (ignore timeout))
  (transport.close (client-transport client)))
