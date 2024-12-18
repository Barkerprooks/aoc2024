(require "asdf")

(defun load-file-map (filename)
    ; unpacks the compressed string into an array of sectors / sizes
    (let ((id 0) (files nil))
        (loop :for i :from 0 :and n :across (uiop:read-file-string filename)
            do (if (evenp i)
                (progn
                    (push (cons (write-to-string id) (digit-char-p n)) files)
                    (setf id (+ id 1)))
                (push (cons "." (digit-char-p n)) files)))
        (make-array (length files) :initial-contents (reverse files))))

(defun dump-file-map (file-map-data)
    ; takes the (sym, size) for each number and dumps it into its string representation
    (let ((file-map nil))
        (loop :for data :across file-map-data
            do (loop :repeat (cdr data) do (push (car data) file-map)))
        (make-array (length file-map) :initial-contents (reverse file-map))))

(defun checksum (file-map n) 
    ; adds up all compressed numbers multiplied by their position
    (apply '+ (loop :for block :across file-map :and i :from 0 :below (- (length file-map) n)
        :if (string= block ".") collect 0 :else collect (* i (parse-integer block)))))

; part 1 functions
(defun free-blocks (file-map) 
    ; returns a list of indicies with free spots
    (loop :for i :from 0 :and file :across file-map :if (string= file ".") collect i))

(defun swap-blocks (file-map a b)
    ; swaps blocks given two positions
    (rotatef (aref file-map a) (aref file-map b)))

(defun last-non-null (file-map)
    ; return the last non-null element from the array
    (loop :for i :from (- (length file-map) 1) :downto 0 :and block :across (reverse file-map)
        :when (string/= block ".") return i))

(defun null-count (file-map)
    ; count does not work for some reason...
    (apply `+ (loop :for block :across file-map :when (string= block ".") collect 1)))

(defun is-space-optimized (file-map n)
    ; makes sure only blanks for the right side
    (loop :repeat n :for block :across (reverse file-map)
        :if (string/= block ".") return 0 :finally (return 1)))

(defun optimize-file-map (file-map)
    ; part 1 main function
    (let ((n (null-count file-map)))
        (loop :for freeblock :in (free-blocks file-map)
            :if (= (is-space-optimized file-map n) 1) return (checksum file-map n)
            :finally (return 0)
            do (swap-blocks file-map freeblock (last-non-null file-map)))))

; part 2 functions
(defun find-left-space (file-map n)
    ; returns -1 if no spaces are found
    (let ((empty 0))
        (loop :for block :across file-map :and i :from 0 :finally (return -1)
            do (if (string= block ".")
                (setf empty (+ empty 1)) ; empty++
                (if (> empty n) (return (- i empty)) ; return the needed index
                    ; else reset the counter
                    (setf empty 0))))))

(defparameter *file-map-data* (load-file-map "./day/9/test.txt"))
(print (find-left-space (dump-file-map *file-map-data*) 2)) ; testing

; (format t "part 1: ~a~%" (optimize-file-map (dump-file-map *file-map-data*)))