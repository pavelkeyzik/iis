(deftemplate Profession
    (multislot name (type STRING) (default ?NONE))            ; Название профессии      
    (slot salary (type NUMBER) (range 0 ?VARIABLE))           ; Заработная плата
    (slot mainly (type SYMBOL) (allowed-symbols male female)) ; Больше работников м/ж пола
)

(deffacts FactsAboutProfessions "Adding sorted facts about professions"
    (Front-end work it's about user interactivity)
    (Back-end work it's about user data and site functionality)
    (UX/UI it's about prototyping and design site interface)
    (HR-Manager it's about human resource managment)
    (Recruter works with resume)
)

(deffacts ProfessionsDataBase "Adding professions to the facts"
    (Profession (name "Front-end Developer")
                (salary 12800)
                (mainly male))
    (Profession (name "Back-end Developer")
                (salary 18800)
                (mainly male))
    (Profession (name "UX/UI Designer")
                (salary 8000)
                (mainly female))
    (Profession (name "HR Manager")
                (salary 7000)
                (mainly female))
    (Profession (name "Recruter")
                (salary 7000)
                (mainly female))
)

(reset)

(facts)
(run)
(exit)
