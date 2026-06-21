CLASS zcl_4467_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_4467_eml IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_agencies_upd TYPE TABLE FOR UPDATE /dmo/i_agencytp.

    lt_agencies_upd = VALUE #(
      ( agencyid = '070044' name = 'KoreanAIR' )
    ).

    MODIFY ENTITIES OF /dmo/i_agencytp
      ENTITY /dmo/agency
      UPDATE FIELDS ( name )
      WITH lt_agencies_upd.

    COMMIT ENTITIES.

    out->write( `Method execution finished!` ).
  ENDMETHOD.
ENDCLASS.
