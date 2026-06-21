*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_connection definition.

  public section.
    CLASS-DATA conn_counter TYPE i READ-ONLY.
    METHODS constructor
    IMPORTING
      i_carrier_id TYPE /dmo/carrier_id
      i_connection_id TYPE /dmo/connection_id
    RAISING
      cx_abap_invalid_value.

   METHODS get_output
    RETURNING VALUE(r_output) TYPE string_table.
*   METHODS set_attributes
*    IMPORTING
*      i_carrier_id TYPE /dmo/carrier_id
*      i_connection_id TYPE /dmo/connection_id
*    RAISING
*      cx_abap_invalid_value.

  protected section.
  private section.
   DATA carrier_id    TYPE /dmo/carrier_id.
   DATA connection_id TYPE /dmo/connection_id.
   DATA airport_from_id TYPE /DMO/AIRPORT_FROM_ID.
   DATA airport_to_id TYPE /DMO/AIRPORT_TO_ID.
   DATA carrier_name TYPE /DMO/CARRIER_NAME.

endclass.

class lcl_connection implementation.

  method get_output.
   APPEND
   |Carrier: { carrier_id }| &&
   |Connection: { connection_id }| &&
   |Airport From: { airport_from_id }| &&
   |Airport to: { airport_to_id }| &&
   |Carrirer Name: { carrier_name }|
   TO r_output.
  endmethod.

*  method set_attributes.
*   IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
*    RAISE EXCEPTION TYPE cx_abap_invalid_value.
*   ENDIF.
*
*   carrier_id = i_carrier_id.
*   connection_id = i_connection_id.
*  endmethod.

  method constructor.
   IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
   ENDIF.

    conn_counter += 1.
    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

*   SELECT SINGLE
*   FROM /dmo/connection
*   FIELDS airport_from_id, airport_to_id
*    WHERE carrier_id = @i_carrier_id
*    AND connection_id = @i_connection_id
*    INTO ( @me->airport_from_id, @me->airport_to_id ).

    SELECT SINGLE
    FROM /dmo/i_connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name
     WHERE AirlineID = @i_carrier_id
     AND ConnectionID = @i_connection_id
     INTO ( @me->airport_from_id, @me->airport_to_id, @me->carrier_name ).

   IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
   ENDIF.
  endmethod.

endclass.
