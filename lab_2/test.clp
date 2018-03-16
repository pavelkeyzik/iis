; Тестирование по методическим указаниям

(clear)                                             ; Очищаем систему. Факты, правила и всё-всё-всё

; Создание правила
(defrule
    Hello-World                                     ; Название правила
    "Программа приветствия"                         ; Комментарий
    =>                                              ; Символ разделения LHS и RHS
    (printout t "---------" crlf)                   ; printout - функция для вывода
    (printout t "- HELLO -" crlf)                   ; t - стандартные поток вывода - экран
    (printout t "---------" crlf)                   ; crlf - перенос на новую строку
)

(defrule
    Here-Nothing
    "В правой части ничего нет"                     ; Если в правой части ничего нет, то всё ОК. Просто ничего не произойдёт
    =>
)

; Чтобы заново запустить программу пишем подряд команды 
; (reset)
; (run)

(defrule
    Salience-Rule
    (declare (salience 1))                          ; declare служит для описание характеристик правила. МОЖЕТ БЫТЬ ТОЛЬКО ОДИН declare в правиле
                                                    ; salience устанавливает приоритет. По умолчанию 0. Можно указать от -10 000 до +10 000
                                                    ; Чем ниже приоритет, тем позже выполнится правило
    =>
    ;(printout t "Я буду первым!" crlf)
)

(set-strategy breadth)                               ; Устанавливает стратегию разрешения конфликтов
                                                    ; - глубины (depth strategy) ПО УМОЛЧАНИЮ
                                                    ; - Ширины (breadth strategy)
                                                    ; - Упрощения (simplicity strategy)
                                                    ; - Усложнения (complexity strategy)
                                                    ; - LEX
                                                    ; - MEA
                                                    ; - Случайная (random strategy)


; > (start) ПРАВИЛА ДЛЯ ТЕСТИРОВАНИЯ salience-evaluation

(defglobal ?*variable* = 2);                        ; Объявили переменную, которую потом поменяем

(defrule
    Salience-evaluation-1
    (declare (salience 1))
    =>
    (printout t "SALIENCE EVAL 1" crlf)
)

(defrule
    Salience-evaluation-2
    (declare (salience ?*variable*))                ; Заюзали её тут
    =>
    (printout t "SALIENCE EVAL 2" crlf)
)

(defrule
    Salience-evaluation-3
    (declare (salience 3))
    =>
    (printout t "SALIENCE EVAL 3" crlf)
)

; < (end) ПРАВИЛА ДЛЯ ТЕСТИРОВАНИЯ salience-evaluation

; > (start) ТЕСТИРОВАНИЕ salience-evaluation
(set-salience-evaluation when-defined)              ; Говорит clips-у когда вычислять значение приоритета
                                                    ; when-defined - При добавлении нового правила
                                                    ; when-activated - При активации правила
                                                    ; every-cycle - на каждом шаге основного цикла выполнения правил

(printout t "__ (start) When defined..." crlf)
(reset)
(run)
(printout t "__ (end) When defined..." crlf crlf)

(defglobal ?*variable* = 0);                        ; Тут мы изменяем на 0. Следовательно при добавлении факта приоритет будет 0
(printout t "__ (start) When activated..." crlf)
(set-salience-evaluation when-activated)
(reset)
(run)
(printout t "__ (end) When activated..." crlf crlf)

(printout t "__ (start) Every cycle..." crlf)       ; Every-cycle такой как activated, только пересчитывает на каждой итерации
(set-salience-evaluation every-cycle)
(reset)
(run)
(printout t "__ (end) Every cycle..." crlf crlf)

; < (end) ТЕСТИРОВАНИЕ salience-evaluation

(reset)                                             ; Удаляем факты и добавляем initial-fact, так как defrule по умолчанию
                                                    ; сработает только когда будет добавлен inital-fact или initial-object
(clear)
(printout t crlf crlf crlf ">>>>>>> 2 SECTION >>>>>>>" crlf)
;; РАЗДЕЛ 2
(deffacts data-facts
    (data 1.0 blue "red")
    (data 1 blue)
    (data 1 blue red)
    (data 1 blue RED)
    (data 1 blue red 6.9)    
)

(deftemplate person
    (slot name)
    (slot age)
    (multislot friends)
)

(deffacts people
    (person (name Job) (age 20))
    (person (name Bob) (age 20))
    (person (name Joe) (age 34))
    (person (name Sue) (age 34))
    (person (name Sue) (age 20))
)

(defrule Find-data
    (data 1 blue red)
    =>
    (printout t crlf "Found data (data 1 blue red)" crlf)
)

(defrule Find-Bob-20
    (person (name Bob) (age 20))
    =>
    (printout t crlf "Found Bob-20 (person (name Bob) (age 20))" crlf)    
)

(defrule Find-Bob-30
    (person (name Bob) (age 30))
    =>
    (printout t crlf "Found Bob-30 (person (name Bob) (age 30))" crlf)
)

; ? - какое-то значение
; $? - какое-то значение или ничего

(defrule Find-data
    (data ? blue red $?)
    =>
    (printout t crlf "FIND DATA WITH GROUP SYMBOLS" crlf)
)

(defrule match-all-persons
    (person
        (name ?)
        (age ?)
        (friends $?))
    =>
    (printout t crlf "MATCH ALL PERSONS" crlf)
)

(defrule match
    (data $? YELLOW $?)
    =>
)

(defrule Find-data
    (data ? blue ?x $?y)
    =>
    (printout t "Found data (data ? blue " ?x " " ?y ")" crlf)
)

(defrule Find-data
    (data ?x $?y ?z)
    =>
    (printout t "x=" ?x " y=" ?y " z=" ?z crlf)
)

(defrule Find-2-Coeval-Person
    (person (name ?x) (age ?z))
    (person (name ?y) (age ?z))
    =>
    (printout t "name=" ?x " name=" ?y " age=" ?z crlf)
)

(defrule Find-data
    (data ?x&:(floatp ?x)&:(> ?x 0) $?y ?z&:(stringp ?z))
    =>
    (printout t "x=" ?x " y=" ?y " z=" ?z crlf)
)

(reset)

(assert (data 1 2)
        (data 2 4)
        (data 9 15)
)

;; (defrule example
;;     (data ?x ?y)
;;     (test (>= (abs (- ?x ?y) ) 3))
;;     =>
;;     (printout t ">>> EXAMPLE EEEE" crlf)
;; )

(assert (error-status unknown))
(assert (valve broken))
(assert (pump off))

(defrule system-fault
    (error-status unknown)
    (or (temp high)
        (valve broken)
        (pump off))
    =>
    (printout t ">>> system-fault >>>" crlf)
)

(defrule system-flow
    (error-status unknown)
    (and (valve broken)
         (pump off))
    =>
    (printout t "<<< system-flow >>>" crlf)
)

(defrule high-flow-rate
    (pump off)
    (not (error-status confirm))
    =>
    (printout t "<<< hight-flow-rate >>>" crlf)
)

(defrule example
    (exists (data 1 2))
    =>
    (printout t ">>> EXAMPLE NOT <<<" crlf)    
)

(defrule example-forall
    (forall (person (name ?a) (age ?b)))
    =>
    (printout t "xxxxXXXxxxx" crlf)
)

(defrule example-logical
    (logical (data 1 2))
    =>
    (printout t "XXXXX" crlf)
)

(agenda)
(facts)
(run 2)                                               ; Запускает логическое выполнение программы
(list-defrules)
(printout t "___ LOL >>>>>" crlf)
(ppdefrule Find-data)
(printout t "___ LOL <<<<<" crlf)
(undefrule *)
(list-defrules)
(exit)                                              ; Выход из программы
