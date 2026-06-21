CLASS zcl_4467_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .


ENDCLASS.


CLASS zcl_4467_cds IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
   DATA connections TYPE TABLE OF REF TO lcl_connection.
   DATA connection TYPE REF TO lcl_connection.
* First Instance
**********************************************************************
    TRY.
        connection = NEW #(
            i_carrier_id    = 'LH'
            i_connection_id = '0400'
            ).
        APPEND connection TO connections.
      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.
* Second Instance
**********************************************************************
    TRY.
        connection = NEW #(
            i_carrier_id    = 'AA'
            i_connection_id = '0017'
            ).
        APPEND connection TO connections.
      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.
* Third Instance
**********************************************************************
    TRY.
        connection = NEW #(
            i_carrier_id    = 'SQ'
            i_connection_id = '0001'
            ).
        APPEND connection TO connections.
      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.

* Loop Connections
**********************************************************************
   LOOP AT connections INTO connection.
    out->write( connection->get_output(  ) ).
   ENDLOOP.
  ENDMETHOD.
ENDCLASS.
