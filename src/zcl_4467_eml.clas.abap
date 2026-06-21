CLASS zcl_4467_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4467_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA lt_agencies_upd TYPE TABLE FOR UPDATE /DMO/I_AgencyTP.
    lt_agencies_upd = VALUE #( ( agencyid = '070044' name = 'KoreanAIR' ) ).

    MODIFY ENTITIES OF /DMO/I_AgencyTP
        ENTITY /dmo/agency
        UPDATE FIELDS ( name )
        WITH lt_agencies_upd.

    COMMIT ENTITIES.
    out->write( `Method execution finished!`  ).


  ENDMETHOD.
ENDCLASS.
