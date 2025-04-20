setwd("c:/r_workdata")

Sys.setlocale("LC_ALL", "Korean")

library(lubridate)
library(dplyr)
library(ggplot2)
library(plyr)

#dplyr() : plyr()와 동시에 사용한다면 plyr 패키지의 함수가 우선 적용
#특성함수
#1. filter : 조건을 줘서 필터링
#2. select : 특정 컬럼만 선택
#3. arrange : 정렬
#4. mutate : 새로운 변수 생성
#5. summarise(with group_by) : 주어진 데이터를 집계(min, max, mean, count)


library(dplyr)

d1 = read.csv("야구성적.csv")
d1
view(d1)

#filter
#경기수가 120경기 이상인 선수

d2 = filter(d1, 경기 >= 120)
d2

#경기수가 120경기 이상이면서 득점도 80점 이상인 선수

d3 = filter(d1, 경기 >= 120 & 득점 >= 80)
d3

# 포지션이 1루수이거나 3루수인 선수

d4 = filter(d1, 포지션 == "1루수" | 포지션 == "3루수")
d4

d4 = filter(d1, 포지션 %in% c("1루수", "3루수"))

# select
# 선수명, 포지션, 팀 데이터만 조회

select(d1, 선수명, 포지션, 팀)

#순위~타수까지 조회

select(d1, 순위:타수)

#특정컬럼 제외

select(d1, -홈런, -타점, -도루)

#%>% : 여러문장을 조합해서 사용

#선수명, 팀, 경기, 타수를 조회를 하되 타수가 400이상인 선수

d1 %>%
  filter(타수 >= 400) %>%
  select(선수명, 팀, 경기, 타수)

# arrange
d1 %>%
  filter(타수 >= 400) %>%
  select(선수명, 팀, 경기, 타수) %>%
  arrange(desc(타수))

#mutate
#ctrl+shift+M : %>% 단축키
d1 %>%
  select(선수명, 팀, 경기, 타수) %>% 
  mutate(경기X타수 = 경기*타수) %>% 
  arrange(desc(경기X타수))

#안타율 컬럼생성 : 안타/타수 구해서 할푼리로 출력
d1 %>% 
  select(선수명, 팀, 경기, 안타, 타수) %>% 
  mutate(안타율 = round(안타/타수,3)) %>% 
  arrange(desc(안타율))
