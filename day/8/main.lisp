(let ((in (open "./day/8/input.txt")))
    (loop for line = (read-line in nil)
        while line do (format t "~a~%" line))
    (close in))

(dotimes (i 8)
    (format t "~a~%" i))