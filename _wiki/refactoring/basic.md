---
layout  : wiki
title   : Refactoring 기본 기술
summary : refactoring
date    : 2023-05-13 10:01:33 +0900
updated : 2023-05-20 09:25:01 +0900
tag     : 
toc     : true
public  : true
parent  : refactoring
latex   : false
resource: 333348d4-285e-45d4-9db6-77ac4e177e97
---
* TOC
{:toc}

# 함수 추출하기 (Extract Function)
* "의도"와 "구현" 분리하기. 코드를 읽었을 때 무슨 일을 하는 지 책처럼 잘 읽히며 파악할 수 있다면 의도를 읽는 것이고 분석이 필요하다면 구현을 읽는 것입니다.
* 무슨 일을 하는 코드인지 알아내려고 노력해야 하는 코드라면 해당 코드를 함수로 분리하고 함수 이름으로 무슨 일을 하는지 표현할 수 있습니다. 함수안의 주석을 함수의 이름으로 바꾸고 메서드로 추출할 수 있습니다.
# 함수 인라인하기 (Inline Function) 
변수를 쓰지 않고도 충분히 이해 가능한 경우 
# 변수 추출하기 (Extract Variable)
# 변수 인라인하기 (Inline Variable)
# 함수 선언 변경하기 (Change Function Declaration)
* 의도를 더 명확히 드러낼 수 있는 이름으로 변경합니다.
# 변수 캡슐화하기 (Encapsulate Variable)
* 변수를 변경할 때는 해당 변수를 사용하는 모든 곳을 찾아서 변수 변경 시점에 모두 다 변경해주어야합니다. 메서드 변경의 경우 기존 메서드를 그대로 둔 상태로 새로운 메서드를 만들고 코드의 일부분이 새로운 메서드를 사용하도록 고치며 나머지 코드들은 계속 기존 메서드들을 사용하도록 남겨둘 수 있습니다. 점진적으로 변경할 수 있는 장점이 있기에 변수를 직접 접근해서 사용하는 코드들을 가급적 메서드로 감싸주는 작업을 해주면 변경에 좀 더 유연하게 대처할 수 있습니다. local 변수, class 변수, 전역 변수 등 변수의 범위가 커질수록 변수 자체에 변경을 가하기 어려워집니다. Encapsulate Variable을 통해 데이터 접근을 메서드를 통해서 할 수 있도록 하는 것이 좋고 불변 데이터(immutable data)의 경우에만 예외로 둡니다. 불변 데이터는 값이 할당된 뒤 변경되지 않기에 변경될 때마다 올바른 값으로 세팅했는지 검증할 필요가 없고 값이 변경된 후 후처리 작업도 필요가 없어서 Encapsulate Variable을 적용할 필요가 없습니다.
# 변수 이름 바꾸기 (Rename Variable)
# 매개변수 객체 만들기 (Introduce Parameter Object)
# 여러 함수를 클래스로 묶기 (Combine Functions into Class)
# 여러 함수를 변환 함수로 묶기 (Combine Functions into Trasnform)
# 단계 쪼개기 (Split Phase)
 
# 참고자료
* 코딩으로 학습하는 리팩토링(인프런 강의) : <https://www.inflearn.com/course/%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81/dashboard>
