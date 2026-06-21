# Exercise 5: Implement Conditional Branching

## 목적
- 하나의 계산 프로그램에서 사칙연산을 분기하고 오류 상황을 안전하게 처리한다.

## 한 일
- `op TYPE c`에 저장된 연산자를 기준으로 `CASE` 분기를 구현했다.
- `WHEN OTHERS`에서 잘못된 연산자를 처리했다.
- `output IS INITIAL`일 때만 정상 계산 결과를 만들도록 했다.
- 나눗셈을 `TRY ... CATCH cx_sy_zerodivide`로 감싸 0 나누기 runtime error를 처리했다.
- 정상 연산, 잘못된 연산자, 0 나누기를 Console에서 테스트했다.

## 구현 과정에서 확인한 점
- `CASE op.`에서 검사할 변수를 지정하고 각 `WHEN`에 연산자 값을 배치한다.
- `WHEN OTHERS`는 `+`, `-`, `*`, `/` 어디에도 해당하지 않는 값을 처리하는 기본 분기다.
- 처음에는 각 `WHEN` 안에서 계산과 string template 생성을 함께 작성했다. 동작은 하지만 같은 `output = |...|` 코드가 반복됐다.
- 최종 코드에서는 각 정상 분기가 `result`만 계산하고, `CASE`가 끝난 뒤 한 번만 정상 출력문을 생성하도록 정리했다.
- 오류가 발생한 경우에는 먼저 `output`에 오류 메시지가 들어간다. `IF output IS INITIAL.` 검사를 사용하면 이 메시지를 정상 결과가 덮어쓰지 않는다.

## 핵심 코드

```abap
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
```

## 막힌 점과 해결
- 문제 1: 유효하지 않은 `op` 값에서는 계산할 분기가 없어 별도의 처리가 필요했다.
- 원인 1: `CASE`에 정의된 네 연산자 외의 값을 처리하는 분기가 없었다.
- 해결 1: `WHEN OTHERS`에서 `output`에 잘못된 연산자 메시지를 저장했다.

- 문제 2: `number2 = 0`, `op = '/'`에서 `BCD_ZERODIVIDE` runtime error가 발생했다.
- 원인 2: 0으로 나누는 계산에서 `cx_sy_zerodivide` exception이 발생했지만 처리하지 않았다.
- 해결 2: 나눗셈 분기의 계산을 `TRY ... ENDTRY`로 감싸고 `CATCH cx_sy_zerodivide`에서 오류 메시지를 `output`에 저장했다.

## `TRY ... CATCH`에서 기억할 점
- `TRY`에는 exception이 발생할 수 있는 코드를 둔다.
- `CATCH cx_sy_zerodivide`는 0으로 나누기에서 발생하는 특정 exception만 처리한다.
- exception을 처리하면 프로그램이 runtime error로 종료되는 대신 사용자가 이해할 수 있는 메시지를 출력할 수 있다.
- 이번 코드에서는 나눗셈만 0 나누기 위험이 있으므로 `TRY ... CATCH`를 전체 `CASE`가 아니라 `WHEN '/'` 안에 배치했다.

## 테스트한 흐름
- `op = '+'`, `'-'`, `'*'`, `'/'`: 각 연산 결과 확인
- 정의되지 않은 연산자: `WHEN OTHERS`의 `error!` 또는 잘못된 연산자 메시지 확인
- `number1 = 1`, `number2 = 0`, `op = '/'`: 처음에는 `BCD_ZERODIVIDE` 발생, 수정 후 `0으로 나눌 수 없습니다.` 출력 확인

## 한 줄 정리
- `CASE`는 연산 선택을 담당하고, `output IS INITIAL`은 정상 결과와 오류 메시지를 구분하며, 예상 가능한 exception은 위험한 연산이 있는 분기 가까이에서 처리한다.
