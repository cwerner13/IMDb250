library(googleVis)
library(shiny)

# setwd("~/bianalyst/20140407 Data Science Track/009 Data Products/IMDb250_shiny")
data <- read.csv("./data/Top250 (unique).csv", sep="," , header=TRUE, skip=0, stringsAsFactors=FALSE)

### Rename Columns
nn<-names(data)
nn[1:16] <- c("Pos", "const","created", "modified", "description"
              ,"Title","Title.type","Directors","YouRated","IMDbRating"
              ,"Runtime","Year","Genres","NumVotes", "ReleaseDate", "URL")
names(data) <- nn

### Clean-up Data: ReleaseDate
correct <- nchar(data$ReleaseDate) == 10

data[correct,]$ReleaseDate  <-        substr(data[correct,]$ReleaseDate,1,10)
data[!correct,]$ReleaseDate <-  paste(substr(data[!correct,]$ReledaseDate,1,7), "01", sep="-")

Flag_19940512 <-   substr(data$ReleaseDate,1,3)=="-01"
data[Flag_19940512,]$ReleaseDate  <-             "1994-05-12"

data$ReleaseDate <- as.Date(data$ReleaseDate, "%Y-%m-%d")

data$ReleaseDate <-paste(substr(data$ReleaseDate,1,4), substr(data$ReleaseDate,6,7), substr(data$ReleaseDate,9,10), sep ="/")
data$ReleaseDate <- as.Date(data$ReleaseDate, "%Y/%m/%d")

drop_columns <- c( "const", "created", "modified", "description", "Genres", "URL")
data= data[,!(names(data) %in% drop_columns)]

### Clean-up Data: Directors
Charles_Chaplin <- data$Directors ==              "Charles Chaplin"
data[Charles_Chaplin,]$Directors  <-              "Charlie Chaplin"
FFCoppola       <- data$Directors ==              "Francis Coppola"
data[FFCoppola,]$Directors        <-              "Francis Ford Coppola"
Danny_Boyle     <- substr(data$Directors,1,11) == "Danny Boyle"
data[Danny_Boyle,]$Directors      <-              "Danny Boyle"
Danny_Boyle     <- substr(data$Directors,1,22) == "The Wachowski Brothers"
data[Danny_Boyle,]$Directors      <-              "The Wachowski Brothers"



### add Number of Movies per Director in Top 250
freq  <- as.data.frame(table(data$Directors)) 
data  <- data.frame <- merge(data, freq, by.x = "Directors", by.y = "Var1")
Total <- data$Freq * data$IMDbRating
data <- cbind(data,Total)

### add Running of Number Movies in Top 250
x<- data.frame(prop.table(table(data$Year, data$Directors)))
x1<-x[x$Freq!=0,]    #Drop unproductive years
perc<- as.data.frame(within(x1, { Percentage <- ave(Freq, Var2, FUN = cumsum)}))

perc$Var1<-as.numeric(levels(perc$Var1)[as.integer(perc$Var1)])  #Year
perc$Var2<-as.character(levels(perc$Var2)[as.integer(perc$Var2)]) #Director

result            <- merge(data, perc, by.x=c("Year","Directors"), by.=c("Var1", "Var2"))
result$Percentage <- result$Percentage*100
