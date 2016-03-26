(in-package :cl-statsd.test)

(plan 1)

(subtest "Async client tests"
  (subtest "No errors"
    (let ((statsd:*client* (statsd:make-async-client))
          (ret))
      (loop for i from 0 to 3 do
               (setf ret (statsd:counter "example" i)))
      (is ret 3)
      (statsd:stop-client)
      (is (statsd::async-client-state statsd:*client*) :stopped)
      (is (bt:thread-alive-p (statsd::async-client-thread statsd:*client*)) nil)))

  (subtest "Ignore errors"
    (let ((statsd:*client* (statsd:make-async-client :error-handler :ignore))
          (ret))
      (loop for i from 0 to 3 do
            (setf ret (statsd:counter "example" i :rate :qwe)))
      (is ret nil)
      (statsd:stop-client)))

  (subtest "Throw errors"
    (let ((statsd:*client* (statsd:make-sync-client :error-handler :throw))
          (ret))
      (is-error
       (loop for i from 0 to 3 do
                (setf ret (statsd:counter "example" i :rate :qwe)))
       'error)      
      (statsd:stop-client)))

  (subtest "Reconnects if reconnects > 1"
    (let ((statsd:*client* (statsd:make-async-client :reconnects 2 ))
          (ret))
      (loop for i from 0 to 3 do
            (setf ret (statsd:counter "example" i))
            (statsd:transport.close (statsd::client-transport statsd:*client*)))
      (is ret 3)
      (statsd:stop-client)))

  (subtest "No reconnects if reconnects =< 1"
    (let ((statsd:*client* (statsd:make-async-client :reconnects 1))
          (ret))
      (loop for i from 0 to 3 do
            (setf ret (statsd:counter "example" i))
            (sleep 0.2)
            (statsd:transport.close (statsd::client-transport statsd:*client*)))
      (is ret nil)
      (statsd:stop-client)))

  (subtest "Throws error is async client stopped"
    (let ((statsd:*client* (statsd:make-async-client :reconnects 1 :error-handler :throw))
          (ret))
      (is-error
       (loop for i from 0 to 3 do
             (setf ret (statsd:counter "example" i))
             (sleep 0.2)
             (statsd:transport.close (statsd::client-transport statsd:*client*)))
       'error)
      (statsd:stop-client))))

(finalize)
