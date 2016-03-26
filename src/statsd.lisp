(in-package :cl-statsd)

(defvar *client*)

(defun counter (key value &key (rate) (client *client*))
  (send client :counter key value rate))

(defun inc (key &key (rate) (client *client*))
  (send client :counter key 1 rate))

(defun dec (key &key (rate) (client *client*))
  (send client :counter key -1 rate))

(defun timing (key value &key (rate) (client *client*))
  (send client :timing key value rate))

(defun guage (key value &key (rate) (client *client*))
  (send client :guage key value rate))

(defun set (key value &key (rate) (client *client*))
  (send client :set key value rate))

(defun with-timing% (client key lambda)
  (multiple-value-bind (sec1 nsec1) (local-time::%get-current-time)
     (multiple-value-prog1
         (funcall lambda)
       (multiple-value-bind (sec2 nsec2) (local-time::%get-current-time)
         (let ((msec-d  (floor (- nsec2 nsec1) 1000000))
               (sec-d (- sec2 sec1)))
           (when (< msec-d 0)
             (decf sec-d)
             (incf msec-d 1000))
           (timing key (+ (* sec-d 1000) msec-d) :client client))))))

(defmacro with-timing ((key &optional (client '*client*)) &body body)
  `(with-timing% ,client ,key (lambda () ,@body)))
