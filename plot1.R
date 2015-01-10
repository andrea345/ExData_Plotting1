
## calculate memory requirements
# 2075259 rows x 9 columns x 8 bytes / numeric
# =149,418,648 bytes
# =142.5 MB (1048576 bytes per MB)
# =.14 GB (1024 MB per GB)

#  Get data
##  set up working directory for data download and results
## download data and unzip file

        graphics.off()
        
        if(!file.exists("./power")){dir.create("./power")}
        setwd("./power")

        dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        
        ## download the file and rename if it does not exist
        if(!file.exists("Dataset.zip")){
                download.file(dataset_url, destfile="Dataset.zip")}
        
        if(!file.exists("household_power_consumption.txt")){
                unzip("Dataset.zip", overwrite= TRUE)}
        
        
##  check the file out, read first 5 rows
       tabAll<-read.table("household_power_consumption.txt", sep=";",header = TRUE, as.is = TRUE, nrows = 5)
        classes<-sapply(tabAll,class)
#create the character vector of the string which is to be interpreted as NA
        x<-c("?")
        tabAll<-read.table("household_power_consumption.txt", sep=";",header = TRUE, 
                           na.strings = x, colClasses = classes)
        
#pull the two dates of interest out of the dataset for processing
        tabSome<-tabAll[which(tabAll$Date %in% c("1/2/2007", "2/2/2007")),]
        
        library(lubridate)
##  create various date & time related fields for plotting
        #lubridate wday has the wrong format for the label
       # tabSome$DOW<-wday(as.Date(tabSome$Date, "%d/%m/%Y"),abbr = TRUE, label = TRUE)
        tabSome$DOW<-as.factor(weekdays(as.Date(tabSome$Date, "%d/%m/%Y"), abbr = TRUE))
        tabSome$DStamp<-dmy(tabSome$Date)
        tabSome$datetime<-as.POSIXct(paste(tabSome$Date,tabSome$Time), 
                                     format = "%d/%m/%Y %H:%M:%S")
         
##  creates a timestamp field with just the hour and the minute        
        tabSome$TStamp<-format(strptime(tabSome$Time, "%H:%M:%S"),"%R")
        
## create a concatenated datetime field/e)
       
        
## reorganize fields for easier viewing
        tabSome<-tabSome[,c(10:13,1:9)]

        
        
        
##  clear memory
        rm(tabAll)
        rm(classes)     
        rm(x)
        rm(dataset_url)
### End Table Load and Tidy
        
#######  Begin Creating Plots  
        
        if(file.exists("plot1.png")){file.remove("plot1.png")}
        
## make plot1 table
        hist(tabSome$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)",
                 main = "Global Active Power", ylim = c(0,1200))
        dev.copy(png, file = "plot1.png", width = 480, height = 480)       
## turn off the last graphic device
        dev.off()
## turn off all graphic devices        
       #graphics.off()
        
## return working directory to previous location        
        setwd("../")

