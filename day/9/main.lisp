(require "asdf") ; only need this for read-file-string lol

(defclass file-entry ()
    ((id :accessor file-entry-id :initarg :id)
        (size :accessor file-entry-size
            :initarg :size)))

(defun load-compressed (filename)
    ; unpacks the compressed string into an array of file entries
    (let ((id 0) (file-entries nil))
        (loop :for i :from 0 :and value :across (uiop:read-file-string filename)
            do (let ((n (digit-char-p value))) 
                (if (evenp i) ; first, we need to push the correct file-entry into the list
                    (progn
                        (push (make-instance `file-entry :id (write-to-string id) :size n) file-entries)
                        (setf id (+ id 1)))
                    (push (make-instance `file-entry :id "." :size n) file-entries))))
        ; export the list as an array going the correct direction
        (make-array (length file-entries) :initial-contents (reverse file-entries))))

(defun dump-file-entries (file-entries)
    ; dumps into a string representation map
    (let ((file-map nil))
        (loop :for file-entry :across file-entries
            do (loop :repeat (file-entry-size file-entry) 
                do (push (file-entry-id file-entry) file-map)))
        (make-array (length file-map) :initial-contents (reverse file-map))))

(defun checksum (file-map n) 
    ; adds up all numbers multiplied by their position
    (apply '+ (loop :for block :across file-map :and i :from 0 :below (- (length file-map) n)
        :if (string= block ".") collect 0 :else collect (* i (parse-integer block)))))

(defun swap (xs a b)
    ; swaps array given two positions
    (rotatef (aref xs a) (aref xs b)))

; part 1 functions

(defun free-blocks (file-map) 
    ; returns a list of indicies with free spots
    (loop :for i :from 0 :and file :across file-map :if (string= file ".") collect i))

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
            do (swap file-map freeblock (last-non-null file-map)))))

; part 2 functions

(defun non-null-entries (file-entries)
    ; gets list of entries in reverse order
    (loop :for file-entry :across (reverse file-entries)
        :if (string/= (file-entry-id file-entry) ".") 
            collect (file-entry-id file-entry)))

(defun find-id (file-entries id)
    (loop :for file-entry :across file-entries :and i :from 0
        :if (string= (file-entry-id file-entry) id)
            return i))

(defun find-left-space (file-entries b)
    ; starts from the left and finds the first free entry that has enough space
    (loop :for file-entry :across file-entries :and i :from 0
        :if (and 
                (string= (file-entry-id file-entry) ".")
                (>= (file-entry-size file-entry) (file-entry-size (aref file-entries b)))) 
            return i
        :finally (return -1)))

(defun insert-new-space (file-entries i size)
    ; inserts a new empty space in the middle of the array
    (let ((file-entry (make-instance `file-entry :id "." :size size)))
        (concatenate `vector
            (subseq file-entries 0 (+ i size))
            (cons file-entry nil)
            (subseq file-entries (+ i size)))))
    

(defun file-size-diff (file-entries a b)
    ; a should always be an empty space
    (- (file-entry-size (aref file-entries a)) (file-entry-size (aref file-entries b))))

(defun swap-left-space (file-entries a b)
    (let ((size (file-size-diff file-entries a b)) (null-space (aref file-entries a)))
        (if (> size 0)
            (progn ; more than enough space
                (setf (file-entry-size null-space) (- (file-entry-size null-space) size))
                (swap file-entries a b) ; swap
                (setf file-entries (insert-new-space file-entries a size)))
            (swap file-entries a b))) ; else just swap
    file-entries)

(defun optimize-file-entries (file-entries)
    (loop :for id :in (non-null-entries file-entries) 
        do (let* ((b (find-id file-entries id)) (a (find-left-space file-entries b)))
                (if (and (>= a 0) (>= b a))
                    (setf file-entries (swap-left-space file-entries a b)))))
    (dump-file-entries file-entries))

(defparameter *file-entries* (load-compressed "./day/9/input.txt"))

(let ((file-map (optimize-file-entries *file-entries*)))
    (format t "~a~%" (checksum file-map 1)))

; (format t "part 1: ~a~%" (optimize-file-map (dump-file-entries *file-entries*)))