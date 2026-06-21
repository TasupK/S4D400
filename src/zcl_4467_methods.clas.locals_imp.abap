*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_connection definition.

  public section.
   DATA carrier_id    TYPE /dmo/carrier_id.
   DATA connection_id TYPE /dmo/connection_id.
   CLASS-DATA conn_counter TYPE i.

   METHODS get_output
    RETURNING VALUE(r_output) TYPE string_table.
   METHODS set_attributes
    IMPORTING
      i_carrier_id TYPE /dmo/carrier_id
      i_connection_id TYPE /dmo/connection_id
    RAISING
      cx_abap_invalid_value.

  protected section.
  private section.

endclass.

class lcl_connection implementation.

  method get_output.
   APPEND |Carrier: { carrier_id }, Connection: { connection_id }| TO r_output.
  endmethod.

  method set_attributes.
   IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
   ENDIF.

   carrier_id = i_carrier_id.
   connection_id = i_connection_id.
  endmethod.

endclass.
