(clear)

(deffunction factorial (?a)
    (if (or (not (integerp ?a)) (< ?a 0))
        then
        (printout t "Factorial error!" crlf)
        else
        (if (= ?a 0)
            then 1
        else
            (* ?a (factorial (- ?a 1))))
    )
)

(defmethod pow ((?a INTEGER) (?b INTEGER))
    (bind ?result 1)
    (loop-for-count (?i 1 ?b) do
        (bind ?result (* ?result ?a))  
    )
    ?result
)

(deffunction iter (?n ?x)
    (if (and (integerp ?n) (integerp ?x)) then
        (bind ?sum 0)
        (loop-for-count (?i 0 ?n) do
            (bind ?sum (+ ?sum (* (/ (sin (pow ?i 2)) (factorial (+ (* 2 ?i) 1))) (pow ?x ?i))))
        )
        (printout t "SUM: " ?sum crlf)
    )
    ?sum
)

(defmethod count-of-symbolds ((?n INTEGER) ($?word SYMBOL))
    (bind ?count 0)
    (loop-for-count (?i 1 (length ?word)) do
        (if (= ?n (length(nth ?i ?word))) then
            (printout t "WORD: " (nth ?i ?word) crlf)
            (bind ?count (+ ?count 1))
        )
    )
    (printout t ?count crlf)
    ?count
)

(open "myfile" write "w")
(printout write (iter 5 2) crlf (count-of-symbolds 3 word for me and my fri) crlf)

(run)
(exit)
