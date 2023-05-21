---
layout  : wiki
title   : 기능 옮기기(함수,필드,문장 등을 적절한 위치로 옮기는 기술)
summary : 
date    : 2023-05-17 12:17:59 +0900
updated : 2023-05-20 09:25:16 +0900
tag     : 
toc     : true
public  : true
parent  : refactoring
latex   : false
resource: c43c181b-af06-4cf4-8f7e-1a4e27f7ef89
---
* TOC
{:toc}

## 함수 옮기기 (Move Function)

## 필드 옮기기 (Move Field)

## 문장을 함수로 옮기기 (Move Statements into Function)
어떤 Statement문이 있을 때 함수가 호출하기 전 후에 항상 호출되는 statement문일 경우 그 함수 안에 위치하는 것이 적절합니다. 문장의 적절한 위치 찾아주기

## 문장을 호출한 곳으로 옮기기 (Move Statements to Callers)
extract 메서드 함수 추출하기를 다시 하고 싶은 경우 함수 호출부로 옮긴 후 다시 쪼개거나 여러 함수 중 일부 코드가 중복되는 경우 별도의 메서드로 빼내서 재사용합니다. 

## 인라인 코드를 함수 호출로 바꾸기 (Replace Inline Code with Function Call)
인라인된 코드 자체가 중복되고 여러 곳에서 재사용하거나 이름을 주는 것이 적절한 경우 함수 호출로 바꿉니다. 궁극적으로는 extract method와 유사합니다.

## 문장 슬라이드하기 (Slide Statements)
statement 조정을 해서 코드 정리를 합니다. 메서드에 필요한 변수들, 관련 필드들을 근처에 두고 모아두거나 extract function을 적용해서 함수로 추출합니다. 변수는 쓰기 직전에 선언하고 사용합니다.

## 반복문 쪼개기 (Split Loop)
하나의 반복문에서 여러 다른 작업을 하는 코드를 쉽게 찾아볼 수 있다.
해당 반복문을 수정할 때 여러 작업을 모두 고려하며 코딩을 해야한다.
 반복문을 여러개로 쪼개면 보다 쉽게 이해하고 수정할 수 있다.

## 반복문을 파이프라인으로 바꾸기 (Replace Loop with Pipeline)
C##-LINQ 쿼리 작성하듯이 where select. collection에 sql 적용하듯이 코딩. 기존 loop안에서 작성한 많은 로직들을 오퍼레이션(operation)을 통해 표현할 수 있습니다. 중간에 처리 및 전달하는 오퍼레이션, 종료하는 오퍼레이션이 있습니다. 파이프라인에서 중간 중간에 전달하는 과정. (1) 필터(filter) - 필터는 요소를 걸러내는 작업을 합니다. 특정 조건에 맞는 요소들을 걸러내고 다음 과정으로 전달합니다. if문에 해당하는 로직을 filter로 대체할 수 있습니다. 함수형 프로그래밍을 지원하는 오퍼레이션으로 필터 오퍼레이션의 매개변수는 function 함수를 받습니다. (2) 맵(map) - 어떤 입력값을 받아서 다른 출력값으로 변환해주는 오퍼레이션(함수)을 받습니다. 전달받은 요소를 함수를 통해 다른 형태로 변환하고 싶을 때 map이라는 오퍼레이션을 써서 코드를 단순화합니다.

## 죽은 코드 제거하기 (Remove Dead Code)
 
 
## 참고자료
* 코딩으로 학습하는 리팩토링(인프런 강의) : <https://www.inflearn.com/course/%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81/dashboard>
