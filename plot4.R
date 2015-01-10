
## calculate memory requirements
# 2075259 rows x 9 columns x 8 bytes / numeric
# =149,418,648 bytes
# =142.5 MB (1048576 bytes per MB)
# =.14 GB (1024 MB per GB)

#  Get data
##  set up working directory for data download and results
## download data and unzip file


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
 
        if(file.exists("plot4.png")){file.remove("plot4.png")}
        
        
## make plot4 file - this is a 4 quadrant plot
        par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

        
        with(tabSome,  {    
        ## Quad 1 plot    
            plot(datetime, Global_active_power, 
                           ylab = "Global Active Power",
                           xlab = " ",
                           cex.axis = 0.8,
                           type = "l")   
        ## Quad 2 plot
            plot(datetime, Voltage, 
                     ylab = "Voltage",
                     xlab = "datetime",
                     cex.axis = 0.8,
                     type = "l")        
        
## Quad 3 plot
        
        with(tabSome, plot(datetime, tabSome$Sub_metering_1, 
             ylab = "Energy sub metering", xlab = " ", 
             cex.axis = 0.8,
             type = "l", col = "black"))
        points(tabSome$datetime, tabSome$Sub_metering_2, type = "l",col = "red")
        points(tabSome$datetime, tabSome$Sub_metering_3, type = "l", col = "blue")
       
        
        legend("topright",
               pt.cex = 1,
               cex = .6,
               y.intersp = 0.5,
               col = c("black", "red", "blue"), 
               lty = c(1,1,1),               
               bty = "n",
               text.width = strwidth("Sub_metering_1"),
               #line = 2.3,
               legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
     
       

### Quad 4 plot        
        
        plot(datetime, Global_reactive_power, 
             ylab = "Global_reactive_power",
             xlab = "datetime",
             ylim = c(0.0, 0.5),
             cex.axis = 0.8,
             type = "l")        
        
        })
        
        

        
        dev.copy(png, file = "plot4.png", width = 480, height = 480)       
        #dev.off()
## turn off all graphic devices        
       graphics.off()
        
## return working directory to previous location        
        setwd("../")

