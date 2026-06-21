CLASS zcl_4467_compute_branch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_4467_compute_branch IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA number1 TYPE i.
    DATA number2 TYPE i.
    DATA result TYPE p DECIMALS 2.
    DATA op TYPE c.
    DATA output TYPE string.

    number1 = 1.
    number2 = 0.
    op = '/'.

    CASE op.
      WHEN '+'.
        result = number1 + number2.
      WHEN '-'.
        result = number1 - number2.
      WHEN '*'.
        result = number1 * number2.
      WHEN '/'.
        TRY.
            result = number1 / number2.
          CATCH cx_sy_zerodivide.
            output = '0으로 나눌 수 없습니다.'.
        ENDTRY.
      WHEN OTHERS.
        output = |잘못된 연산자입니다 : { op }|.
    ENDCASE.

    IF output IS INITIAL.
      output = |{ number1 } { op } { number2 } = { result }|.
    ENDIF.

    out->write( output ).
  ENDMETHOD.
ENDCLASS.
