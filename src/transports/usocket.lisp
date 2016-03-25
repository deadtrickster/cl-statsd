(in-package :cl-statsd)

(defclass usocket-transport (transport-base)
  ((socket :initarg :socket :reader transport-socket)))

(defmethod make-transport ((transport (eql :usocket)) host port protocol)
  (make-instance 'usocket-transport :socket (usocket:socket-connect host port :protocol protocol)))

(defmethod transport.send ((transport usocket-transport) metrics)
  (let ((buffer (trivial-utf-8:string-to-utf-8-bytes metrics)))
    (usocket:socket-send (transport-socket transport) buffer (length buffer))))

(defmethod transport.close ((transport usocket-transport))
  (usocket:socket-close (transport-socket transport)))
