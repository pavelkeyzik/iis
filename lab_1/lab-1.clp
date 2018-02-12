(defglobal ?*variable* = 5)

(deftemplate Profession
    (multislot name (type SYMBOL) (cardinality 1 5))      
    (slot salary (type NUMBER) (default-dynamic ?*variable*))
    (slot worktype (type SYMBOL) (allowed-symbols remote office))
    (slot year (type INTEGER) (default ?*variable*))
)

(defglobal ?*variable* = 15)

(deffacts FactsAboutProfessions "Adding ordered facts about professions"
    (Front-end work it's about user interactivity)
    (Back-end work it's about user data and site functionality)
    (UX/UI it's about prototyping and design site interface)
)

(deffacts ProfessionsDataBase "Adding professions to the facts"
    (Profession (name Front-end Developer)
                (salary (+ 15 20))
                (worktype remote))
    (Profession (name Back-end Developer)
                (worktype remote))
    (Profession (name UX/UI Designer)
                (salary 8000)
                (worktype office))
)


(reset)

(assert (Recruter works with resume)
        (HR-Manager it's about human resource managment)
        )

(assert (Profession (name HR Manager)
                    (worktype office))
        (Profession (name Recruter)
                    (salary 7000)
                    (worktype office)))

(assert (fac asdasd asd sa)
        (asd asd as dasd)
        (asd asd as dasd))

(retract (- (+ (* 3 4) 2) 2))

(duplicate 6 (salary 7000))

(modify 4 (name Full-Stack))

(assert-string "(asd \"asdasd\" asd \"as\" da)")

(fact-relation 10)
(fact-slot-names 6)
(fact-slot-value 14 worktype)

(save-facts filename.txt visible)

(facts)
(exit)
