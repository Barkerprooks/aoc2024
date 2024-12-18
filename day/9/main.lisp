(require "asdf") ; only need this for read-file-string lol

(defclass file-entry ()
    ((id :accessor file-entry-id :initarg :id)
        (offset :accessor file-entry-offset
            :initarg :offset)
        (size :accessor file-entry-size
            :initarg :size)))

(defun load-compressed (filename)
    ; unpacks the compressed string into an array of file entries
    (let ((id 0) (offset 0) (file-entries nil))
        (loop :for i :from 0 :and value :across (uiop:read-file-string filename)
            do (let ((n (digit-char-p value))) 
                (if (evenp i) ; first, we need to push the correct file-entry into the list
                    (progn
                        (push (make-instance `file-entry :id (write-to-string id) :offset offset :size n) file-entries)
                        (setf id (+ id 1)))
                    (push (make-instance `file-entry :id "." :offset offset :size n) file-entries))
                (loop :repeat n do (incf offset))))
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

(defun find-left-space (file-entries n)
    ; starts from the left and finds the first free entry that has enough space
    (loop :for file-entry :across file-entries
        :if (and (string= (file-entry-id file-entry) ".") (>= (file-entry-size file-entry) n)) 
            return (file-entry-offset file-entry)
        :finally (return 0)))

(defun swap-left-space (file-entries a b)
    ; this should be taking an empty space as the left side
    ; and a regular id as the right side.
    
    ; right side size stays the same
    ; if the left size is larger than the right side:
    ;   add new empty file-entry w left - right size
    ; left size gets set to right side
    ; swap indicies
    ())

(defun optimize-file-entries (file-entries)
    ; the idea behind this is to:
    ;  1st - go backwards through the entries, 
    ;        find the leftmost empty space long enough to accomodate
    ;        the current file id
    ;  2nd - swap file entries:
    ;        NOTE: IF the space is bigger than the file entry, create a new empty space
    ;        behind the current position 
    )

(defparameter *file-entries* (load-compressed "./day/9/test.txt"))

(format t "~a~%" (find-left-space *file-entries* 2))

; (format t "part 1: ~a~%" (optimize-file-map (dump-file-entries *file-entries*)))