setwd("c:/r_workdata")
getwd()

Sys.setlocale("LC_ALL","Korean")

d1 = read.csv("야구성적.csv")
d1

library(lubridate)

l1 = list(name = '홍길동', 
          addr = '서울',
          tel - '010-1111-1111',
          pay = 500)
l1

#특정 키만 조회
l1$addr

l1$birth = '2003'
l1$birth

l1$name = c('고길동','마이콜')
l1$name

l1$name[length(l1$name)+1] = '홍길동'
l1$name

l1$name = append(l1$name, '둘리', after = 1)
l1$name

l1$name[length(l1$name)-1]=NA
l1$name

l1$birth = NULL
l1$name
  
no = c(1,2,3,4)
name = c('Apple','Banana','Peach','Graph')
price = c(500,200,100,300)
qty = c(5,2,4,7)

sales = data.frame(NO=no, NAME=name, PRICE=price, QTY=qty)
sales
class(sales)
str(sales)

sales2 = matrix(c(1,'Apple',500,5,
                 2,'Peach',200,2,
                 3,'Bannana',50,4,
                 4,'Graph',100,7),4, by=T)
sales2

d1 = data.frame(sales2)
d1

names(d1) = c('NO','NAME','PRICE','QTY')
d1
class(d1)
str(d1)

sales
sales$NAME
sales[1,3]
sales[,2]
slaes[3,]
sales[c(1,3),]
sales[,c(2,4)]

#원하는 조건만 검색: 

subset(sales, QTR <=5)
subset(sales, PRICE==200)
subset(sales, NAME=='Apple')

no=c(1,2,3)
name=c('apple','banana','peach')
price=c(100,200,300)
df1=data.frame(NO=no,NAME=name,PRICE=price)
df1

no=c(10,20,30)
name=c('train','car','ship')
price=c(1000,2000,3000)
df2=data.frame(NO=no, NAME=name,PRICE=price)

df1
df2
df3 = cbind(df1, df2)
df3

df4=rbind(df1,df2)
df4

df5=data.frame(name=c('apple','banana','cherry'), price=c(300,200,100))
df6=data.frame(name=c('apple','banana','cherry'), qty=c(10,20,30))
cbind(df5, df6)
rbind(df5,df6)

merge(df5,df6)
merge(df5, df6, all=T)

df1

#df1에 번호가 4,5이고 이름이 'mango', 'berry'와 가격이 각 400,500인 데이터
#생성 후 df1행 추가

n1 = data.frame(NO=c(4,5), NAME=c('mango','berry'), PRICE=c(400,500))
df1=rbind(df1,n1)
df1

#수량이 (10,20,30,40,50)인 데이터를 열추가 하시오
df1 = cbind(df1, qty=c(10,20,30,40,50))
df1

no=c(1,2,3,4,5)
name=c('이순신','김유신','유관순','강감찬','안중근')
addr=c('서울','대전','대구','부산','광주')
tel=c(111,222,333,444,555)
hobby=c('놀','먹','자','게','멍')
mem=data.frame(NO=no,NAME=name,ADDR=addr,TEL=tel,HOBBY=hobby)
mem2=subset(mem, select = c(NO,NAME,TEL))
mem2

mem3 = subset(mem, select=-TEL)
mem3

colnames(mem3)=c('번호','이름','취미')
mem3

sales
ncol(sales)
nrow(sales)
names(sales)
colnames(sales)
rownames(sales)
row.names(sales)
sales[c(2,3,1),]

