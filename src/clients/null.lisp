(in-package :statsd)

(defclass null-client ()
  ())

(defmethod send ((client null-client) metric key value rate)
  (declare (ignore metric key value rate)))
