(in-package :cl-statsd.test)

(plan 1)

(subtest "Protocol serializer"
  (subtest "Prefix"
    (let ((statsd:*client* (statsd:make-capture-client :prefix "qwe")))
      (statsd:counter "qwe" 1)
      (is (statsd:capture-client.recv) "qwe.qwe:1|c")))
  
  (subtest "Counter"
    (is (with-capture-client (statsd:counter "app.example" 3)) "app.example:3|c")
    (is (with-capture-client (statsd:inc "app.example")) "app.example:1|c")
    (is (with-capture-client (statsd:dec "app.example")) "app.example:-1|c")
    (is (with-capture-client (statsd:counter "app.example" 3 :rate 0.23)) "app.example:3|c|@0.23"))
  
  (subtest "Guage"
    (is (with-capture-client (statsd:guage "app.example" 3)) "app.example:3|g")
    (is (with-capture-client (statsd:guage "app.example" 3 :rate 0.23)) "app.example:3|g|@0.23"))

  (subtest "Set"
    (is (with-capture-client (statsd:set "app.example" 3)) "app.example:3|s")
    (is (with-capture-client (statsd:set "app.example" 3 :rate 0.23)) "app.example:3|s|@0.23"))

  (subtest "Timing"
    (is (with-capture-client (statsd:timing "app.example" 3)) "app.example:3|ms")
    (is (with-capture-client (statsd:timing "app.example" 3 :rate 0.23)) "app.example:3|ms|@0.23")
    (is (with-capture-client (statsd:with-timing ("app.example") (sleep 1.5))) "app.example:1500|ms")))

(finalize)
