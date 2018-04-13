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

(deffunction get-number (?max-count)
    (printout t "Enter number: ")
    (bind ?response (read))
    (if (integerp ?response)
        then ?response)

    (while (or (not (integerp ?response)) (> ?response ?max-count)) do
        (printout t "Please.. Enter number: ")
        (bind ?response (read))
        (if (integerp ?response)
            then ?response
        )
    )

    ?response
)

(deffunction print-header ()
    (printout t "***********************************" crlf)
    (printout t "* SELECT PROFESSION EXPERT SYSTEM *" crlf)
    (printout t "***********************************" crlf crlf)
)

(print-header)

(defrule are-you-plain-your-day
    (not (good-profession-is ?))
    =>
    (if (yes-or-no-p "Вы всегда чётко планируете свой день? (yes/no) ")
        then (assert (need to check details))
        else (assert (good-profession-is "Домохозяйка"))
    )
)

(defrule think-about-details
    (need to check details)
    =>
    (if (yes-or-no-p "Прежде чем действовать, надо продумать все детали? (yes/no) ")
        then (assert (what do you prefer))
        else (assert (landscape or nature))
    )
)

(defrule landscape-or-nature
    (landscape or nature)
    =>
    (printout t "Что вам больше по душе?" crlf
                "1 - Пейзажи" crlf
                "2 - Строение природы" crlf
    )
    (if (= (get-number 2) 1)
        then (assert (do you like draw))
        else (assert (work with earth animals or geography)))
)

(defrule do-you-like-draw
    (do you like draw)
    =>
    (if (yes-or-no-p "Вы любите рисовать? (yes/no) ")
        then (assert (good-profession-is "Художник пейзажей"))
        else (assert (good-profession-is "Фотограф пейзажей"))
    )
)

(defrule work-with-earth-animals-or-geography
    (work with earth animals or geography)
    =>
    (printout t "С чем больше хотели бы работать?" crlf
                "1 - Со строением земли" crlf
                "2 - С животными" crlf
                "3 - С географией" crlf
    )
    (switch (get-number 3)
        (case 1 then (assert (good-profession-is "Агроном")))
        (case 2 then (assert (do you have medicine skills)))
        (case 3 then (assert (flora fauna landscapes all)))
    )
)

(defrule do-you-have-medicine-skills
    (do you have medicine skills)
    =>
    (if (yes-or-no-p "Есть ли у вас медицинское образование или познания в этой области? (yes/no) ")
        then (assert (good-profession-is "Ветеринар"))
        else (assert (good-profession-is "Кинолог"))
    )
)

(defrule flora-fauna-landscapes-all
    (flora fauna landscapes all)
    =>
    (printout t "Что вам больше нравится?" crlf
                "1 - Флора" crlf
                "2 - Фауна" crlf
                "3 - Ландшафты" crlf
                "4 - Всё" crlf
    )
    (switch (get-number 4)
        (case 1 then (assert (good-profession-is "Океанология")))
        (case 2 then (assert (good-profession-is "Биогеография")))
        (case 3 then (assert (good-profession-is "Ландшафтоведение")))
        (case 4 then (assert (good-profession-is "Ландшафтоведение")))
    )
)

(defrule what-do-you-prefer
    (what do you prefer)
    =>
    (printout t "Что вам больше по душе?" crlf
                "1 - Техника" crlf
                "2 - Экономика" crlf)
    (switch (get-number 2)
        (case 1 then (assert (cars or computers)))
        (case 2 then (assert (people or paper)))
    )
)

(defrule cars-or-computers
    (cars or computers)
    =>
    (printout t "Автомобили или компьютеры?" crlf
                "1 - Автомобили" crlf
                "2 - Компьютеры" crlf)
    (switch (get-number 2)
        (case 1 then (assert (which gearbox do you have)))
        (case 2 then (assert (software or hardware)))
    )
)

(defrule which-gearbox-do-you-have
    (which gearbox do you have)
    =>
    (printout t "Какая коробка перключения передач в вашем автомобиле?" crlf
                "1 - Автоматическая" crlf
                "2 - Механическая" crlf)
    (switch (get-number 2)
        (case 1 then (assert (good-profession-is "Механик с уклоном на кузовные работы")))
        (case 2 then (assert (good-profession-is "Механик двигателей")))
    )
)

(defrule software-or-hardware
    (software or hardware)
    =>
    (printout t "Разработка программ или работа с аппаратным обеспечением?" crlf
                "1 - Разработка программ" crlf
                "2 - Работа с аппаратным обеспечением" crlf)
    (switch (get-number 2)
        (case 1 then (assert (good-profession-is "Разработчик программного обеспечения")))
        (case 2 then (assert (good-profession-is "Ремонтник компьютерного оборудования")))
    )
)

(defrule people-or-paper
    (people or paper)
    =>
    (printout t "С чем бы вы хотели работать?" crlf
                "1 - С людьми" crlf
                "2 - С бумагами" crlf)
    (switch (get-number 2)
        (case 1 then (assert (do you have experience with the property)))
        (case 2 then (assert (do you have experience in banking)))
    )
)

(defrule do-you-have-experience-with-the-property
    (do you have experience with the property)
    =>
    (if (yes-or-no-p "Есть ли познания в недвижимости? (yes/no) ")
        then (assert (good-profession-is "Риелтор"))
        else (assert (are you ready for frequent business trips))
    )
)

(defrule are-you-ready-for-frequent-business-trips
    (are you ready for frequent business trips)
    =>
    (if (yes-or-no-p "Готовы ли вы к частым командировкам? (yes/no) ")
        then (assert (good-profession-is "Аудитор"))
        else (assert (good-profession-is "Менеджер по продажам"))
    )
)

(defrule do-you-have-experience-in-banking
    (do you have experience in banking)
    =>
    (if (yes-or-no-p "Имеете ли вы опыт в банковском деле? (yes/no) ")
        then (assert (good-profession-is "Банкир"))
        else (assert (good-profession-is "Товаровед"))
    )
)

(defrule good-profession-is
    (good-profession-is ?xxx)
    =>
    (printout t crlf crlf "Вам подойдёт профессия: " ?xxx crlf)
)

(defrule restart-system
    (good-profession-is ?)
    =>
    (if (yes-or-no-p "Restart system? (yes/no) " )
        then
            (reset)
            (run)
    )
)

(reset)
(run)
(exit)
