(in-package :cl-user)

(defpackage #:cl-statsd
  (:use #:cl #:alexandria)
  (:nicknames #:statsd)
  (:shadow #:set)
  (:export #:counter
           #:inc
           #:dec
           #:timing
           #:with-timing
           #:gauge
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
           #:*throttle-threshold*
           #:make-null-client
           #:make-capture-client
           #:capture-client.recv
           #:capture-client.reset
           #:make-sync-client
           #:make-async-client
           #:start-async-client
           #:stop-client
           ;; pipeline
           #:pipeline
           ;; errors
           #:transport-error
           #:handler-handle-error
           #:throttle-threshold-reached))
