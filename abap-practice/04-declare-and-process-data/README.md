# Exercise 4: Declare Variables and Process Data

## 목적
- 변수 선언, arithmetic expression과 string template을 사용해 계산 결과를 출력한다.

## 한 일
- `number1`과 `number2`를 `TYPE i`로 선언하고 `-8`, `3`을 할당했다.
- 나눗셈 결과를 string template으로 구성해 Console에 출력했다.
- `result`를 `TYPE p DECIMALS 2`로 명시적으로 선언해 소수점 둘째 자리까지 표현했다.

## 핵심 코드

```abap
DATA result TYPE p DECIMALS 2.

result = number1 / number2.
DATA(output) = |{ number1 } / { number2 } = { result }|.
```

## 막힌 점과 해결
- 문제: `DATA(result) = -8 / 3.`의 결과가 `-3`으로 출력됐다.
- 원인: 피연산자가 모두 `TYPE i`여서 inline declaration의 `result`도 정수형으로 추론됐다.
- 해결: `result`를 `TYPE p DECIMALS 2`로 explicit declaration하여 `-2.67`을 얻었다.

## 왜 `TYPE f`가 아니라 `TYPE p`인가
- `TYPE p`는 고정 소수점 방식의 packed number라서 `DECIMALS 2`처럼 필요한 소수 자릿수를 명확하게 지정할 수 있다.
- 이번 실습의 목표는 계산 결과를 소수점 둘째 자리까지 안정적으로 반올림하고 출력하는 것이다. 따라서 정해진 자릿수를 다루는 `TYPE p`가 목적에 더 잘 맞는다.
- `TYPE f`는 부동소수점 타입이므로 매우 크거나 작은 값과 넓은 범위의 근삿값 계산에는 유용하지만, 내부 이진 표현 때문에 십진수 값이 정확히 표현되지 않을 수 있다.
- 금액, 비율처럼 십진 자릿수와 반올림 기준이 중요한 값에는 일반적으로 `TYPE p` 또는 적절한 decimal type을 우선 고려한다.
- 즉, `TYPE f`도 나눗셈 결과를 표현할 수 있지만 이번 Exercise에서는 단순히 소수값을 얻는 것보다 **소수점 두 자리라는 계산 규칙을 타입에 명시하는 것**이 중요했다.

## 한 줄 정리
- 계산 정밀도가 중요하면 inline type inference에 맡기지 말고, 고정된 십진 자릿수가 필요할 때 `TYPE p DECIMALS n`으로 규칙을 명시한다.
