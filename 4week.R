setwd("c:/r_workdata")
Sys.setlocale("LC_ALL", "Korean")
library(lubridate)

v1 = c('a', 'b', 'c', 'd', 'e', 'f')
v1[c(3,5)] = toupper(v1[c(3, 5)])
v1
v1 =v1[-4]
v1 = as.factor(v1)
class(v1)
v1 = seq(as.Date("2022-01-01"), as.Date("2122-12-31"), 1)
v2=format(v1, "%m/%d")
class(v2)
d1 = v1
names(d1) = 1:length(d1)
d1
d1[d1=="2022-02-28"]
d2 = append(as.character(d1), "2022-02-29", after=59)
d2
d3=as.Date(d2)
d3
m3 = matrix(c(1,2,3,4), nrow=2, byrow = T)
m3
m4 =  matrix(c(1,2,3,
               4,5,6,
               7,8,9), 3, by=T)
m4
#새로운 행과 열 추가 : rbind(), cbind()
m4 = rbind(m4,c(11,12,13))
#행, 열이름 지정
rownames(m4) = c(1,2,3,4,5)
m1 = matrix(1:20, 4, by=T)
m1
dimnames(m1) = list(c(1,2,3,4), c('a','b','c','d','e'))
#색인
m1[2,3]
m1[-3,]
#행렬조건
m1 >= 10
m1 [, 'c'] >= 10
m1[m1[.'c']>=10,]

#m1의 e값이 20인 행의 3~5번째의 컬럼 출력
m1[m1[,'e']==20, 3:5]

#matrix 문제
no = c(1,2,3,4)
name = c('apple', 'banana', 'peach', 'berry')
price = c(500,200,200,50)
qty = c(5,2,4,7)

m1 = cbind(no,name,price,qty)
m1

#1. peach의 가격 출력
m1[m1[, 'name']=='peach', 'price']

#2. apple과 peach의 데이터만 출력
m1[m1[, 'name']=='apple' | m1[,'name']=='peach',]

#3. sales라는 컬럼생성(단, sales는 price*qty)

sales = as.numeric(m1[,'price'])*as.numeric(m1[,'qty'])
sales
cbind(m1,sales)

#4. 첫번째 컬럼제거후 각 행번호 설정
rownames(m1) = m1[,1]
m1
m1=m1[,-1]
m1

#5. qty가 5이상인 과일 이름 출력

m1[m1[,'qty']>=5, 'name'] #matrix에서 비교연산으로 원소 추출 시 1차원 벡터로 리턴이 된다(행렬구조를 잃어버린다)

#6. 5번째 과일추가 (mango, 100원, 10개)
v1 = c('mango', 100, 10)
m = rbind(m1, v1)
m1 = rbind(m1, v1)
m1
rownames(m1)[5]=5
m1

#array : 3차원배열(행,렬,높이)
#matrix를 쌓아 놓은 형태

a1 = array(c(1:12), dim=c(4,3))
a1

a2 = array(c(1:12), dim=c(2,2,3))
a2
a2[1,1,3]
