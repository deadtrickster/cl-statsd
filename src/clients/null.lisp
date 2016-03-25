(in-package :statsd)

(defclass null-client (statsd-client-base )
  ())

(defun make-null-client ()
  (make-instance 'null-client))

(defmethod send ((client null-client) metric key value rate)
  (declare (ignore metric key rate))
  value)
