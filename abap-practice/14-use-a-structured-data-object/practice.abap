CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA conn_counter TYPE i READ-ONLY.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

    METHODS get_output
      RETURNING VALUE(r_output) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.

    TYPES:
      BEGIN OF ty_details,
        DepartureAirport   TYPE /dmo/airport_from_id,
        DestinationAirport TYPE /dmo/airport_to_id,
        AirlineName        TYPE /dmo/carrier_name,
      END OF ty_details.

    DATA ls_details TYPE ty_details.
ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.
  METHOD get_output.
    APPEND
      |Carrier: { carrier_id }, |
      && |Connection: { connection_id }, |
      && |Airport From: { ls_details-departureairport }, |
      && |Airport to: { ls_details-destinationairport }, |
      && |Carrier Name: { ls_details-airlinename }|
      TO r_output.
  ENDMETHOD.

  METHOD constructor.
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    conn_counter += 1.
    me->carrier_id    = i_carrier_id.
    me->connection_id = i_connection_id.

    SELECT SINGLE
      FROM /dmo/i_connection
      FIELDS DepartureAirport, DestinationAirport, \_Airline-Name AS AirlineName
      WHERE AirlineID    = @i_carrier_id
        AND ConnectionID = @i_connection_id
      INTO CORRESPONDING FIELDS OF @me->ls_details.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
