;; ; Экспертная система по выбору профессии
;; ; для последующего трудоустройства

;; (clear)

;; ; шаблон Профессии
;; (deftemplate Profession
    
;;     ; Название должности (Например: Front-end developer)
;;     (multislot position (type SYMBOL) (cardinality 1 5))
    
;;     ; Это начало карьеры? Да или Нет
;;     (slot is-start-of-career (allowed-values yes no))
    
;;     ; Профессиональная область (Например: "Информационные технологии" или "Автомобильный бизнес")
;;     (slot professional-area (type STRING))
    
;;     ; Желаемая зарплата в долларах (Например: 90 или 99.99)
;;     (slot salary (type NUMBER))
    
;;     ; Занятость
;;     (slot employment (allowed-values
;;                         "Full Employment"           ; Полная занятость
;;                         "Part-time Employment"      ; Частичная занятость
;;                         "Project Work"              ; Временная/проектная работа
;;                         "Volunteering"              ; Волонтерство
;;                         "Internship"                ; Стажировка
;;                     )
;;     )
    
;;     ; График работы
;;     (slot schedule (allowed-values
;;                         "Full day"                  ; Полный день
;;                         "Shift work"                ; Сменный График
;;                         "Flexible schedule"         ; Гибкий график
;;                         "Remote work"               ; Удаленная работа
;;                     )
;;     )

;;     ; Расположение (Например: Беларусь Минск )
;;     (multislot location (type SYMBOL))
;; )

;; ; Факты системы
;; (deffacts Professions-Facts
;; )

;; ; Функция для запроса данных
;; (deffunction ask-question (?question $?allowed-values)
;;     (printout t ?question ": ")
;;     (bind ?answer (lowcase (read)))
;;     (while (not (member$ ?answer ?allowed-values))
;;         (printout t ">> ERR:: Repeat please!" crlf ?question ": ")
;;         (bind ?answer (lowcase (read)))
;;     )
;;     ?answer
;; )

;; (deffunction header-print ()
;;     (printout t "-----------------------------------" crlf)
;;     (printout t "| SELECT PROFESSION EXPERT SYSTEM |" crlf)
;;     (printout t "-----------------------------------" crlf crlf)
;; )

;; (defmethod set-salary ((?x NUMBER))
;;     (if (>= ?x 0) then ?x)
;; )

;; ; Это начало вашей карьеры?
;; (defrule startOfCareer
;;     (declare (salience 15))
;;     =>
;;     (bind ?response (ask-question "It's start of career? (yes/no)" yes no))
;;     (if (eq ?response yes)
;;         then
;;         (bind ?answer yes)
;;         else
;;         (bind ?answer no)
;;     )
;; )

;; ; Какую зарплату вы хотели бы
;; (defrule salary
;;     (declare (salience 14))
;;     =>
;;     (printout t "What salary do you want (0 or more)?:")
;;     (bind ?response (read))
;;     (while (or (not (numberp ?response)) (not (>= ?response 0)))
;;         (printout t "ERR:: Repeat please!" crlf "What salary do you want (0 or more)?: ")
;;         (bind ?response (read))
;;     )
;; )

;; (header-print)
;; (reset)
;; (run)
;; (exit)

(clear)

(deffunction ask-question (?question $?allowed-values)
    (printout t ?question)
    (bind ?answer (read))
    
    (if (lexemep ?answer)
        then
        (bind ?answer (lowcase ?answer)))
    
    (while (not (member ?answer ?allowed-values)) do
        (printout t ?question)
        (bind ?answer (read))
        (if (lexemep ?answer)
            then
            (bind ?answer (lowcase ?answer))))
    ?answer
)


(deffunction yes-or-no-p (?question)
    (bind ?response (ask-question ?question yes no y n))
    (if (or (eq ?response yes) (eq ?response y)) 
    then
        TRUE
    else
        FALSE
    )
)

(defrule determine-engine-state
    (not (working-state engine ?))
    (not (repair ?))
    =>
    (if (yes-or-no-p "Does the engine start (yes/no)? ")
        then
        (if (yes-or-no-p "Does the engine run normally (yes/no)? ")
            then
                (assert (working-state engine normal))
            else
                (assert (working-state engine unsatisfactory)))
        else
        (assert (working-state engine does-not-start)))
)

(defrule determine-rotation-state
    (working-state engine does-not-start)
    (not (rotation-state engine ?))
    (not (repair ?))
    =>
    (if (yes-or-no-p "Does the engine rotate (yes/no)? ")
        then
            ; Двигатель вращается
            (assert (rotation-state engine rotates))
            ; Плохая искра
            (assert (spark-state engine irregular-spark))
        else
            ; Двигатель не вращается
            (assert (Dotation-state engine does-not-rotate))
            ; Нет искры
            (assert (spark-state engine does-not-spark)))
)

(defrule determine-gas-level
    (working-state engine does-not-start)
    (rotation-state engine rotates)
    (not (repair ?))
    =>
    (if (not (yes-or-no-p "Does the tank have any gas in it (yes/no)? "))
    then
    (assert (repair "Add gas.")))
)

(defrule determine-battery-state
    (rotation-state engine does-not-rotate)
    (not (charge-state battery ?))
    (not (repair ?))
    =>
    (if (yes-or-no-p "Is the battery charged (yes/no)? ")
    then
    ; Аккумулятор заряжен
    (assert (charge-state battery charged))
    else
    ; Зарядите аккумулятор
    (assert (repair "Charge the battery."))
    ; Аккумулятор разряжен
    (assert (charge-state battery dead)))
)

(defrule determine-low-output
    (working-state engine unsatisfactory)
    ; Мощность работы двигателя еще не определена
    (not (symptom engine low-output I not-low-output))
    (not (repair ?))
    =>
    (if (yes-or-no-p "Is the output of the engine low (yes/no)?")
    then
        ; Низкая выходная мощность двигателя
        (assert (symptom engine low-output))
    else
        ; Нормальная выходная мощность двигателя
        (assert (symptom engine not-low-output)))
)

(defrule determine-point-surface-state
    (or (and (working-state engine does-not-start)
    ; не заводится
    (spark-state engine irregular-spark))
    ; и плохая искра
    (symptom engine low-output))
    ; или низкая мощность
    (not (repair ?))
    =>
    (bind ?response (ask-question "What is the surface state of the points (normal /burned /contaminated)?" normal burned contaminated))
    (if (eq ?response burned)
    then
    ; Контакты опалены — замените контакты
    (assert (repair "Replace the points."))
    else
    (if (eq ?response contaminated)
    then
    ; Контакты загрязнены - почистите их
    (assert (repair "Clean the points."))))
)

(defrule determine-conductivity-test
    (working-state engine does-not-start)
    (spark-state engine does-not-spark)
    ;нет искры
    (charge-state battery charged)
    ;аккумулятор заряжен
    (not (repair ?))
    =>
    (if (yes-or-no-p "Is the conductivity test for the ignition coil positive(yes/no)? ")
        then
        ; Замените распределительные провода
        (assert (repair "Repair the distributor lead wire."))
    else
        ; Замените катушку зажигания
        (assert (repair "Replace the ignition coil.")))
)

(defrule determine-sluggishness
    (working-state engine unsatisfactory)
    (not (repair ?))
    =>
    (if (yes-or-no-p "Is the engine sluggish (yes/no)? ")
        then
            ; Прочистите систему подачи топлива
            (assert (repair "Clean the fuel line.")))
)

(defrule determine-misfiring
    (working-state engine unsatisfactory)
    (not (repair ?))
    =>
    (if (yes-or-no-p "Does the engine misfire (yes/no)? ")
    then
        ; Отрегулируйте зазоры между контактами
        (assert (repair "Point gap adjustment."))
        ; Плохая искра
        (assert (spark-state engine irregular-spark)))
)

(defrule determine-knocking
    (working-state engine unsatisfactory)
    (not (repair ?))
    =>
    (if (yes-or-no-p "Does the engine knock (yes/no)? ")
        then
        ; Отрегулируйте положение зажигания
        (assert (repair "Timing adjustment.")))
)

(defrule normal-engine-state-conclusions
    (declare (salience 10))
    (working-state engine normal)
    =>
    ; то
    (assert (repair "No repair needed."))
    ; ремонт не нужен
    (assert (spark-state engine normal))
    ; зажигание в норме
    (assert (charge-state battery charged))
    ; аккумулятор заряжен
    (assert (rotation-state engine rotates))
    ; двигатель вращается
)

; Правило unsatisfactory-engine-state-conclusions реализует правило 3.
(defrule unsatisfactory-engine-state-conclusions
    (declare (salience 10))
    ; Если двигатель работает нормально
    (working-state engine unsatisfactory)
    =>
    ; то
    (assert (charge-state battery charged))
    ; аккумулятор заряжен
    (assert (rotation-state engine rotates))
    ; двигатель вращается
)

(defrule no-repairs
    (declare (salience -10))
    (not (repair ?))
    =>
    (assert (repair "Take your car to a mechanic."))
)

(defrule print-repair
    (declare (salience 10))
    (repair ?item)
    =>
    (printout t crlf crlf)
    (printout t "Suggested Repair:")
    (printout t crlf crlf)
    (format t " %s%n%n%n" ?item)
)

(defrule system-banner
    (declare (salience 10))
    =>
    ; каждом новом запуске.
    (printout t crlf crlf)
    (printout t "****************************************" crlf)
    (printout t "* The Engine Diagnosis Expert System   *" crlf)
    (printout t "****************************************" crlf)
    (printout t crlf crlf)
)

(defrule restart-system
    (repair ?)
    =>
    (if (yes-or-no-p "Restart system? (yes/no)" )
        then
            (reset)
            (run)
    )
)

(reset)
(run)
(exit)
