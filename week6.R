Sys.setlocale("LC_ALL", "Korean")
library(lubridate)
library(dplyr)
library(ggplot2)

install.packages("dplyr")
install.packages("ggplot2")

#자주 사용되는 기본 함수
#aggregate() : 다양한 함수를 사용하여 결과 출력
#apply() : 다양한 기능
#cor() : 상관함수
#cumsum() : 설정된 지점까지의 누적합
#cumporm() : 설정된 지점까지의 누적곱
#diff() : 차이나는 부분을 찾는다
#length() : 요소 갯수
#min(): 최소값
#mean() : 평균
#meidan() : 중앙값
#order() : 요소의 원위치
#prod() : 누적곱
#range() : 범위
#rank(): 순위
#sd() : 표준편차
#rev() : 역순
#sort() : 정렬
#summary() : 요약
#sweep() : 일괄적빼기
#tapply() : 벡터에서 주어진 함수 연산
#var() : 분ㅅ나

v1 = c(1,2,3,4,5)
v2 = c('a','b','c','d','e')

install.packages("googleVis")
library(googleVis)
Fruits

#aggregate(계산될컬럼~기준될컬럼, 데이터, 함수) : 데이터플임 상대로 주어진 함수값 구하기
#년도벼로 판매된 수량의 합계
aggregate(Sales~Year, Fruits, sum)

#과일별로 가장 많이 판매된 수량

aggregate(Sales~Fruit, Fruits, max)

#과일별로 최대 판매량에 연도를 추가해서 과일별, 년도별 최대 판매량을 출력하라

aggregate(Sales~Fruit+Year, Fruits, max)

#apply(데이터, 행(1)/열(2),함수) : matrix에 유용하게 사용(행, 열을 대상으로 작업)

m1 = matrix(c(1,2,3,
              4,5,6), 2, by=T)

m1
apply(m1,1,sum)
apply(m1,2,sum)
apply(m1[,c(2,3)], 2, max)

#lapply(데이터,함수)/ sapply(데이터, 함수) : list처리
l1list = list(Fruits$Sales)
l2list = list(Fruits$Profit)

lapply(c(l1list, l2list), max) #출력결과 : list형

sapply(c(l1list, l2list), max) # 출력겨로가 : 벡터형

#데이터프레임에서 사용

lapply(Fruits[,c(4,5)], max)

sapply(Fruits[,c(4,5)], max)

#tapply(출력값, 기준컬럼, 함수) : 데이터셋의 factor를 처리
#mapply(함수, 벡터1, 벡터2, ...., 벡터n) : 벡터나 리스트를 데이터프레임처럼 처리
#~ 데이터프레임이 아닌 벡터나 리스트형태로 데이터가 있을 때 마치 데이터프레임처럼 연산을 해주는 함수, 단 벡터들의 요소갯수가 동일해야한다 

Fruits
tapply(Fruits$Sales, Fruits$Fruit, sum)

#컬럼명을 변수로 직접 사용하기 : attach
#attach(Fruits) : 컬럼명을 변수처럼 직접 사용 ㅏ능, 공통적으로 계속 사용되는 대상 데이터프레임을 지정할때, $ : dataframe$컬럼명은 입력할 데이터가 몇개안되는 소량일때

attach(Fruits)
tapply(Sales, Fruit, sum)

#년도별 판매도니 합계
tapply(Sales, Year, sum)
aggregate(Sales~Year. Fruits,sum)

read.csv(data1)

#사용자 정의 함수 : 함수를 직접 만들어서 사용
#함수명 = function(인수 또는 입력값) {
#   수식1
#   수식2
#   ...
#   return (반환값)
#}
#
#1. 입력값이 없는 경우

my1 = function() {
  return(10)
}

my1

my1()

#2. 입력값(인자)이 있는 경우

my2 = function(a) {
  b = a^2
  return(b)
}

my2(3)

my3 = function(a,b) {
  c = abs(a-b)
  return(C)
}

my3(2,3)

my4 = funcion(a,b) {
  if (a>b) {
    c = a-b
  } else {
    c= b-a
  }
  return(c)
}

my4(2,3)

#sort() : 정렬

s1 = Fruits$Sales
s1

sort(s1)
sort(s1, decreasing = T)

#plyr(): 원본 데이터를 분석하기 쉬운 형태로 나누어서 다시 새로운 형태로 만들어주는 패키지
#-apply() 함수를 확장
#-ply(data, 기준컬럼, 함수)란, 함수앞에 두글자 : 첫번째 글자는 입력될 데이터유형, 두번째 글자는 출력될 데이터 유형
# - d : dataframe, a : array(matrix), l : list
# - dlply(), laply

install.packages("plyr")
library(plyr)

f = read.csv('fruit_10.csv')

# summarise : 기존 컬럼의 데이터끼리 모은 후 함수를 적용(sql의 group by와 유사)
# 과일이름으로 판매량 합계와 가격 합계를 구하여라.

ddply(f, 'name', summarise, sum_qty = sum(qty), sum_price = sum(price))


#transform: 만약 동일한 컬럼이 아닌 각 행별로 연산을 수행해야 해당값을 할께 출력해야 할 경우
#즉, 주어진 데이터프레임에서 기준 컬럼으로 모은 후 계산해서 출력하고 싶은 경우 summarize, 다른 계산을 각 행별로 각각 출력하고 싶은 경우 transform
