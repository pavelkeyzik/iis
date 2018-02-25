(deftemplate Profession
  (multislot name (type SYMBOL) (cardinality 1 5))      
  (slot worktype (type SYMBOL) (allowed-symbols remote office))
  (slot year (type INTEGER) (default 0))
  (slot needCommunication (type SYMBOL) (allowed-symbols yes no))
)
(deftemplate current-profession
  (slot name)
  (slot skill (default any))
)

(deffacts works
  (Profession 
    (name Developer)
    (worktype remote)
    (year 1)
    (needCommunication no)
  )
  (Profession 
    (name Developer)
    (worktype remote)
    (year 3)
    (needCommunication no)
  )
  (Profession 
    (name Developer)
    (worktype remote)
    (year 8)
    (needCommunication no)
  )
  (Profession 
    (name HR-Manager)
    (worktype remote)
    (year 2)
    (needCommunication yes)
  )
)

(reset)

(defrule Junior-Developer
  (test )
  (Profession (year ?g &:(and(>= ?g 0)(< ?g 3))))
  =>
  (assert(current-profession(name Developer)(skill Junior)))
)
(defrule Middle-Developer
  (Profession (year ?g &:(and(>= ?g 3)(< ?g 5))))
  =>
  (assert(current-profession(name Developer)(skill Middle)))
)
(defrule Senior-Developer
  (Profession (year ?g &:(and(>= ?g 5)(< ?g 7))))
  =>
  (assert(current-profession(name Developer)(skill Senior)))
)
(defrule HR-Manager
  (Profession (needCommunication ?g &:(eq ?g yes)))
  =>
  (assert(current-profession(name HR-Manager)))
)
(defrule Developer
  (Profession (needCommunication ?g &:(eq ?g no)))
  =>
  (assert(current-profession(name Developer)))
)

(run)
(facts)
(exit)
