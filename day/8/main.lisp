(require "asdf")

(defun load-matrix (filename)
    (let ((matrix `()))
        (loop for line in (uiop:read-file-lines filename) and y from 0
            do
            (push `() matrix)
            (loop for letter across line and x from 0
                do (if (letter) (push letter matrix))))
        matrix))

; load the file as a hash map of symbols and where they appear on the map
; we can just iterate through each finding their rise / run and placing
; anodes at the relevent points along the line
(defun load-antenae (matrix w h)
    (let ((antenae (make-hash-table)))
        (loop :for y :from 0 :to (- w 1)
            do (loop :for x :from 0 :to (- h 1)
                do (setf (gethash sym antenae) (cons (cons x y) (gethash sym antenae)))))
        antenae))

; slope formula given two tuples (x y) (x y)
(defun slope (v0 v1)
    (cons (- (car v0) (car v1)) (- (cdr v0) (cdr v1))))

; (maphash (lambda (sym pairs)
;     (loop for i from 0 to (- (length pairs) 1)
;         do (loop for j from 0 to (- (length pairs) 1) 
;             do (if (and (/= i j) (string/= sym ".")) 
;                 (format t "~a: ~a~%" sym (slope (nth i pairs) (nth j pairs)))))))
;     (load-antenae (load-matrix "./day/8/input.txt"))

(print (load-matrix "./day/8/input.txt"))