(require "asdf")

; unpacks the compressed string into its actual representation
(defun load-file-map (filename)
    (let ((id 0) (files nil))
        (loop :for i :from 0 and n across (uiop:read-file-string filename)
            do (if (evenp i)
                (progn
                    (dotimes (_ (digit-char-p n)) (push (write-to-string id) files))
                    (setf id (+ id 1)))
                (dotimes (_ (digit-char-p n)) (push "." files))))
        (reverse files)))

; TODO
; returns a list of spaces with free spots
(defun free-blocks (file-map) ())

; show the list
(dolist (x (load-file-map "./day/9/test.txt"))
   (format t "~a" x))
(format t "~%")