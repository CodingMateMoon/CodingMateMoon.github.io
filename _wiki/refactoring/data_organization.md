---
layout  : wiki
title   : 데이터 조직화-데이터 구조를 다루는 기술
summary : 
date    : 2023-05-17 20:09:57 +0900
updated : 2023-05-17 20:21:37 +0900
tag     : refactoring
toc     : true
public  : true
parent  : [[refactoring]]
latex   : false
resource: 5fa4c194-5f65-4df8-9fd8-c84a25afb0f1
---
* TOC
{:toc}

## 변수 쪼개기 (Split Variable)
What? 한 변수가 하나의 역할만 하도록 이름을 분리하고 변수를 나누는 리팩토링입니다.

Why? 어떤 변수가 두 가지 의미를 가지는 경우.  한 변수가 여러번 할당되는 것이 옳은가?  temp 변수에 처음에는 둘레를 구한 값을 할당했다가 두번 째에는 넓이를 구한 값을 저장하는 등 여러 용도로 사용할 때 한 변수는 하나의 용도로만 사용하도록 perimeter, area 등으로 Split Variable을 적용하는게 변수를 이해하기 더 좋습니다.

## 필드 이름 바꾸기 (Rename Field)
명확한 이름 주기

## 파생 변수를 질의 함수로 바꾸기 (Replace Derived Variable with Query)
What? 계산할 수 있는 변수를 필드로 선언하지 않는 것. 수량 * 아이템 가격 = 총 합계. 총 합계에 해당하는 필드를 만들지 않는 것입니다. 다른 변수를 통해서 계산할 수 있는 변수는 굳이 만들지 않고 함수를 통해서 값을 가져올 수 있도록 합니다.  

Why? 계산 자체가 데이터의 의미를 잘 표현하는 경우도 있고 해당 변수가 어디선가 잘못된 값으로 수정될 수 있는 가능성을 제거할 수 있다.

## 참조를 값으로 바꾸기 (Change References to Value)
What? 메서드 파라미터에 Reference 대신 Value를 넘기는 것입니다. 메서드 파라미터에 Employee를 줄 것이냐 Employee의 name값을 전달할 것이냐와 같습니다. 

Why? 파라미터에 Reference를 넘길 때 메서드에서 해당 Reference에 대한 의존성이 생길 수 있습니다. 파라미터에 composite한 객체 타입을 줄 것인가 low level의 데이터를 전달할 것인가 판단이 중요합니다. Reference안의 여러 데이터들을 참조할 것이 있다면 해당 Reference를 전달하겠지만 그 중 일부 변수만을 사용한다면 해당 값들을 메서드 파라미터에 전달합니다.

## 값을 참조로 바꾸기 (Change Value to Reference)


## 참고자료
* 코딩으로 학습하는 리팩토링(인프런 강의) : <https://www.inflearn.com/course/%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81/dashboard>
