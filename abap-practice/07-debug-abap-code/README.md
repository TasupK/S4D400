# Exercise 7: Debug ABAP Code

## 목적
- ABAP debugger에서 breakpoint, watch point, single step을 사용해 실행 흐름과 변수 변화를 확인한다.

## 한 일
- `/LRN/CL_S4D400_BTT_DEBUG`를 자신의 패키지로 복사해 디버깅 대상 class를 준비한다.
- 첫 실행문에 breakpoint를 걸고 debugger에 진입한다.
- `loan_remaining`, `loan_total`, `spec_repay_mode` 값을 Variables view에서 확인한다.
- `loan_remaining`와 `repayment_plan`에 watch point를 걸어 값이 바뀌는 시점을 추적한다.
- `APPEND` 실행 전후를 비교해 `repayment_plan` internal table이 채워지는 방식을 확인한다.
- `EXIT` statement breakpoint와 `F6` Step Over를 사용해 output 부분까지 흐름을 따라간다.

## 막힌 점과 해결
- 문제: `out->write( ... )`에서 `F5`를 사용하면 내부 구현으로 너무 깊게 들어갈 수 있다.
- 원인: `out->write( ... )`는 단일 문장처럼 보이지만 내부적으로 여러 ABAP statement로 이루어진 reusable code block이다.
- 해결: output 확인 목적일 때는 `F5` 대신 `F6`으로 Step Over 한다.

## 한 줄 정리
- Exercise 7의 핵심은 코드를 고치는 것이 아니라, 값이 언제 바뀌고 어디서 멈추는지를 debugger 시점에서 읽는 연습이다.
