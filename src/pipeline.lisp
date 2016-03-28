(in-package :cl-statsd)

(defclass pipeline (statsd-client-base)
  ((buffer :initform nil :reader pipeline-buffer)
   (client :initarg :client :reader pipeline-client)))

(defmethod send ((client pipeline) metric key value rate)
  (with-slots (buffer) client
    (cond
      ((null buffer)
       (setf buffer (serialize-metric metric key value rate)))
      (t
       (setf buffer (concatenate 'string buffer #?"\n" (serialize-metric metric key value rate)))))))

(defun pipeline-real-send (pipeline)
  (transport.send (client-transport (pipeline-client pipeline)) (pipeline-buffer pipeline)))

(defmacro pipeline ((&optional (client '*client*)) &body metrics)
  (with-gensyms (pipeline)
    `(let* ((,pipeline (make-instance 'pipeline :client ,client))
            (*client* ,pipeline))
       ,@metrics
       (pipeline-real-send ,pipeline))))
