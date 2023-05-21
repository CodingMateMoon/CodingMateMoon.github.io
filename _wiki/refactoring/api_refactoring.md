---
layout  : wiki
title   : API 리팩토링
summary : 
date    : 2023-05-21 10:40:16 +0900
updated : 2023-05-21 21:26:53 +0900
tag     : 
toc     : true
public  : true
parent  : 
latex   : false
resource: a63ba110-6c2c-460f-ba68-1fde361cd7eb
---
* TOC
{:toc}

## 질의 함수와 변경 함수 분리하기 (Separate Query from Modifier)

what? 값을 조회하는 코드와 값을 변경하는 코드가 섞여있는 코드가 있을 경우 값을 조회하는 함수, 값을 변경하는 함수로 각각 분리하는 리팩토링입니다. 명령-조회 분리(command-query separation)

why? 어떤 값을 리턴하는 함수는 사이드 이팩트가 없어야합니다. 눈에 띌만한(observable) 사이드 이펙트가 없이 값을 조회할 수 있는 메서드가 테스트하기 편하고 그 메서드를 다른 곳으로 이동하기도 편합니다. 값을 변경하는 내용이 같이 있다면 해당 함수를 사용할 때 고려해야할 사항이 많아지고 함수를 옮길 때 값을 변경하는 필드도 같이 옮겨야 하기 때문에 그런게 없다면 더 간편해집니다. 
e.g) getTotalOutstandingAndSendBill -> totalOutstanding, sendBill로 분리


## 함수 매개변수화하기 (Parameterize Function)

함수에 매개변수를 추가하는 것입니다. 함수가 여러 개가 있는데 함수들이 하는 일 자체가 매개변수 하나값 가지고 바뀌는 경우 매개변수를 추가해서 여러 함수를 줄일 수 있다면 해당 리팩토링을 적용합니다. 

## 플래그 인수 제거하기 (Remove Flag Argument)

what? 함수에 매개변수로 전달해서 함수 내부의 로직을 분기하는데에 사용하는 플래그 매개변수를 제거하는 리팩토링입니다.

why? boolean, enum, string 등 플래그성 매개변수는 조건문 switch, if 등에서 활용되는데 if true이면 특정 일, false면 다른 일 등 분기에 쓰는 매개변수로 활용합니다. 플래그가 2~3개 등 여러 개가 있으면 너무 많은 일을 하는 것입니다. 플래그가 하나 있는 경우에도 메서드가 다른 일을 하는 것을 의미하지만 호출부 입장에서 어떤 일을 하는지 메서드 내 구현을 봐야 알 수 있습니다. 플래그를 제거해서 2개의 메서드로 분리합니다.
e.g) deliveryDate(Order order, boolean isRush) -> regularDeliveryDate(Order order), rushDeliveryDate(Order order)


## 객체 통째로 넘기기 (Preserve Whole Object)

what?
함수의 매개변수가 많은 경우 객체를 넘겨서 파라미터 개수를 줄이는 기법입니다. 
함수로 넘기는 파라미터 중 여러 파라미터가 하나의 object, record에서 파생된 값들인 경우가 종종 있는데 해당하는 object, record를 파라미터로 넘겨서 파라미터 개수를 줄이는 기법

why? 
object, record 등을 함수의 파라미터로 넘겨서 파라미터 개수를 줄이고 객체 단위로 필요한 데이터들을 관리할 수 있습니다. 이 기술을 적용하기 전 해당 메소드가 오브젝트 타입, 레코드 타입에 의존해도 되는가, 다른 레코드 타입도 이 메서드로 비슷한 일을 할 것인가에 대해 고려하고 primitive 타입 파라미터를 받도록 유지할 수도 있습니다.

e.g) 
private String getMarkdownForParticipant(String username, Map<Integer, Boolean> homework)  ->  private String getMarkdownForParticipant(Participant participant)

## 매개변수를 질의 함수로 바꾸기 (Replace Parameter with Query)

매개변수로 전달하는 것을 줄이고 함수를 통해 가져올 수 있도록 합니다.

## 질의 함수를 매개변수로 바꾸기 (Replace Query with Parameter)

함수의 의존성을 컨트롤하는 기술. 함수를 호출할 때 어떤 값을 전달할 것인가. composite 객체가 가진 값들을 전달할 것인가 레퍼런스 자체를 넘길 것인가.

## 세터 제거하기 (Remove Setting Method)

immutable, mutable 변경하면 안되는 데이터인지 변경 가능한 데이터인지 판단하고 변경하면 안된다면 제거

## 생성자를 팩토리 함수로 바꾸기 (Replace Constructor with Factory Function)

생성자는 반드시 해당하는 클래스의 이름을 써야하지만 팩토리 함수는 이름을 더 자유롭게 쓰고 return 타입을 지정할 수 있는데 하위 클래스의 인스턴스를 return할 수도 있습니다.

## 함수를 명령으로 바꾸기 (Replace Function with Command)

일반 함수를 쓸 것이냐 함수를 Command 패턴이라고 불리는 클래스로 만들 것이냐. Command는 실행하라는 함수를 가지고 있는 클래스. 둘 사이에서 결정.
e.g) undo 기능.  함수에서 필요한 매개변수들을 builder 형태로 제공하거나 실행하는 행위 자체를 다형성을 활용해서 다양한 형태로 변화를 줄 수 있는 구조를 만들 것이냐 등이 필요할 때 Command 패턴. class execute 메서드, 원하면 undo 메서드도 추가. 하지만 이러한 복잡함이 필요없다면 일반 함수를 사용합니다.

## 명령을 함수로 바꾸기 (Replace Command with Function) 


## 참고자료
* 코딩으로 학습하는 리팩토링(인프런 강의) : <https://www.inflearn.com/course/%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81/dashboard>
