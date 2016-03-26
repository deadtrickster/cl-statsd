(in-package :cl-statsd)

(defclass sync-client (statsd-client-with-transport)
  ())

(defun make-sync-client (&key prefix (error-handler :ignore) (transport :usocket) (host "127.0.0.1") (port 8125) (tcp-p))
  (make-instance 'sync-client :prefix prefix
                              :error-handler error-handler
                              :transport (make-transport transport host port tcp-p)))

(defmethod send ((client sync-client) metric key value rate)
  (with-smart?-error-handling client
    (maybe-send rate
      (transport.send (client-transport client) (serialize-metric metric key value rate)))
    value))
