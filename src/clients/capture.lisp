(in-package :cl-statsd)

(defclass capture-client (statsd-client-with-prefix transport-base)
  ((queue :initform (safe-queue:make-queue) :accessor capture-client-queue)))

(defun make-capture-client (&key prefix)
  (make-instance 'capture-client :prefix prefix))

(defmethod send ((client capture-client) metric key value rate)
  (maybe-send rate
    (safe-queue:enqueue (serialize-metric metric key value rate) (capture-client-queue client)))
  value)

(defmethod client-transport ((client capture-client))
  client)

(defmethod transport.send ((transport capture-client) metrics)
  (safe-queue:enqueue metrics (capture-client-queue transport)))

(defmethod transport.close ((transport capture-client)))

(defun capture-client.recv (&optional (client *client*))
  (safe-queue:dequeue (capture-client-queue client)))

(defun capture-client.reset (&optional (client *client*))
  (setf (capture-client-queue client) (safe-queue:make-queue)))
