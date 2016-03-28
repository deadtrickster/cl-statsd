(in-package :cl-statsd.test)

(cl-interpol:enable-interpol-syntax)

(plan 1)

(subtest "Pipeline test"
  (is (with-capture-client ()
        (statsd:pipeline ()
          (statsd:inc "qwe")
          (statsd:inc "ewq")))
      #?"qwe:1|c\newq:1|c"))

(finalize)
