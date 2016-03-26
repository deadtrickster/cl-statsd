(in-package :cl-statsd.test)

(plan 1)

(subtest "Sync client tests"
  (subtest "No errors"
    (let ((statsd:*client* (statsd:make-sync-client))
          (ret))
      (loop for i from 0 to 3 do
               (setf ret (statsd:counter "example" i)))
      (is ret 3)))

  (subtest "Ignore errors"
    (let ((statsd:*client* (statsd:make-sync-client :error-handler :ignore))
          (ret))
      (loop for i from 0 to 3 do
            (setf ret (statsd:counter "example" i))
            (statsd:transport.close (statsd::client-transport statsd:*client*)))
      (is ret nil)))

  (subtest "Throw errors"
    (let ((statsd:*client* (statsd:make-sync-client :error-handler :throw))
          (ret))
      (is-error
       (loop for i from 0 to 3 do
                (setf ret (statsd:counter "example" i))
                (statsd:transport.close (statsd::client-transport statsd:*client*)))
       'statsd:transport-error))))

(finalize)
