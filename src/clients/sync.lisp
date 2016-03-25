(in-package :cl-statsd)

(defclass sync-client (statsd-client-base udp-transport)
  ())

(defun make-sync-client (&key (host "127.0.0.1") (port 8125) (protocol :datagram)) 
  (make-instance 'sync-client :socket (usocket:socket-connect host port :protocol protocol)))

(defmethod send ((client sync-client) metric key value rate)
  (maybe-send rate
    (transport-send client (serialize-metric metric key value rate))))
