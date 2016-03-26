(in-package :cl-statsd.test)

(defmacro with-fake-client (&body body)
  `(let ((statsd:*client* (statsd:make-fake-client))
         (statsd:*random-range* 0))
     ,@body
     (statsd:fake-client-recv)))

(plan 1)

(subtest "Protocol serializer"
  (subtest "Prefix"
    (let ((statsd::*client* (statsd:make-fake-client :prefix "qwe")))
      (statsd:counter "qwe" 1)
      (is (statsd:fake-client-recv) "qwe.qwe:1|c")))
  
  (subtest "Counter"
    (is (with-fake-client (statsd:counter "app.example" 3)) "app.example:3|c")
    (is (with-fake-client (statsd:counter "app.example" 3 :rate 0.23)) "app.example:3|c|@0.23"))
  
  (subtest "Guage"
    (is (with-fake-client (statsd:guage "app.example" 3)) "app.example:3|g")
    (is (with-fake-client (statsd:guage "app.example" 3 :rate 0.23)) "app.example:3|g|@0.23"))

  (subtest "Set"
    (is (with-fake-client (statsd:set "app.example" 3)) "app.example:3|s")
    (is (with-fake-client (statsd:set "app.example" 3 :rate 0.23)) "app.example:3|s|@0.23"))

  (subtest "Timing"
    (is (with-fake-client (statsd:timing "app.example" 3)) "app.example:3|ms")
    (is (with-fake-client (statsd:timing "app.example" 3 :rate 0.23)) "app.example:3|ms|@0.23")
    (is (with-fake-client (statsd:with-timing ("app.example") (sleep 1.5))) "app.example:1500|ms")))

(finalize)
