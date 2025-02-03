(define (problem roverprob22)
    (:domain Rover)
    (:objects
        ; Definicion de los objetos utilizados en el problema

        general - Lander
        ; general: Un objeto de tipo Lander

        colour high_res low_res - Mode
        ; colour: Un objeto de tipo Mode
        ; high_res: Un objeto de tipo Mode
        ; low_res: Un objeto de tipo Mode

        rover0 rover1 - Rover
        ; rover0: Un objeto de tipo Rover
        ; rover1: Un objeto de tipo Rover

        rover0store rover1store - Store
        ; rover0store: Un objeto de tipo Store
        ; rover1store: Un objeto de tipo Store

        waypoint0 waypoint1 waypoint2 waypoint3 waypoint4 - Waypoint
        ; waypoint0: Un objeto de tipo Waypoint
        ; waypoint1: Un objeto de tipo Waypoint
        ; waypoint2: Un objeto de tipo Waypoint
        ; waypoint3: Un objeto de tipo Waypoint
        ; waypoint4: Un objeto de tipo Waypoint

        camera0 camera1 - Camera
        ; camera0: Un objeto de tipo Camera
        ; camera1: Un objeto de tipo Camera

        objective0 objective1 objective2 - Objective
        ; objective0: Un objeto de tipo Objective
        ; objective1: Un objeto de tipo Objective
        ; objective2: Un objeto de tipo Objective
    )
    (:init
        ; Definicion del estado inicial del problema

        (visible waypoint1 waypoint0)
        ; El waypoint1 es visible desde el waypoint0

        (visible waypoint0 waypoint1)
        ; El waypoint0 es visible desde el waypoint1

        (visible waypoint2 waypoint0)
        ; El waypoint2 es visible desde el waypoint0

        (visible waypoint0 waypoint2)
        ; El waypoint0 es visible desde el waypoint2

        (visible waypoint2 waypoint1)
        ; El waypoint2 es visible desde el waypoint1

        (visible waypoint1 waypoint2)
        ; El waypoint1 es visible desde el waypoint2

        (visible waypoint3 waypoint0)
        ; El waypoint3 es visible desde el waypoint0

        (visible waypoint0 waypoint3)
        ; El waypoint0 es visible desde el waypoint3

        (visible waypoint3 waypoint1)
        ; El waypoint3 es visible desde el waypoint1

        (visible waypoint1 waypoint3)
        ; El waypoint1 es visible desde el waypoint3

        (visible waypoint3 waypoint2)
        ; El waypoint3 es visible desde el waypoint2

        (visible waypoint2 waypoint3)
        ; El waypoint2 es visible desde el waypoint3

        (visible waypoint4 waypoint1)
        ; El waypoint4 es visible desde el waypoint1

        (visible waypoint1 waypoint4)
        ; El waypoint1 es visible desde el waypoint4

        (at_soil_sample waypoint0)
        ; Hay una muestra de suelo en el waypoint0

        (at_rock_sample waypoint1)
        ; Hay una muestra de roca en el waypoint1

        (at_soil_sample waypoint2)
        ; Hay una muestra de suelo en el waypoint2

        (at_rock_sample waypoint2)
        ; Hay una muestra de roca en el waypoint2

        (at_soil_sample waypoint3)
        ; Hay una muestra de suelo en el waypoint3

        (at_rock_sample waypoint3)
        ; Hay una muestra de roca en el waypoint3

        (at_lander general waypoint0)
        ; El lander general esta en el waypoint0

        (channel_free general)
        ; El canal de comunicacion del lander general esta libre

        (at rover0 waypoint3)
        ; El rover0 esta en el waypoint3

        (at rover1 waypoint2)
        ; El rover1 esta en el waypoint2

        (available rover0)
        ; El rover0 esta disponible

        (available rover1)
        ; El rover1 esta disponible

        (store_of rover0store rover0)
        ; El almacen rover0store pertenece al rover0

        (store_of rover1store rover1)
        ; El almacen rover1store pertenece al rover1

        (empty rover0store)
        ; El almacen rover0store esta vacio

        (empty rover1store)
        ; El almacen rover1store esta vacio

        (equipped_for_soil_analysis rover0)
        ; El rover0 esta equipado para analisis de suelo

        (equipped_for_rock_analysis rover0)
        ; El rover0 esta equipado para analisis de rocas

        (equipped_for_imaging rover0)
        ; El rover0 esta equipado para tomar imagenes

        (equipped_for_imaging rover1)
        ; El rover1 esta equipado para tomar imagenes

        (can_traverse rover0 waypoint3 waypoint0)
        ; El rover0 puede moverse desde el waypoint3 al waypoint0

        (can_traverse rover0 waypoint0 waypoint3)
        ; El rover0 puede moverse desde el waypoint0 al waypoint3

        (can_traverse rover0 waypoint3 waypoint1)
        ; El rover0 puede moverse desde el waypoint3 al waypoint1

        (can_traverse rover0 waypoint1 waypoint3)
        ; El rover0 puede moverse desde el waypoint1 al waypoint3

        (can_traverse rover0 waypoint1 waypoint2)
        ; El rover0 puede moverse desde el waypoint1 al waypoint2

        (can_traverse rover0 waypoint2 waypoint1)
        ; El rover0 puede moverse desde el waypoint2 al waypoint1

        (can_traverse rover0 waypoint1 waypoint4)
        ; El rover0 puede moverse desde el waypoint1 al waypoint4

        (can_traverse rover0 waypoint4 waypoint1)
        ; El rover0 puede moverse desde el waypoint4 al waypoint1

        (can_traverse rover1 waypoint2 waypoint0)
        ; El rover1 puede moverse desde el waypoint2 al waypoint0

        (can_traverse rover1 waypoint0 waypoint2)
        ; El rover1 puede moverse desde el waypoint0 al waypoint2

        (can_traverse rover1 waypoint2 waypoint1)
        ; El rover1 puede moverse desde el waypoint2 al waypoint1

        (can_traverse rover1 waypoint1 waypoint2)
        ; El rover1 puede moverse desde el waypoint1 al waypoint2

        (can_traverse rover1 waypoint2 waypoint3)
        ; El rover1 puede moverse desde el waypoint2 al waypoint3

        (can_traverse rover1 waypoint3 waypoint2)
        ; El rover1 puede moverse desde el waypoint3 al waypoint2

        (on_board camera0 rover0)
        ; La camara0 esta a bordo del rover0

        (on_board camera1 rover1)
        ; La camara1 esta a bordo del rover1

        (calibration_target camera0 objective1)
        ; El objetivo1 es el objetivo de calibracion de la camara0

        (calibration_target camera0 objective2)
        ; El objetivo2 es el objetivo de calibracion de la camara0

        (calibration_target camera1 objective1)
        ; El objetivo1 es el objetivo de calibracion de la camara1

        (supports camera0 colour)
        ; La camara0 soporta el modo colour

        (supports camera0 high_res)
        ; La camara0 soporta el modo high_res

        (supports camera1 colour)
        ; La camara1 soporta el modo colour

        (supports camera1 high_res)
        ; La camara1 soporta el modo high_res

        (visible_from objective0 waypoint0)
        ; El objetivo0 es visible desde el waypoint0

        (visible_from objective0 waypoint1)
        ; El objetivo0 es visible desde el waypoint1

        (visible_from objective0 waypoint2)
        ; El objetivo0 es visible desde el waypoint2

        (visible_from objective0 waypoint3)
        ; El objetivo0 es visible desde el waypoint3

        (visible_from objective1 waypoint0)
        ; El objetivo1 es visible desde el waypoint0

        (visible_from objective1 waypoint1)
        ; El objetivo1 es visible desde el waypoint1

        (visible_from objective1 waypoint2)
        ; El objetivo1 es visible desde el waypoint2

        (visible_from objective1 waypoint3)
        ; El objetivo1 es visible desde el waypoint3

        (visible_from objective2 waypoint4)
        ; El objetivo2 es visible desde el waypoint4
    )

    (:goal
        ; Definicion de los objetivos del problema

        (and
            (communicated_soil_data waypoint2)
            ; Los datos de suelo del waypoint2 deben ser comunicados

            (communicated_rock_data waypoint3)
            ; Los datos de rocas del waypoint3 deben ser comunicados

            (communicated_image_data objective1 high_res)
            ; Los datos de imagen del objetivo1 en alta resolucion deben ser comunicados

            (communicated_image_data objective2 high_res)
            ; Los datos de imagen del objetivo2 en alta resolucion deben ser comunicados

            (communicated_image_data objective2 colour)
            ; Los datos de imagen del objetivo2 en modo color deben ser comunicados
        )
    )
)