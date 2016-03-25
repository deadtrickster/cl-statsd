(in-package :statsd)

(defclass null-client (statsd-client-base )
  ())

(defmethod send ((client null-client) metric key value rate)
  (declare (ignore metric key rate))
  value)
