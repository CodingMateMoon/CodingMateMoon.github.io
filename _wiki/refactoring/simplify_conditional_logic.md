---
layout  : wiki
title   : 조건부 로직 간소화 (refactoring)
summary : 
date    : 2023-05-18 08:45:25 +0900
updated : 2023-05-18 09:01:00 +0900
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

동일한 조건부 로직, 동일한 switch문이 여러 번 나타난다면 다형성을 적용해서 바꿀 수 있습니다.
일반 로직, 특수 로직이 있을 때 상속을 활용해서 특수 로직을 처리하는 서브 클래스로 만듭니다.

# 특이 케이스 추가하기 (Introduce Special Case)
null object pattern. 

# 어서션 추가하기 (Introduce Assertion)

해당하는 코드가 실행되는 와중에 시스템적으로 가정하는 상태가 있다면 그 상태를 의사소통하는 용도로 assertion을 활용해서 표현합니다. 
