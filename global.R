library(rvest)
library(stringr)

#Scrapping from the web site
scrapData <- read_html("http://www.internetlivestats.com/internet-users-by-country/")

#Taking the table with the expected values
scrapData <- scrapData %>%
             html_nodes("tr td") %>%
             html_text()

scrapData <- as.data.frame(scrapData)#Casting
#Replacement
scrapData <- as.data.frame(lapply(scrapData,function(x) if(is.character(x)|is.factor(x)) gsub(",",".",x) else x))
scrapData <- as.data.frame(lapply(scrapData,function(x) if(is.character(x)|is.factor(x)) gsub("%","",x) else x))

#Initializing the data frame
dynamic <- data.frame()

#Loop to create a data frame
for (j in 1 : nrow(scrapData)){
  
  if( str_detect(scrapData[j,], '[:alpha:]') == TRUE ) {#The cell contain strings
    static <- data.frame(
                             country = scrapData[j,],
                             int_users = scrapData[j+1,], 
                             penetration = scrapData[j+2,],
                             population = scrapData[j+7,],
                             non_users = scrapData[j+4,], 
                             users_1year_change = scrapData[j+5,],
                             internet_users_1year_change = scrapData[j+6,],
                             population_1year_change = scrapData[j+7,]
                         )
    dynamic <- rbind(dynamic, static)
    
  }#if-condition
}#Extraction columns scrapped

View(dynamic)
