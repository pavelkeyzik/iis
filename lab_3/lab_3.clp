(deffunction myFunction (?from ?to $?non-used)
    (loop-for-count (?i ?from ?to) do
        (if (= (/ (mod ?i 10) 3) (div ?i 100)) then
            (format t "Chislo: %ld %n" ?i)
        )
    )
    (printout t "Non used: " ?non-used crlf)
)

(myFunction 100 300 5 6 3)

(defgeneric pow)
(defmethod pow (?a ?b)
    (printout t ">> " (* ?a ?b) crlf)
)

(defmethod pow (?a ?b $?c)
    (printout t "** " (* ?a ?b) " - " ?c crlf)
)

(pow 2 3)
(pow 2 3 4 5 6)

(exit)
