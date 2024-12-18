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

(defun null-count (file-map) ; (count ...) does not work for some reason...
    (apply `+ (loop :for block :across file-map :when (string= block ".") collect 1)))

(defun is-space-optimized (file-map n) ; makes sure only blanks for the right side
    (loop :repeat n :for block :across (reverse file-map)
        :if (string/= block ".") return 0 :finally (return 1)))

(defun checksum (file-map n) ; adds up all compressed numbers multiplied by their position
    (apply '+ (loop :for block :across file-map :and i :from 0 :below (- (length file-map) n)
        :if (string= block ".") collect 0 :else collect (* i (parse-integer block)))))

(defun optimize-file-map (file-map) ; main function
    (let ((n (null-count file-map)))
        (loop :for freeblock :in (free-blocks file-map)
            :if (= (is-space-optimized file-map n) 1) return (checksum file-map n)
            do (swap-blocks file-map freeblock (last-non-null file-map)))))

(format t "part 1: ~a~%" (optimize-file-map (load-file-map "./day/9/input.txt")))