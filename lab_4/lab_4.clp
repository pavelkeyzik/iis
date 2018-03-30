; Экспертная система по выбору профессии
; для последующего трудоустройства

(clear)

; шаблон Профессии
(deftemplate Profession
    
    ; Название должности (Например: Front-end developer)
    (multislot position (type SYMBOL) (cardinality 1 5))
    
    ; Это начало карьеры? Да или Нет
    (slot is-start-of-career (allowed-values yes no))
    
    ; Профессиональная область (Например: "Информационные технологии" или "Автомобильный бизнес")
    (slot professional-area (type STRING))
    
    ; Желаемая зарплата в долларах (Например: 90 или 99.99)
    (slot salary (type NUMBER))
    
    ; Занятость
    (slot employment (allowed-values
                        "Full Employment"           ; Полная занятость
                        "Part-time Employment"      ; Частичная занятость
                        "Project Work"              ; Временная/проектная работа
                        "Volunteering"              ; Волонтерство
                        "Internship"                ; Стажировка
                    )
    )
    
    ; График работы
    (slot schedule (allowed-values
                        "Full day"                  ; Полный день
                        "Shift work"                ; Сменный График
                        "Flexible schedule"         ; Гибкий график
                        "Remote work"               ; Удаленная работа
                    )
    )

    ; Расположение (Например: Беларусь Минск )
    (multislot location (type SYMBOL))
)

; Факты системы
(deffacts Professions-Facts
)

; Функция для запроса данных
(deffunction ask-question (?question $?allowed-values)
    (printout t ?question ": ")
    (bind ?answer (lowcase (read)))
    (while (not (member$ ?answer ?allowed-values))
        (printout t ">> ERR:: Repeat please!" crlf ?question ": ")
        (bind ?answer (lowcase (read)))
    )
    ?answer
)

(deffunction header-print ()
    (printout t "-----------------------------------" crlf)
    (printout t "| SELECT PROFESSION EXPERT SYSTEM |" crlf)
    (printout t "-----------------------------------" crlf crlf)
)

(defmethod set-salary ((?x NUMBER))
    (if (>= ?x 0) then ?x)
)

; Это начало вашей карьеры?
(defrule startOfCareer
    (declare (salience 15))
    =>
    (bind ?response (ask-question "It's start of career? (yes/no)" yes no))
    (if (eq ?response yes)
        then
        (bind ?answer yes)
        else
        (bind ?answer no)
    )
)

; Какую зарплату вы хотели бы
(defrule salary
    (declare (salience 14))
    =>
    (printout t "What salary do you want (0 or more)?:")
    (bind ?response (read))
    (while (or (not (numberp ?response)) (not (>= ?response 0)))
        (printout t "ERR:: Repeat please!" crlf "What salary do you want (0 or more)?: ")
        (bind ?response (read))
    )
)

(header-print)
(reset)
(run)
(exit)
