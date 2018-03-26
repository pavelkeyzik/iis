(deffunction myFunction (?from ?to $?non-used)
    (if (and (integerp ?from) (integerp ?to)) then
        (loop-for-count (?i ?from ?to) do
            (if (= (/ (mod ?i 10) 3) (div ?i 100)) then
                (format t "Chislo: %ld %n" ?i)
            )
        )
        (printout t "Non used: " ?non-used crlf)
    )
)

(myFunction 100 300 5 6 3)

(defgeneric pow-or-sum)

(defmethod pow-or-sum ((?a INTEGER) (?b INTEGER))
    (bind ?result 1)
    (loop-for-count (?i 1 ?b) do
        (bind ?result (* ?result ?a))  
    )
    (printout t "POW(" ?a "," ?b "): " ?result crlf)
)

(defmethod pow-or-sum ((?a FLOAT) (?b NUMBER))
    (printout t "You can't use float type for exponentiation number" crlf)
)

(defmethod pow-or-sum ((?a NUMBER) (?b FLOAT))
    (printout t "Degree of number can't be a float!" crlf)
)

(defmethod pow-or-sum ((?a NUMBER) (?b NUMBER) ($?c NUMBER (< (length ?c ) 8)))
    (bind ?sum (+ ?a ?b))
    (printout t "SUM OF: " ?a " + " ?b)
    (loop-for-count (?i 1 (length ?c)) do
        (bind ?sum (+ ?sum (nth$ ?i ?c)))
        (printout t " + " (nth$ ?i ?c))
    )
    (printout t " = " ?sum crlf)
)

(defmethod pow-or-sum ($?c)
    (printout t "I haven't got any methods for you" crlf)
)

(pow-or-sum 3 2)
(pow-or-sum 2.2 3.3 1 5 6 7)
(pow-or-sum 12 23 a3 b.4 c)
(pow-or-sum 2.2 3.3 1 5 6 7 8 9 10 11)

(exit)
