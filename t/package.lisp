(in-package :cl-user)

(defpackage :cl-statsd.test
  (:use :cl :prove))

(defmacro with-capture-client (&body body)
  `(let ((statsd:*client* (statsd:make-capture-client))
         (statsd:*random-range* 0))
     ,@body
     (statsd:capture-client.recv)))
