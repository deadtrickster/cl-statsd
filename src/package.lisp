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
           ;; clients
           #:*client*
           #:fake-client
           #:fake-client-recv
           #:null-client
           #:sync-client
           #:make-sync-client
           #:async-client
           #:make-async-client
           #:start-async-client
           #:stop-async-client))
