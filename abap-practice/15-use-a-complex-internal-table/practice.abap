CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA conn_counter TYPE i READ-ONLY.
    CLASS-METHODS class_constructor.

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
    DATA ms_details TYPE ty_details.

    TYPES:
      BEGIN OF ty_airport,
        AirportID TYPE /dmo/airport_id,
        Name      TYPE /dmo/airport_name,
      END OF ty_airport.
    DATA tt_airports TYPE STANDARD TABLE OF ty_airport
      WITH NON-UNIQUE DEFAULT KEY.
    CLASS-DATA mt_airports LIKE tt_airports.
ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.
  METHOD class_constructor.
    SELECT
      FROM /dmo/i_airport
      FIELDS AirportID, Name
      INTO TABLE @mt_airports.
  ENDMETHOD.

  METHOD get_output.
    DATA(lv_departure) = mt_airports[ AirportID = ms_details-departureairport ].
    DATA(lv_destination) = mt_airports[ AirportID = ms_details-destinationairport ].

    APPEND
      |Carrier: { carrier_id }, |
      && |Connection: { connection_id }, |
      && |Airport From: { ms_details-departureairport } [{ lv_departure-name }], |
      && |Airport to: { ms_details-destinationairport } [{ lv_destination-name }], |
      && |Carrier Name: { ms_details-airlinename }|
      TO r_output.
  ENDMETHOD.
ENDCLASS.
