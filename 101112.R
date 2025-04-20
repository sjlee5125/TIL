setwd("C:/r_workdata")  # 원하는 폴더 경로로 바꾸기
Sys.setlocale("LC_ALL","")

library(lubridate)
library(dplyr)
library(ggplot2)

#자주 사용되는 기본함수
#appregate():다양한 함수를 사용하여 결과 출력
#apply():다양한 기능
#cor():상관함수
#cumsum():설정된 지점까지의 누적합
#cumporm():설정된 지점까지의 누적곱
#diff():차이나는 부분을 찾는다
#length():요소 갯수
#max():최대값
#min():최소값
#mean():평균
#median():중앙값
#order():요소의 원위치
#prod():누적곱
#range():범위
#rank():순위
#sd():표준편차
#rev():역차
#sort():정렬
#summary():요약
#sweep():일괄적 뺴기
#tapply():벡터에서 주어진 함수 연산
#var():분산


v1 =c(1,2,3,4,5)
v2 =c('a','b','c','d','e')
max(v1)
max(v2)
mean(v1)
mean(v2)
sd(v1)
sum(v1)
var(v1)

install.packages("googleVis")
library(googleVis)

Fruits
#appregate(계산될컬럼~기준될컬럼,데이터,함수):데이터프레임 상대로 주어진함수값구하기
#
#년도별로 판매된 수량의 합계
#과일별로 가장많이 판매된 수량
appregate(Sales~Fruit, Fruits,max)
#과일별로 최대 판매량에 연도를 추가해서 과일별, 년도별 최대 판매량 출력
appregate(Sales~Fruit+Year,Fruits,max)
#apply(데이터,행(1)/열(2), 함수):matix에 유용하게 사용(행,열을 대상으로 작업)
m1=matrix(c(1,2,3,4,5,6), 2,by=T)
m1
apply(m1,1,sum)
apply(m1,2,sum)
apply(m1[,c(2,3)],2,max)
#lapply(데이터,함수)/sapply(데이터,함수):list처리
l1=list(Fruits$Sales)
l2=list(Fruits$Profit)
l1
l2
lapply(c(l1,l2),max)#출력결과:list형
sapply(c(l1,l2),max)#출력결과:벡터형
#데이터 프레임에서 사용
lapply(Fruits[,c(4,5)],max)
sapply(Fruits[,c(4,5)],max)

#tapply(출력값, 기준컬럼,함수):데이터셋의 factor처리
#mapply(함수,벡터1,벡터2,....,벡터n):벡터나 리스트
#-데이터프레임이 아닌 벡터나 리스트형태로 데이터가 있을 때 마치 데이터 프레임처럼 연산을 해주는 함수.단,벡터들의 요소갯수가 동일해야한다
Fruits
tapply(Sales,Fruit,sum)
tapply(Fruits$Sales,Fruits$Fruit,sum)
#$ -> String
#컬럼명을 변수로 직접 사용하기:attach
#attach(Fruits):컬럼명을 변수처럼 직접사용이 가능,공통적으로 계속 사용되는 대상 데이터 프레임을 지정할 때 , $:dataframe$컬럼명은 입력할 데이터가 몇개 안되는 상황일때


attach(Fruits)
tapply(Sales,Fruit,sum)

tapply(Sales,Fruits,sum)
aggregate(Sales~Fruit,Fruit,sum)

#년도별 판매된 합계 
tapply(Sales,Year,sum)
aggregate(Sales~Year,Fruits,sum)

v1=c(1,2,3,4,5)
v2=c(10,20,30,40,50)
v3=c(100,200,300,400,500)
mapply(sum,v1,v2,v3)
d1 <- read.csv("data1.csv", fileEncoding = "cp949")  # 한글이 포함되어 있다면 인코딩 추가
d1
View(d1)
apply(d1[,c(2:15)],2,sum)
apply(d1[,c(2:15)],1,sum)

#사용자 정의함수:함수를 직접 만들어서 사용
#함수명=function(인수 또는 입력값){
#수식1
#수식2
#...
#return(반환값)
#}
#1.입력값이 업슨ㄴ 경우


my1=function(){
  return(10)
}
my1
my1()


#2.입력값(인자)이 있는경우

my2=function(a){
  b=a^2
  return(b)
}
my2(3)
my3=function(a,b){
  c=abs(a-b)
  return(c)
}
my3(2,3)

my4=function(a,b){
  if(a>b){
    c=a-b
  }else{
    c=b-a
  }
  return(c)
}
my4(2,3)
#sort():정렬

s1=Fruits$Sales
s1
sort(s1)
sort(s1,decreasing = T)

#plyr():원본데이터를 분석하기 쉬운 형태로 나누어서 다시 새로운 형태로 만들어주는 
#- apply()함수를 확장
#-ply(data,기준컬럼,함수)란 , 함수앞에 두글자: 첫번째 글자는 입력될 데이터 유형 , 두번쨰 글자는 출력될 데이터 유형
#-d: dataframe,a:array(matrix),l:list
#-dlply()laply()

install.packages("plyr")
library(plyr)
f=read.csv('fruits_10.csv')
f

#summarise:기존컬럼의 데이터끼리 모은 후 함수를 적용(slq의 group by와 유사)
#과일이름으로 판매량 합계와 가격합계를 구하여라

ddply(f,'name',summarise,sum_qty=sum(qty),sum_price=sum(price))
#과일이름별로 최고 판매량과 최저가격을 구해라
ddply(f,'name',summarise,max_qty=max(qty),min_price=min(price))
#년도별 ,과일이름별로 최고 판매랑과 최저가격을구해라
ddply(f,c('year','name'),summarise,max_qty=max(qty),min_price=min(price))
#transform:만약 동일한 컬럼이 아닌 각 행별로 연산을 수행하여 해당값을 함꼐 출력해야 할 경우 
#-즉, 주어진 데이터프레임에서 기준 컬럼으로 모은 후 계산해서 출력하고 싶은경우 summarise, 다른 계산을 각 행별로 각각 출력하고 싶은경우 transform
f

#pct_qty는 해당 과일의 판매수량이 기준 컬럼으로 합계한 총 판매갯수대비 몇%를 차지하는지 계산할경우 
ddply(f,'name',transform, sum_qty=sum(qty), pct_qty=round(qty*100/sum(qty),2))

      