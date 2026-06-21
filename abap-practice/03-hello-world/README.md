# Exercise 3: Create a 'Hello World' Application

## 목적
- `IF_OO_ADT_CLASSRUN`을 구현한 ABAP class를 Console application으로 실행한다.

## 한 일
- `ZCL_4467_HELLO_WORLD`를 생성했다.
- `if_oo_adt_classrun~main`에서 `Hello World`를 출력했다.
- class를 Activate하고 ABAP Console의 출력 결과를 확인했다.

## 핵심 코드

```abap
METHOD if_oo_adt_classrun~main.
  out->write( 'Hello World' ).
ENDMETHOD.
```

## 한 줄 정리
- `IF_OO_ADT_CLASSRUN`과 `out->write( )`를 사용하면 ADT에서 간단한 Console application을 실행할 수 있다.
