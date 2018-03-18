; Объявление переменных
(defglobal
    ?*x* = 3
    ?*y* = ?*x*
    ?*z* = (+ ?*x* ?*y*)
    ?*q* = (create$ a b c) ; Объявление составного поля
)

(defglobal
    ?*d* = 7.8
    ?*e* = "string"
    ?*f* = symbol
)

(bind ?*x* 4)               ; Устанавливает новое значение для переменной x - 2
(list-defglobals)           ; Вывод всех объявленных переменных
(ppdefglobal x)             ; Вывод определения переменной

(deffunction print-args (?a ?b $?c)
    (printout t ?a " " ?b " " (length ?c) " extras: " ?c crlf)
)

(print-args 1 2)
(print-args a b c d)
; (print-args a)            ; Ошибка, так как нужно 2 параметра передать

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

(deffunction foo ())
(deffunction bar ()
    (foo))
(deffunction foo()
    (bar))

(factorial 5)

(exit)
