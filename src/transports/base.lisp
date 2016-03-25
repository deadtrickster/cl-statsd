(in-package :cl-statsd)

(defclass transport-base ()
  ())

(defgeneric make-transport (transport host port protocol))

(defgeneric transport.send (transport metrics))

(defgeneric transport.close (transport))

(define-condition transport-error (error)
  ((error :initarg :error :reader transport-error-error)))

(defclass socket-transport (transport-base)
  ((socket :initarg :socket :initform nil :reader transport-socket)
   (host :initarg :host :reader transport-host)
   (port :initarg :port :reader transport-port)
   (tcp :initarg :tcp-p :initform nil :reader transport-tcp-p)))
