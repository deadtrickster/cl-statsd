(in-package :cl-statsd.test)

(plan 1)

(subtest "Capture client"
  (let ((statsd:*client* (statsd:make-capture-client :prefix "qwe")))
    (statsd:counter "qwe" 1)
    (is (statsd:capture-client.recv) "qwe.qwe:1|c")    
    (statsd:counter "qwe" 1)
    (is (safe-queue:queue-count (statsd::capture-client-queue statsd:*client*)) 1)
    (statsd:capture-client.reset)
    (is (safe-queue:queue-count (statsd::capture-client-queue statsd:*client*)) 0)))

(finalize)
