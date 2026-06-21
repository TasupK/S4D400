# Exercise 18 추가 정리: Copy Data 흐름

## 전체 흐름

Exercise 18의 복사 흐름은 다음처럼 이해했다.

```text
/DMO/FLIGHT
  -> SELECT
  -> internal table flights
  -> RAP technical fields 보정
  -> INSERT
  -> Z4467FLIGHT
```

즉 `itab -> DB` 방식이 맞다. 다만 RAP Business Object를 통한 `MODIFY ENTITIES`가 아니라, Open SQL의 `INSERT (table_name) FROM TABLE @flights`를 사용해서 DB table에 직접 넣는 방식이다.

이 방식은 업무 트랜잭션 처리보다는 실습용 데이터 세팅, 초기 적재, 테이블 복사 같은 상황에 어울린다.

## copy_data 메소드 흐름

`copy_data`는 실제 복사 작업의 순서를 조립하는 메소드다.

```abap
prepare_data( ).

IF me->is_empty_db( ) = abap_false.
  me->delete_db( ).
ENDIF.

me->insert_db( ).
```

흐름은 다음과 같다.

1. `prepare_data( )`
   - 원본 `/DMO/FLIGHT`에서 데이터를 읽어 internal table `flights`에 담는다.
   - RAP technical fields에 들어갈 user/timestamp 값을 채운다.

2. `is_empty_db( )`
   - 대상 DB table에 이미 데이터가 있는지 확인한다.
   - 이름은 `is_empty_db`지만, 구현상 `SELECT SINGLE ... FIELDS @abap_true`로 값을 읽기 때문에 실제 의미는 "데이터 존재 여부 확인"에 가깝다.

3. `delete_db( )`
   - 기존 데이터가 있으면 대상 table을 비운다.

4. `insert_db( )`
   - 준비된 internal table `flights`를 대상 DB table에 넣는다.

## timestamp/user technical fields

`GET TIME STAMP FIELD me->timestamp`는 현재 timestamp 값을 만들어 변수에 담는다. DB에서 timestamp를 읽어오는 것이 아니라, ABAP 런타임에서 현재 시간을 가져오는 구문이다.

```abap
GET TIME STAMP FIELD me->timestamp.
```

Exercise 18처럼 DB table에 직접 `INSERT`하는 경우에는 RAP framework가 technical fields를 자동으로 채워주지 않는다. 그래서 다음 필드를 직접 채워야 했다.

```abap
<flight>-local_created_by        = user.
<flight>-local_created_at        = timestamp.
<flight>-local_last_changed_by   = user.
<flight>-local_last_changed_at   = timestamp.
<flight>-last_changed_at         = timestamp.
```

한 줄 정리:

> RAP용 table을 Open SQL로 직접 채울 때는 user/timestamp technical fields도 직접 챙겨야 한다.

## ASSIGNING FIELD-SYMBOL

`LOOP AT ... ASSIGNING FIELD-SYMBOL(<flight>)`는 internal table의 행을 복사하지 않고, 원본 행을 직접 가리키는 방식이다.

```abap
LOOP AT me->flights ASSIGNING FIELD-SYMBOL(<flight>).
  <flight>-local_created_by = user.
ENDLOOP.
```

일반적인 `INTO` 방식은 한 행을 work area로 복사한다.

```abap
DATA ls_flight TYPE /lrn/s4d400_apt.

LOOP AT flights INTO ls_flight.
  ls_flight-local_created_by = user.
  MODIFY flights FROM ls_flight.
ENDLOOP.
```

차이는 다음과 같다.

| 방식 | 의미 | 수정 반영 |
|---|---|---|
| `INTO ls_flight` | 한 행을 work area로 복사 | 수정 후 `MODIFY` 필요 |
| `ASSIGNING <flight>` | internal table의 원본 행을 직접 참조 | 수정 즉시 원본 행에 반영 |

Exercise 18에서는 모든 행의 technical fields를 수정해야 하므로 `ASSIGNING FIELD-SYMBOL`이 잘 맞는다.

## matches_template 메소드

`matches_template`는 대상 테이블이 실제로 존재하고, 템플릿 테이블 `/LRN/S4D400_APT`와 같은 구조인지 검사하는 방어 코드다.

동적 table 이름을 사용할 때는 다음처럼 런타임에 어떤 table이 들어갈지 결정된다.

```abap
INSERT (table_name) FROM TABLE @flights.
```

따라서 `table_name`에 존재하지 않는 이름이나 구조가 다른 table이 들어가면 문제가 생길 수 있다. `matches_template`는 그 전에 미리 확인한다.

검사 흐름은 다음과 같다.

1. `cl_abap_typedescr=>describe_by_name( )`
   - `table_name`에 해당하는 DDIC 타입 정보를 가져온다.
   - 없으면 `abap_false`.

2. `typedescr->kind`와 `is_ddic_type( )`
   - 구조 타입인지, ABAP Dictionary에 정의된 타입인지 확인한다.

3. `components` 비교
   - 대상 table의 필드 목록과 템플릿 `/LRN/S4D400_APT`의 필드 목록을 비교한다.
   - 다르면 `abap_false`.

핵심 코드는 다음 부분이다.

```abap
IF CAST cl_abap_structdescr( typedescr )->components <>
   CAST cl_abap_structdescr(
     cl_abap_typedescr=>describe_by_name( template_table )
   )->components.
  result = abap_false.
  RETURN.
ENDIF.
```

한 줄 정리:

> `matches_template`는 동적 DB table insert를 하기 전에, 대상 table이 템플릿과 같은 필드 구조인지 런타임에 확인하는 안전장치다.

