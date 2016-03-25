(in-package :cl-statsd)

(defclass sync-client (statsd-client-with-transport)
  ())

(defun make-sync-client (&key (transport :usocket) (host "127.0.0.1") (port 8125) (protocol :datagram)) 
  (make-instance 'sync-client :transport (make-transport transport host port protocol)))

(defmethod send ((client sync-client) metric key value rate)
  (maybe-send rate
    (transport.send (client-transport client) (serialize-metric metric key value rate))))
