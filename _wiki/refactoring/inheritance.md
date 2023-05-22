---
layout  : wiki
title   : 상속 다루기 [refactoring]
summary : 
date    : 2023-05-23 07:22:29 +0900
updated : 2023-05-23 07:24:11 +0900
tag     : refactoring
toc     : true
public  : true
parent  : refactoring
latex   : false
resource: 0969de49-ed92-464b-8c2e-d3af81651a22
---
* TOC
{:toc}

## 메소드 올리기 (Pull Up Method)

여러 서브클래스에서 공통으로 사용되는 메서드가 있다면 상위클래스로 올려서 공통으로 사용합니다.

## 필드 올리기 (Pull Up Field)

## 생성자 본문 올리기 (Pull Up Constructor Body)

서브클래스의 생성자에서 공통적으로 반복되는 코드가 있다면 해당 코드를 메서드로 추출해서 상위클래스의 생성자로 올립니다. 또는 바로 상위클래스의 생성자로 올립니다. 

## 메서드 내리기 (Push Down Method)

슈퍼클래스가 가진 메서드 필드 중 특수한 경우에 사용하는 경우 메서드, 필드 내리기 적용.

## 필드 내리기 (Push Down Field)

## 타입 코드를 서브클래스로 바꾸기 (Replace Type Code with Subclasses)

what? 
 타입에 해당하는 필드를 가진 코드에 대해 상속 구조를 만들어서 변경합니다. 
분류가 나뉘며 다른 타입으로 표현해야하는 경우 string, enum, int 등 primitive 타입으로 다루며 if else, switch문 등으로 분기 처리를 할 수 있는데 이러한 타입 코드를 서브클래스로 바꾸는 리팩토링입니다.

why? 
 다형성을 활용할 수 있는 조건문이 많아질수록 서브클래스를 만들어서 코드를 두는게 이해하기 좋고 각각의 타입에 따라 사용하는 필드가 달라지는 경우에도 관리하기 좋습니다.

e.g) 
직원 : 엔지니어, 매니저, 세일즈 등 Employee 클래스 (1) String type-> Engineer, Manager, Salesman (2) String type -> EmployeeType type


## 서브클래스 제거하기 (Remove Subclass)

메서드 필드 올리는 등 조정을 하다보면 서브클래스의 코드가 다 비워져서 의미가 없어질 때가 있습니다. 죽은 코드 제거하기와 마찬가지입니다. 죽은 코드는 아에 레퍼런스가 없겠지만 서브클래스를 사용하는 코드가 있을 수 있습니다. 해당 서브클래스를 사용하는 코드를 상위클래스 등 다른 클래스를 사용하도록 바꿉니다.

## 슈퍼클래스 추출하기 (Extract Superclass)

비슷한 기능을 하는 코드들이 있다면 슈퍼클래스를 만들어서 공통으로 적용합니다.

## 계층 합치기 (Collapse Hierarchy)

상속 구조로 코드를 조정하다 의미가 없어진 계층 구조를 단축시키는 것

## 서브클래스를 위임으로 바꾸기 (Replace Subclass with Delegate)

상위클래스와 서브클래스간에 관계가 깊게 맺어지면 상위클래스의 영향을 많이 받고 상속도 1개만 가능한데 상속 구조를 포기하고 위임으로 변경할 수 있습니다.


## 슈퍼클래스를 위임으로 바꾸기 (Replace Superclass with Delegate)
 
