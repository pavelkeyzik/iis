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

(run)                                               ; Запускает логическое выполнение программы
(exit)                                              ; Выход из программы
