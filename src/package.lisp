(in-package :cl-user)

(defpackage #:cl-statsd
  (:use #:cl #:alexandria)
  (:nicknames #:statsd)  
  (:shadow #:set)
  (:export #:counter
           #:timing
           #:with-timing
           #:guage
           #:set
           ;; transports
           #:transport-base
           #:socket-transport
           #:make-transport
           #:transport.connect
           #:transport.send
           #:transport.close
           ;; clients
           #:*client*
           #:*random-range*
           #:make-null-client
           #:make-fake-client
           #:fake-client-recv
           #:make-sync-client
           #:make-async-client
           #:start-async-client
           #:stop-async-client
           ;; errors
           #:transport-error
           #:handler-handle-error))
