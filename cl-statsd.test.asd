(in-package :cl-user)

(defpackage :cl-statsd.test.system
  (:use :cl :asdf))

(in-package :cl-statsd.test.system)

(defsystem :cl-statsd.test
  :version "0.1"
  :description "Tests for cl-statsd"
  :maintainer "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :author "Ilya Khaprov <ilya.khaprov@publitechs.com> and CONTRIBUTORS"
  :licence "MIT"
  :depends-on ("cl-statsd"
               "prove"
               "log4cl")
  :serial t
  :components ((:module "t"
                :serial t
                :components
                ((:file "package")
                 (:test-file "dummy")
                 (:test-file "serializer")
                 (:module "clients"
                  :serial t
                  :components
                  ((:test-file "sync")
                   (:test-file "async"))))))
  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
