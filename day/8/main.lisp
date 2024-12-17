(require "asdf")

; load chars into memory for matrix math
(defun load-matrix (filename)
    (let ((matrix nil))
        (loop :for line :in (uiop:read-file-lines filename)
            do (push (coerce line `list) matrix))
        matrix))

; adds a 2-tuple to a hash table
(defun add-v2 (sym x y table) 
    (setf (gethash sym table) (cons (cons x y) (gethash sym table))))

; load the file as a hash map of symbols and where they appear on the map
; we can just iterate through each finding their rise / run and placing
; hashes at the relevent points along the slope line
(defun load-antenae (matrix)
    (let ((antenae (make-hash-table)))
        (loop :for row :in matrix and y :from 0
            do (loop :for sym :in row and x :from 0 
                :if (string/= sym ".")
                do (add-v2 sym x y antenae)))
        antenae))

; slope formula given two tuples (x y) (x y)
(defun get-slope (v0 v1)
    (cons (- (car v0) (car v1)) (- (cdr v0) (cdr v1))))

(defun set-anode (v matrix)
    (setf (nth (car v) (nth (cdr v) matrix)) "#"))

(defun mul-slope (v x)
    (cons (* (car v) x) (* (cdr v) x)))

; apply anode to pair of points
(defun apply-anodes (v0 v1 matrix w h)
    (let ((s0 (get-slope v0 v1)))
        (loop :for y :from (+ (cdr v0) (cdr s0)) :to h 
            :step (cdr s0)
            do (format t "~a~%" y))))

(defparameter *M* (load-matrix "./day/8/input.txt"))
(defparameter *H* (length *M*))
(defparameter *W* (length (nth 0 *M*)))

(maphash (lambda (sym vs)
    (loop :for v0 :in vs and i :from 0 do
        (loop :for v1 :in vs and j :from 0 :if (and (/= i j)) 
            do 
            (apply-anodes v (nth j vs) *M* *W* *H*)
            (format t "~%"))))
    (load-antenae *M*))