(in-package :cl-statsd)

(defclass udp-transport ()
  ((socket :initarg :socket :reader sync-client-socket)))

(defmethod transport-send ((transport udp-transport) metrics)
  (let ((buffer (trivial-utf-8:string-to-utf-8-bytes metrics)))
    (usocket:socket-send (sync-client-socket transport) buffer (length buffer))))
