---
layout  : wiki
title   : 조건부 로직 간소화 (refactoring)
summary : 
date    : 2023-05-18 08:45:25 +0900
updated : 2023-05-19 20:06:06 +0900
tag     : refactoring
toc     : true
public  : true
parent  : refactoring
latex   : false
resource: bb84aa0c-6792-4441-b485-2021e0d9a436
---
* TOC
{:toc}

# 조건문 분해하기 (Decompose Conditional)

if문안에 연산식이 길게 있을 때 if else 등 extract 메서드로 빼내면서 이름을 주기. 
if 읽을 수 있는 이름의 메서드,  true인 경우 읽을 수 있는 메서드 

# 조건식 통합하기 (Consolidate Conditional Expression)

여러 조건문이 있는 경우 하나의 메서드로 빼내는 경우 


# 중첩 조건문을 보호 구문으로 바꾸기 (Replace Nested Conditional with Guard Clauses)

What? 여러 if, else if, else 문 등이 있을 때(e.g ip, plat, normal 등급 등) 조기 리턴을 활용해서 함수를 빠져나오는 방식의 보호구문으로 변경하는 것입니다.

Why? if, else if, else if 등 중첩된 조건문의 경우 하나의 조건을 수정하기 위해 다른 여러 조건들의 내용도 파악해야하는 등 코드를 읽을 때 고려해야할 사항들이 많아집니다. if문에서 true false 등 조건들이 50 대  50으로 동등한 균형을 이루는 경우에는 상관없지만 메인 케이스와 특수 케이스가 있는 경우 한쪽을 강조하는 것이 필요할 수 있습니다. 보호 구문으로 변경할 경우 특정 조건에 해당하면 return으로 함수를 종료시켜서 다른 조건에 대해 신경 쓸 필요가 없어지고 로직을 이해하기 편해집니다. 

```java
public class GuardClauses {

    public int getPoints(){
        // normalPoint가 메인 케이스이고 vipPoint, platPoint가 특수한 경우라면 중첩 조건문을 보호 구문으로 바꾸기(Replace Nested Condition with Guard Clauses)를 적용할 수 있습니다.
        if (isVip()) return vipPoint();
        if (isPlat()) return platPoint();
        return normalPoint();
        /*
        int result;
        if (isVip()) {
            return  vipPoint();
        } else if (isPlat()) {
            result = platPoint();
        } else {
            result = normalPoint();
        }
        return result;
         */
    }
```
# 조건부 로직을 다형성으로 바꾸기 (Replace Conditional with Polymorphism)

what? switch, if else문이 여러 번 등장하며 분기처리를 하는 경우, 일반 로직과 거기서 파생되는 특수한 로직이 있는 경우 등 조건부 로직에 대해 상속을 활용해서 하위클래스로 나누는 리팩토링입니다.

Why? 복잡한 조건식에 대해 다형성을 활용해서 명확하게 분리하고 이해하기 쉬운 코드로 바꿀 수 있습니다.

e.g, "full-time", "part-time", "temporal" 등 String type에 대해 switch를 통해 분기처리하는 로직에 대해 하위 클래스에서 각 type에 맞는 작업을 처리하도록 변경할 수 있습니다. Employee -> FullTimeEmployee, PartTimeEmployee, TemporalEmployee에서 type에 맞는 휴가일수를 구하도록 변경합니다.


# 특이 케이스 추가하기 (Introduce Special Case)

what? 어떤 필드의 특정한 값에 따라 동일하게 동작하는 코드가 반복적으로 나타난다면, 해당 필드를 감싸는 “특별한 케이스”를 만들어 해당 조건을 표현할 수 있습니다.

why? 필드의 특정값에 따라 조건을 체크하는 로직 등이 반복적으로 나타나는 경우 해당 코드를 메서드로 추출하고 해당 필드가 속해있는 클래스의 메서드로 만들어서 활용함으로써 코드의 재사용성을 높일 수 있습니다.

e.g) Null Object Pattern. customer.getName().equals("unknown") 조건 체크 로직을 메서드로 추출하고 Customer 클래스쪽으로 이동시킨 뒤 이름이 unknown인 경우 UnknownCustomer 하위클래스를 만들어서 별도 로직을 처리하도록 변경


# 어서션 추가하기 (Introduce Assertion)

What? 코드로 표현하지 않았지만 기본적으로 가정하는 조건에 대해 Assertion을 사용해서 명시적으로 나타내는 것입니다. Assertion은 항상 true이길 기대하는 조건을 표현할 때 사용하는데 Assertion이 없어도 프로그램이 동작해야합니다. 자바에서는 컴파일 옵션으로 assert문을 사용하지 않도록 설정할 수 있습니다.

Why? 특정 부분에서 특정한 상태를 가정하고 있다는 것을 명시적으로 나타냄으로써 의사소통으로서의 가치를 지니고 있고 테스트 코드 실행 시 해당 가정이 깨진 경우에 대해 조기에 발견할 수 있습니다.

e.g) 
```java
    public void setDiscountRate(Double discountRate) {
        assert discountRate != null && discountRate > 0;
        if (discountRate != null && discountRate > 0) {
            throw new IllegalArgumentException(discountRate + " can't be minus.");
        }
        this.discountRate = discountRate;
    }
```

# 참고자료
* 코딩으로 학습하는 리팩토링(인프런 강의) : <https://www.inflearn.com/course/%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81/dashboard>
