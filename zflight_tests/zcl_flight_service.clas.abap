CLASS zcl_flight_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING io_context TYPE REF TO /iwbep/if_mgw_context.

    METHODS get_schedules
      IMPORTING
                io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity
      CHANGING
                cs_entity               TYPE zcl_zflight_service_mpc=>ts_schedule
      RAISING   /iwbep/cx_mgw_busi_exception
                /iwbep/cx_mgw_tech_exception.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_context TYPE REF TO /iwbep/if_mgw_context.

ENDCLASS.

CLASS zcl_flight_service IMPLEMENTATION.

  METHOD constructor.
    mo_context = io_context.
  ENDMETHOD.

  METHOD get_schedules.

    TYPES: BEGIN OF lty_keys,
             carrid TYPE s_carr_id,
             connid TYPE s_conn_id,
           END OF lty_keys.

    DATA: ls_keys              TYPE lty_keys,
          lo_message_container TYPE REF TO /iwbep/if_message_container.


    io_tech_request_context->get_converted_keys( IMPORTING es_key_values = ls_keys ).

    SELECT SINGLE *
        FROM spfli
        INTO CORRESPONDING FIELDS OF cs_entity
        WHERE carrid = ls_keys-carrid
    AND connid = ls_keys-connid.
    IF sy-subrc <> 0.

      lo_message_container = mo_context->get_message_container( ).

      lo_message_container->add_message(
        EXPORTING
          iv_msg_type               = 'E'                 " Message Type
          iv_msg_id                 = 'ZFLIGHT_ODATA'     " Message Class
          iv_msg_number             = 001             ).  " Message Number

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          http_status_code  = 404
          message_container = lo_message_container.
    ENDIF.


  ENDMETHOD.


ENDCLASS.
