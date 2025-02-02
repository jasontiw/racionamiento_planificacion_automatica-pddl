(define (domain Rover)
       (:requirements :typing :strips)
       (:types
              rover waypoint store camera mode lander objective
       )
       (:predicates
              (at ?x - rover ?y - waypoint); El rover x esta en el waypoint y.
              (at_lander ?x - lander ?y - waypoint); El lander x esta en el waypoint y.
              (can_traverse ?r - rover ?x - waypoint ?y - waypoint); El rover r puede moverse desde el waypoint x al waypoint y.
              (equipped_for_soil_analysis ?r - rover); El rover r esta equipado para analisis de suelo.
              (equipped_for_rock_analysis ?r - rover); El rover r esta equipado para analisis de rocas.
              (equipped_for_imaging ?r - rover); El rover r esta equipado para tomar imagenes.
              (empty ?s - store); El almacen s esta vacio.
              (have_rock_analysis ?r - rover ?w - waypoint); El rover r tiene un analisis de rocas del waypoint w.
              (have_soil_analysis ?r - rover ?w - waypoint); El rover r tiene un analisis de suelo del waypoint w.
              (full ?s - store); El almacen s esta lleno.
              (calibrated ?c - camera ?r - rover); La camara c en el rover r esta calibrada.
              (supports ?c - camera ?m - mode); La camara c soporta el modo m.
              (available ?r - rover); El rover r esta disponible.
              (visible ?w - waypoint ?p - waypoint); El waypoint w es visible desde el waypoint p.
              (have_image ?r - rover ?o - objective ?m - mode); El rover r tiene una imagen del objetivo o en el modo m.
              (communicated_soil_data ?w - waypoint); Los datos de suelo del waypoint w han sido comunicados.
              (communicated_rock_data ?w - waypoint); Los datos de rocas del waypoint w han sido comunicados.
              (communicated_image_data ?o - objective ?m - mode); Los datos de imagen del objetivo o en el modo m han sido comunicados.
              (at_soil_sample ?w - waypoint); Hay una muestra de suelo en el waypoint w.
              (at_rock_sample ?w - waypoint); Hay una muestra de roca en el waypoint w.
              (visible_from ?o - objective ?w - waypoint); El objetivo o es visible desde el waypoint w.
              (store_of ?s - store ?r - rover); El almacen s pertenece al rover r.
              (calibration_target ?i - camera ?o - objective); El objetivo o es el objetivo de calibracion de la camara i.
              (on_board ?i - camera ?r - rover); La camara i esta a bordo del rover r.
              (channel_free ?l - lander); El canal de comunicacion del lander l esta libre.
       )
       ;Moverse
       (:action navigate
              ; Definicion de la accion navigate, que permite a un rover moverse de un waypoint a otro
              :parameters (?x - rover ?y - waypoint ?z - waypoint)
              ; Parametros de la accion:
              ; ?x - rover: El rover que realizara la accion
              ; ?y - waypoint: El waypoint de origen desde donde el rover se movera
              ; ?z - waypoint: El waypoint de destino hacia donde el rover se movera
              :precondition (and (can_traverse ?x ?y ?z) (available ?x) (at ?x ?y) (visible ?y ?z))
              ; Precondiciones que deben cumplirse para que la accion sea ejecutable:
              ; (can_traverse ?x ?y ?z): El rover ?x puede moverse desde el waypoint ?y al waypoint ?z
              ; (available ?x): El rover ?x esta disponible
              ; (at ?x ?y): El rover ?x esta actualmente en el waypoint ?y
              ; (visible ?y ?z): El waypoint ?z es visible desde el waypoint ?y
              :effect (and (not (at ?x ?y)) (at ?x ?z))
              ; Efectos de la accion una vez ejecutada:
              ; (not (at ?x ?y)): El rover ?x ya no estara en el waypoint ?y
              ; (at ?x ?z): El rover ?x estara en el waypoint ?z
       )
       ;Obtener muestra de suelo
       (:action sample_soil
              ; Definicion de la accion sample_soil, que permite a un rover tomar una muestra de suelo
              :parameters (?x - rover ?s - store ?p - waypoint)
              ; Parametros de la accion:
              ; ?x - rover: El rover que realizara la accion
              ; ?s - store: El almacen del rover donde se guardara la muestra
              ; ?p - waypoint: El waypoint donde se encuentra la muestra de suelo
              :precondition (and (at ?x ?p) (at_soil_sample ?p) (equipped_for_soil_analysis ?x) (store_of ?s ?x) (empty ?s))
              ; Precondiciones que deben cumplirse para que la accion sea ejecutable:
              ; (at ?x ?p): El rover ?x esta actualmente en el waypoint ?p
              ; (at_soil_sample ?p): Hay una muestra de suelo en el waypoint ?p
              ; (equipped_for_soil_analysis ?x): El rover ?x esta equipado para analisis de suelo
              ; (store_of ?s ?x): El almacen ?s pertenece al rover ?x
              ; (empty ?s): El almacen ?s esta vacio
              :effect (and (not (empty ?s)) (full ?s) (have_soil_analysis ?x ?p) (not (at_soil_sample ?p)))
              ; Efectos de la accion una vez ejecutada:
              ; (not (empty ?s)): El almacen ?s ya no estara vacio
              ; (full ?s): El almacen ?s estara lleno
              ; (have_soil_analysis ?x ?p): El rover ?x tendra un analisis de suelo del waypoint ?p
              ; (not (at_soil_sample ?p)): Ya no habra una muestra de suelo en el waypoint ?p
       )
       ;Obtener muestra de roca
       (:action sample_rock
              :parameters (?x - rover ?s - store ?p - waypoint)
              :precondition (and (at ?x ?p) (at_rock_sample ?p) (equipped_for_rock_analysis ?x) (store_of ?s ?x)(empty ?s)
              )
              :effect (and (not (empty ?s)) (full ?s) (have_rock_analysis ?x ?p) (not (at_rock_sample ?p))
              )
       )
       ;Soltar (suelta lo que tiene guardado)
       (:action drop
              :parameters (?x - rover ?y - store)
              :precondition (and (store_of ?y ?x) (full ?y)
              )
              :effect (and (not (full ?y)) (empty ?y)
              )
       )
       ;Calibrar revisa si el rover tiene camara y el objetivo a fotografiar es visible
       (:action calibrate
              :parameters (?r - rover ?i - camera ?t - objective ?w - waypoint)
              :precondition (and (equipped_for_imaging ?r) (calibration_target ?i ?t) (at ?r ?w) (visible_from ?t ?w)(on_board ?i ?r)
              )
              :effect (calibrated ?i ?r)
       )
       ;Toma foto (necesita estar calibrado)
       (:action take_image
              :parameters (?r - rover ?p - waypoint ?o - objective ?i - camera ?m - mode)
              :precondition (and (calibrated ?i ?r)
                     (on_board ?i ?r)
                     (equipped_for_imaging ?r)
                     (supports ?i ?m)
                     (visible_from ?o ?p)
                     (at ?r ?p)
              )
              :effect (and (have_image ?r ?o ?m)
                     (not (calibrated ?i ?r))
              )
       )
       ;comunica data del suelo (necesita haber agarrado suelo)
       (:action communicate_soil_data
              :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
              :precondition (and (at ?r ?x)
                     (at_lander ?l ?y)(have_soil_analysis ?r ?p)
                     (visible ?x ?y)(available ?r)(channel_free ?l)
              )
              :effect (and (not (available ?r))
                     (not (channel_free ?l))(channel_free ?l)
                     (communicated_soil_data ?p)(available ?r)
              )
       )
       ;comunica data de roca (necesita haber agarrado roca)
       (:action communicate_rock_data
              :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
              :precondition (and (at ?r ?x)
                     (at_lander ?l ?y)(have_rock_analysis ?r ?p)
                     (visible ?x ?y)(available ?r)(channel_free ?l)
              )
              :effect (and (not (available ?r))
                     (not (channel_free ?l))(channel_free ?l)(communicated_rock_data ?p)(available ?r)
              )
       )

       ;comunica data de imagen (necesita haber tomado foto)
       (:action communicate_image_data
              :parameters (?r - rover ?l - lander ?o - objective ?m - mode ?x - waypoint ?y - waypoint)
              :precondition (and (at ?r ?x)
                     (at_lander ?l ?y)(have_image ?r ?o ?m)(visible ?x ?y)(available ?r)(channel_free ?l)
              )
              :effect (and (not (available ?r))
                     (not (channel_free ?l))(channel_free ?l)(communicated_image_data ?o ?m)(available ?r)
              )
       )

)