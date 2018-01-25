CLASS zcl_zflight_service_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zflight_service_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS schedules_get_entity
        REDEFINITION.

    METHODS flights_get_entityset
        REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zflight_service_dpc_ext IMPLEMENTATION.
  METHOD schedules_get_entity.

    DATA(lo_flight) = NEW zcl_flight_service( mo_context ).

    lo_flight->get_schedule( EXPORTING io_tech_request_context = io_tech_request_context
                              CHANGING cs_entity               = er_entity   ).



  ENDMETHOD.

  METHOD flights_get_entityset.

    READ TABLE it_navigation_path TRANSPORTING NO FIELDS WITH KEY nav_prop = 'ScheduleToFlight'.
    IF sy-subrc = 0.
    ENDIF.

    DATA(lo_flight) = NEW zcl_flight_service( mo_context ).

    lo_flight->get_flights( EXPORTING io_tech_request_context = io_tech_request_context
                             CHANGING ct_entityset            =  et_entityset  ).

  ENDMETHOD.

ENDCLASS.
