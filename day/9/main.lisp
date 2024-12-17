(require "asdf")

(defun load-map (filename)
    (let ((id 0) (files nil))
        (loop :for i :from 0 and n across (uiop:read-file-string filename)
            do (if (evenp i)
                (progn
                    (dotimes (_ (digit-char-p n)) (push (write-to-string id) files))
                    (setf id (+ id 1)))
                (dotimes (_ (digit-char-p n)) (push "." files))))
        files))

(defparameter *xs* (load-map "./day/9/test.txt"))
(dolist (x (reverse *xs*))
   (format t "~a" x))