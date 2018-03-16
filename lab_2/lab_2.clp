(clear)
(deftemplate Profession
  (multislot name (type SYMBOL) (cardinality 1 5))
  (slot worktype (type SYMBOL) (allowed-symbols remote office))
  (slot year (type INTEGER) (default 0))
  (slot needCommunication (type SYMBOL) (allowed-symbols yes no))
)
(deftemplate Vacancy
  (slot worktype (type SYMBOL) (allowed-symbols remote office))
)

(deffacts my-facts
  (Profession
    (name Front-End Developer)
    (worktype office)
    (year 2)
    (needCommunication no)
  )
  (Profession
    (name Back-End Developer)
    (worktype remote)
    (year 3)
    (needCommunication no)
  )
  (Profession
    (name HR-Manager)
    (worktype remote)
    (year 1)
    (needCommunication yes)
  )
  (Vacancy (worktype remote))
  (a b c d e)
)

(defrule asdd
  (a ? ?second ? ?fourth $?)
  =>
  (printout t "*** " ?second " - " ?fourth crlf)
)

; TEST, AND, OR, NOT
(defrule test-rule
  (Profession (year ?year) (worktype ?worktype))
  (test (not
          (or (and (>= ?year 1)
                (<= ?year 2)
                (eq ?worktype remote))
              (and (>= ?year 3)
                (<= ?year 5)
                (eq ?worktype office))
          )
        )
  )
  =>
  (printout t "___ Test rule " ?year " " ?worktype crlf)
)

; OR
(defrule or-rule
  ;; (Profession (year ?year))
  (or (and 
        (Profession (year ?g &=(* ?g 2)))
        (Vacancy (worktype remote))
      )
      (and
        (Profession (year ?g &:(and (> ?g 0) (< ?g 2))))
        (Vacancy (worktype office))
      )
  )
  =>
  (printout t "Or rule " ?g crlf)
)

; EXISTS
(defrule exists-rule
  (exists
    (or
      (Profession
        (year ?year&:(and (>= ?year 0) (<= ?year 2)))
        (worktype office)
      )
      (Profession
        (year ?year&:(and (>= ?year 0) (<= ?year 2)))
        (worktype remote)
      )
    )
  )
  =>
  (printout t "Exists Rule" crlf)  
)

; FORALL
(defrule forall-rule
  (Profession (worktype ?worktype))
  (forall (Profession (worktype ?worktype))
          (Vacancy (worktype ?worktype)))
  =>
  (assert (my for all fact))
  (printout t "Forall Rule (" ?worktype ")" crlf)
)

; LOGICAL
(defrule logical-rule
  (logical (my for all fact))
  (my for all fact)
  =>
  (assert (xxx lolol))
  (printout t "LOGICAL RULE" crlf)
)

(deffunction containing (?value $?slots)
  (member$ ?value ?slots)
)

; MULTIVATED
(defrule multivalued-rule
  (Profession (name $?name))
  (test
    (or
      (neq (containing Front-End $?name) FALSE)
      (neq (containing Back-End $?name) FALSE)
    )
  )
  =>
  (printout t "isDeveloper -> " ?name crlf)
)

(defrule by-address
  ?fact <- (Profession (name $?))
  =>
  ;;(retract ?fact)
)

(reset)
(run)
;; (matches logical-rule)
;; (facts)
;; (retract 5)
;; (facts)
(exit)
