CLASS zcl_4467_compute DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4467_compute IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA number1 TYPE i.
    DATA number2 TYPE i.
    DATA result TYPE p DECIMALS 2.

    number1 = -8.
    number2 = 3.

    result = -8 / 3.
    DATA(output) = |{ number1 } / { number2 } = { result }|.
    out->write( output ).

  ENDMETHOD.
ENDCLASS.
