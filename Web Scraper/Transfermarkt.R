

# library(tidyverse)
library(dplyr)
library(rvest)

URL <- "http://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1"


WS <- read_html(URL)

# Getting Club Links

ClubURLs <- WS %>% html_nodes("#yw1 .no-border-links a")%>% html_attr("href") %>% as.character()

print(ClubURLs)

ClubURLs <- paste0("http://www.transfermarkt.com",ClubURLs)

IDRemove <- c(2,3,5,6,7,9,11,13,15,16,18,20,22,24,26,28,30,32,34,36,38,40,42)

ClubURLs <- ClubURLs[-IDRemove]


Catcher1 <- data.frame(Player = character(), P_URL = character())


### For each Club Page: Getting Player links, names, & positions

for (i in ClubURLs) {
  WS1 <- read_html(i)
  Player <- WS1 %>% html_nodes(".nowrap a") %>% html_text() %>% as.character()
  P_URL <- WS1 %>% html_nodes(".nowrap a") %>% html_attr("href") %>% as.character()
  temp <- data.frame(Player, P_URL)
  Catcher1<- rbind(Catcher1, temp)
  cat("*")
}

nrow(Catcher1)

odd_indexes <- seq(1, nrow(Catcher1), 2)

Catcher1 <- data.frame(Catcher1[odd_indexes,1:2])

nrow(Catcher1)

Catcher1$P_URL <- paste0("http://www.transfermarkt.com",Catcher1$P_URL)

# Adding positions

PosCatcher <- data.frame(Position = character())

for (i in ClubURLs) {
  WS1 <- read_html(i)
  Position <- WS1 %>% html_nodes(".inline-table tr+ tr td") %>% html_text() %>% as.character()
  tempPos <- data.frame(Position)
  PosCatcher <- rbind(PosCatcher, tempPos)
  cat("*")
}

fullPlayerDF <- cbind(Catcher1, PosCatcher$Position)

#####################

Catcher2 <-data.frame(Player=character(),MarketValue=character(), Appearances = character(), MinutesPlayed = character(), Goals = character(), Assists = character(), Age = character(), Height = character(), Foot = character(), Country = character())

#Removing Arthur Okonkwo

# Catcher1Updated <- fullPlayerDF[!(fullPlayerDF$P_URL == "http://www.transfermarkt.com/arthur-okonkwo/profil/spieler/503769"),]

#Removing Goalkeepers
# Catcher1Updated <- fullPlayerDF[!(fullPlayerDF$`PosCatcher$Position` == "Goalkeeper"),]

for (i in fullPlayerDF$P_URL){
  WS2 <- read_html(i)
  
  Player <- WS2 %>% html_nodes("h1") %>% html_text() %>% as.character()
  Image <- WS2 %>% html_nodes("#fotoauswahlOeffnen img") %>% html_
  MarketValue <- WS2 %>% html_nodes(".dataMarktwert a") %>% html_text() %>% as.character()
  Appearances <-WS2 %>% html_nodes(".hide.hide-for-small+ .zentriert") %>% html_text() %>% as.character()
  MinutesPlayed <- WS2 %>% html_nodes("tfoot .zentriert:nth-child(6)") %>% html_text() %>% as.character()
  Goals <-WS2 %>% html_nodes("tfoot .zentriert:nth-child(4)") %>% html_text() %>% as.character()
  Assists <-WS2 %>% html_nodes("tfoot .zentriert:nth-child(5)") %>% html_text() %>% as.character()
  Age <-WS2 %>% html_nodes(".info-table__content--bold:nth-child(8)") %>% html_text() %>% as.character()
  Height <- WS2 %>% html_nodes(".info-table__content--bold:nth-child(10)") %>% html_text() %>% as.character()
  Foot <- WS2 %>% html_nodes(".info-table__content--bold:nth-child(16)") %>% html_text() %>% as.character()
  Country <- WS2 %>% html_nodes(".info-table__content--bold:nth-child(12)") %>% html_text() %>% as.character()
  
  if (length(MarketValue) > 0) {
    temp2 <- data.frame(Player,MarketValue, Appearances, MinutesPlayed, Goals, Assists, Age, Height, Foot, Country)
    Catcher2 <- rbind(Catcher2,temp2)} else {}

 cat("*")
}

install.packages("writexl")
library()

write_xlsx(Catcher2, 'C:/Users/moham/OneDrive/Desktop/Senior Thesis/Discrimination in football/Data/mydata.xlsx')


