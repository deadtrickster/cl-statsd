(asdf:defsystem :cl-statsd
  :serial t
  :version "0.2"
  :license "MIT"
  :depends-on ("alexandria"
               "cl-interpol"
               "local-time"
               "safe-queue"
               "trivial-utf-8"
               "usocket"
               "log4cl"
               "bordeaux-threads")
  :author "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :components ((:module "src"
                :serial t
                :components
                ((:file "package")
                 (:file "clients/base")
                 (:file "statsd")
                 (:module "transports"
                  :serial t
                  :components
                  ((:file "base")
                   (:file "usocket")))
                 (:module "clients"
                  :serial t
                  :components
                  ((:file "fake")
                   (:file "null")
                   (:file "sync")
                   (:file "async"))))))
  :description "Statsd client in Common Lisp")
