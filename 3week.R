setwd("c:/r_workdata")

Sys.setlocale("LC_ALL", "Korean")

library(lubridate)

as.Date("2022-02-14") - as.Date("21.11.06", format="%y.%m.%d")

as.POSIXct("2025-03-19 15:51:00") - as.POSIXct("2025-03-19 13:50:00")

d=now()
d

year(d)
wday(d, label=T)

d2 = d-days(2)
d2

d+days(100)
d+years(1)

d+years(1)+months(2)+days(3)+hours(4)+minutes(5)+seconds(6)

d2 = hm("22:30")
d2

d3 = hms("22:30:15")
d3

seq(as.Date("2025-01-01"), as.Date("2025-12-31"), 1)

seq(as.Date("2025-01-01"), as.Date("2025-12-31"), "day")

seq(as.Date("2025-01-01"), as.Date("2025-12-31"), "month")

seq(as.Date("2025-01-01"), as.Date("2125-12-31"), "year")

d = seq(as.Date("2025-01-01"), as.Date("2125-12-31"), "year")

d[45]
d[35:45]
d[c(35, 45)]

d[c(35, 45) + 1] 
d[c(35, 45)] + years(1)


v1 = 'aa'
v1
class(v1)
v1 = now()
class(v1)
v1 = Sys.Date()
class(v1)
v1 = c('a', 'b', 'c')
v1
v1[1]
class(v1)
str(v1)

11->v3->v4
v3
v4

s1 = "very easy R"
s1

c1 = c(1, 2, 3, 4, '5')
c1
class(c1)

#변수 설정 주의사항
#1.대소문자구분
#2.영어,숫자 모두 사용 가능하지만 첫문자는 반드시 문자
#3. 한글 사용 가능
#4. 예약어 사용 못한다
#if, else, ifelse, for, while, break, function, TRUE, FALSE, NA, NULL, in, rep .....

s1=1:5
s1

objects()
objects(all.names = T)
rm(s1)
objects()
rm(list=ls())
objects()
#데이터처리 객체
#-동일데이터
#스칼라 단일데이터
#벡터 1차원배열 스칼라의합
#matrix 2차원배열 벡터의합
#array 3차원배열 matrix의합

#-다른데이터
#list 벡터와비슷 (키, 값)
#dataframe 엑셀의표,db테이블과같음 db컬럼처럼라벨잇음

#벡터 :1차원배열
#1.c()함수로 작성
#2.인덱스는 1부터 시작
#3.하나의 자료형만 사용
#4.결측값은 'NA'를 사용
#5. NULL은 어떤 형식도 취하지 않는 특별한 객체

v1 = c(1,2,3,4,5)
v1[-length(v1):-(length(v1)-1)]
v1[3:4] = 9
v1

append(v1, 10, after=3)
v1 = append(v1, c(10,11), after=3)
v1 = append(v1, 12, after=0)

c(1,2,3) + c(4,5,6)
c(1,2,3) + 1

v2= c(3,4,5)
v1= c(1,2,3)
v3= c(3,4,"5")
v1+v3
union(v1,v3)

v4= c(1,2,3,4)
v1+v4
v1-v4

setdiff(v1,v2)
intersect(v1,v2)

#벡터의 각 컬럼의 이름 지정
f= c(10,20,30)
names(f)=c('apple','banana','peach')
f
#벡터에 연속적인 데이터 할당 : seq(), rep()

v4 = c(1:5)
v4

v5=seq(1,5)
v5
v6=seq(-2,2)
v6
c6=c(-2:2)
c6
v7=seq(1,10,2)
v7

v8 = rep(1:3,2)
v8

v9 = rep(1:3, each=2)
v9

#벡터의 길이
v1
length(v1)
NROW(v1)

#벡터의 특정 문자 포함 여부
v7
3%in%v7
4%in%v7
