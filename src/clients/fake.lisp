(in-package :cl-statsd)

(defclass fake-client (statsd-client-with-prefix)
  ((queue :initform (list) :accessor fake-client-queue)))

(defun make-fake-client (&key prefix)
  (make-instance 'fake-client :prefix prefix))

(defmethod send ((client fake-client) metric key value rate)
  (maybe-send rate
    (push (serialize-metric metric key value rate) (fake-client-queue client)))
  value)

(defun fake-client-recv (&optional (fc *client*))
  (pop (fake-client-queue fc)))
