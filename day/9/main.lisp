(require "asdf")

; unpacks the compressed string into its actual representation
(defun load-file-map (filename)
    (let ((id 0) (files nil))
        (loop :for i :from 0 :and n :across (uiop:read-file-string filename)
            do (if (evenp i)
                (progn
                    (dotimes (_ (digit-char-p n)) (push (write-to-string id) files))
                    (setf id (+ id 1)))
                (dotimes (_ (digit-char-p n)) (push "." files))))
        (make-array (length files) :initial-contents (reverse files))))

; returns a list of indicies with free spots
(defun free-blocks (file-map) 
    (loop :for i :from 0 :and file :across file-map :if (string= file ".") collect i))

; swaps blocks given two positions
(defun swap-blocks (file-map a b)
    (rotatef (aref file-map a) (aref file-map b)))

; return the last non-null element from the array
(defun last-non-null (file-map)
    (loop :for i :from (- (length file-map) 1) :downto 0
        :and block :across (reverse file-map)
        :when (string/= block ".")
            return i))

(defparameter *file-map* (load-file-map "./day/9/test.txt"))

(loop :for block :across *file-map* 
    do (format t "~a" block))
(format t "~%")

(format t "~a~%" (free-blocks *file-map*))

(loop :for freeblock :in (free-blocks *file-map*)
    do (progn
        (swap-blocks *file-map* freeblock (last-non-null *file-map*)))
        (progn 
            (loop :for block :across *file-map* 
                do (format t "~a" block))
            (format t "~%")))

(loop :for block :across *file-map* 
    do (format t "~a" block))
(format t "~%")