(in-package :cl-statsd)

(defclass transport-base ()
  ())

(defgeneric make-transport (transport host port protocol))

(defgeneric transport.send (transport metrics))

(defgeneric transport.close (transport))
