(define (domain Rover)
       (:requirements :typing :strips)
       (:types
              rover waypoint store camera mode lander objective battery batterylevel
       )

       (:predicates
              (at ?x - rover ?y - waypoint)
              ; El rover x esta en el waypoint y.

              (at_lander ?x - lander ?y - waypoint)
              ; El lander x esta en el waypoint y.

              (can_traverse ?r - rover ?x - waypoint ?y - waypoint)
              ; El rover r puede moverse desde el waypoint x al waypoint y.

              (equipped_for_soil_analysis ?r - rover)
              ; El rover r esta equipado para analisis de suelo.

              (equipped_for_rock_analysis ?r - rover)
              ; El rover r esta equipado para analisis de rocas.

              (equipped_for_imaging ?r - rover)
              ; El rover r esta equipado para tomar imagenes.

              (empty ?s - store)
              ; El almacen s esta vacio.

              (have_rock_analysis ?r - rover ?w - waypoint)
              ; El rover r tiene un analisis de rocas del waypoint w.

              (have_soil_analysis ?r - rover ?w - waypoint)
              ; El rover r tiene un analisis de suelo del waypoint w.

              (full ?s - store)
              ; El almacen s esta lleno.

              (calibrated ?c - camera ?r - rover)
              ; La camara c en el rover r esta calibrada.

              (supports ?c - camera ?m - mode)
              ; La camara c soporta el modo m.

              (available ?r - rover)
              ; El rover r esta disponible.

              (visible ?w - waypoint ?p - waypoint)
              ; El waypoint w es visible desde el waypoint p.

              (have_image ?r - rover ?o - objective ?m - mode)
              ; El rover r tiene una imagen del objetivo o en el modo m.

              (communicated_soil_data ?w - waypoint)
              ; Los datos de suelo del waypoint w han sido comunicados.

              (communicated_rock_data ?w - waypoint)
              ; Los datos de rocas del waypoint w han sido comunicados.

              (communicated_image_data ?o - objective ?m - mode)
              ; Los datos de imagen del objetivo o en el modo m han sido comunicados.

              (at_soil_sample ?w - waypoint)
              ; Hay una muestra de suelo en el waypoint w.

              (at_rock_sample ?w - waypoint)
              ; Hay una muestra de roca en el waypoint w.

              (visible_from ?o - objective ?w - waypoint)
              ; El objetivo o es visible desde el waypoint w.

              (store_of ?s - store ?r - rover)
              ; El almacen s pertenece al rover r.

              (calibration_target ?i - camera ?o - objective)
              ; El objetivo o es el objetivo de calibracion de la camara i.

              (on_board ?i - camera ?r - rover)
              ; La camara i esta a bordo del rover r.

              (channel_free ?l - lander)
              ; El canal de comunicacion del lander l esta libre.

              (on_board_battery ?b - battery ?r - rover)
              ; Un rover puede tener bateria a bordo.

              (has_battery_left ?v - batterylevel ?w - batterylevel )
              ; El nivel de bateria tiene un nivel anterior

              (at_battery_level ?b - battery ?v - batterylevel)
              ; Una bateria en nivel de carga v
       )

       ;Moverse, consume 1 de energia
       ; ----- Precondiciones relacionadas a la bateria:
       ; Se comprueba que exista una bateria en el rover
       ; Se comprueba que la bateria tiene disponible un nivel anterior de carga
       ; Se comprueba que la bateria se encuentra en un nivel especifico de carga
       ; ----- Efectos:
       ; El nivel de carga de bateria se cambia por el estado de carga de bateria anterior
       ; Se niega el nivel de carga que tenia la bateria previamente 
       (:action navigate
              :parameters (?x - rover ?y - waypoint ?z - waypoint ?b - battery ?v1 ?v2 - batterylevel)
              :precondition (and 
                     (can_traverse ?x ?y ?z) (available ?x) (at ?x ?y) (visible ?y ?z)
                     (on_board_battery ?b ?x)
                     (has_battery_left ?v1 ?v2)
                     (at_battery_level ?b ?v2)
              )
              :effect (and 
                     (not (at ?x ?y)) (at ?x ?z)
                     (at_battery_level ?b ?v1)
                     (not (at_battery_level ?b ?v2))
              )
       )
       
       ;Obtener muestra de suelo
       (:action sample_soil
              :parameters (?x - rover ?s - store ?p - waypoint)
              :precondition (and (at ?x ?p) (at_soil_sample ?p) (equipped_for_soil_analysis ?x) (store_of ?s ?x) (empty ?s)
              )
              :effect (and (not (empty ?s)) (full ?s) (have_soil_analysis ?x ?p) (not (at_soil_sample ?p))
              )
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

       ;valida rover en lander y niega battery level para setear nuevo battery level
       ; ----- Precondiciones:
       ; El rover esta en un waypoint especifico
       ; Ese waypoint es el lander
       ; La bateria esta a bordo del rover
       ; La bateria esta en un nivel especifico de carga
       ; ----- Efectos:
       ; Se niega el nivel actual de carga de la bateria
       ; Se modifica el nivel de carga de la bateria
       ; ----- NOTA:
       ; No se esta evaluando el nivel anterior de carga de bateria porque como se esta recargando
       ; el nivel de carga puede saltar de 0 al valor maximo definido en el problema.
       (:action charge_battery
              :parameters (?r - rover ?x - waypoint ?l - lander ?b - battery ?v1 ?v2 - batterylevel)
              :precondition (and 
                     (at ?r ?x) (at_lander ?l ?x) (available ?r)
                     (on_board_battery ?b ?r) (at_battery_level ?b ?v1)
              )
              :effect (and 
                     (not (at_battery_level ?b ?v1))
                     (at_battery_level ?b ?v2)
              )
       )


)