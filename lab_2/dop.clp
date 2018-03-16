(clear)

(defrule dop
    =>
    (loop-for-count (?i 100 999) do
        (if (= (/ (mod ?i 10) 3) (div ?i 100)) then
            (format t "Chislo: %ld %n" ?i)
        )
    ) 
)

(reset)
(run)
(exit)
