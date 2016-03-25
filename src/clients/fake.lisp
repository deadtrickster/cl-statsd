(in-package :cl-statsd)

(defclass fake-client (statsd-client-base)
  ((queue :initform (list) :accessor fake-client-queue)))

(defmethod send ((client fake-client) metric key value rate)
  (maybe-send rate
    (push (serialize-metric metric key value rate) (fake-client-queue client))))

(defun fake-client-recv (&optional (fc *client*))
  (pop (fake-client-queue fc)))
