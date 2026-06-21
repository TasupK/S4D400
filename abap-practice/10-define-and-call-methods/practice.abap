CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.
    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    CLASS-DATA conn_counter TYPE i.

    METHODS get_output
      RETURNING VALUE(r_output) TYPE string_table.

    METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.
  METHOD get_output.
    APPEND |Carrier: { carrier_id }, Connection: { connection_id }| TO r_output.
  ENDMETHOD.

  METHOD set_attributes.
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.
  ENDMETHOD.
ENDCLASS.

METHOD if_oo_adt_classrun~main.
  DATA connections TYPE TABLE OF REF TO lcl_connection.
  DATA connection TYPE REF TO lcl_connection.

  connection = NEW #( ).
  TRY.
      connection->set_attributes(
        EXPORTING
          i_carrier_id    = 'LH'
          i_connection_id = '0400'
      ).
      APPEND connection TO connections.
    CATCH cx_abap_invalid_value.
      out->write( `Method call failed` ).
  ENDTRY.

  connection = NEW #( ).
  TRY.
      connection->set_attributes(
        EXPORTING
          i_carrier_id    = 'AA'
          i_connection_id = '0017'
      ).
      APPEND connection TO connections.
    CATCH cx_abap_invalid_value.
      out->write( `Method call failed` ).
  ENDTRY.

  connection = NEW #( ).
  TRY.
      connection->set_attributes(
        EXPORTING
          i_carrier_id    = 'SQ'
          i_connection_id = '0001'
      ).
      APPEND connection TO connections.
    CATCH cx_abap_invalid_value.
      out->write( `Method call failed` ).
  ENDTRY.

  LOOP AT connections INTO connection.
    out->write( connection->get_output( ) ).
  ENDLOOP.
ENDMETHOD.
