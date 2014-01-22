#sink("RLog.txt")

# Load packages

require(chron)
require(zoo)
# require(ggplot2) # doesn't support chron objects at present


##################### Temperature Log File first

# Check that file log file exists in folder!


outputFiles<-list.files(getwd(), pattern="*.csv")
#as.matrix(outputFiles)


if (sum(
     which(
          (outputFiles == "Log.csv")
     ) == "0" ) )
{
     
     # Return error if log file does not exist!
     
     warning("Error: Log file missing. Check remote directory.")
     
} else {
     
     # check current time and convert to chron object (note format to avoid filename errors)
     #fName<-as.chron(Sys.time(),out.format=c(date = "y-m-d", time="h-m-s")) 
     # Use time specific filename
     #pdf(paste("/home/pi/therm/plots/tempLog ",fName,".pdf"),width=7,height=4.5)
     # use general name
     
     
     
     pdf("plots/Log.pdf",width=14,height=4.5)
     #png("plots/Log.png",width=7,height=4.5,units="in",res=200)
     
     #par(mfrow=c(1,2))
     
     a<-read.csv("Log.csv",header=FALSE,sep=",")
     
     CurTime <- Sys.time()
     CurDate <- Sys.Date()
     
     print(CurTime)
     
     
     # format log file
     
     a[,1:2] <- cbind(as.character(a[,1]),as.character(a[,2]))
     
     colnames(a) <- c(
          "date",
          "time",
          "temp1",
          "light1",
     #     "coreTemp",
     #     "temp2",
          "humidity",
          "PIR"
     )
     
     # convert date and time to chron objects
     
     #Include to limit to a particular time period
     
     #a <- subset(a,a$date > as.Date("20/12/13",format="%d/%m/%y"))     
     
     a$date <- dates(as.character(a$date),format = "y-m-d")
     a$time <- times(as.character(a$time),format = "h:m:s")
     
     
      #create unified timestamp (not necessary)
     
     a$timestamp <- chron(a$date,a$time)
     
     # Use just the current 24 hours!
     

	#a <- subset(a,date == as.chron(CurDate))
	 
     #if (sampleDate == "today") a<-subset(a,date==as.chron(CurDate))
	 #else if (sampleDates == "")  
	 #else a<-subset(a,date==as.chron(dates(sampleDate,format="d/m/y"))
	 
	    
     # check for eroneous values in the data
     
     temp1 <- subset(a,temp1 > 0 & temp1 < 100,c(timestamp,temp1,PIR))
     #temp2 <- subset(a,temp2 > 0 & temp2 < 100,c(timestamp,temp2,PIR))
     #coreTemp <- subset(a,coreTemp > 0 & coreTemp < 100,c(timestamp,coreTemp))
     humidity <- subset(a,humidity > 0 & humidity < 100,c(timestamp,humidity,PIR))
     light1 <- subset(a,light1 > 0 ,c(timestamp,light1,PIR)) # this has been changed!
     light1$light <- log(light1$light1) * -1
     
     temp1PIR <- subset(temp1,PIR > 0,c(timestamp,temp1))
     light1PIR <- subset(light1,PIR > 0,c(timestamp,light))
     humidityPIR <- subset(humidity,PIR > 0,c(timestamp,humidity))
     
     # Set graph axes max and min
     
     tempMax<-max(
	#			max(coreTemp$coreTemp-25),
	#			max(temp2$temp2),
				max(temp1$temp1)
				) # * 1.025
				
     tempMin<-min(
	#			min(coreTemp$coreTemp-25),
	#			min(temp1$temp1),
				min(temp1$temp1)
				) # * 1.025
     
     #tempMax<-max(temp1$temp1) #*1.025
     #tempMin<-min(temp1$temp1) #*0.975
     
     par(mar = c( 5.1, 4.1, 3.1, 4.1))
     par(lend = "square")
     par(yaxt = "n")
     
     plotTemp <- plot(
          temp1$timestamp,
          temp1$temp1,
          xlab = "Date/Time",
          ylab = expression(paste("Ambient temperature (",degree,"C)")),
          pch = 16,
          col = "blue",
          type = "n",
          ylim = c(tempMin,tempMax),
          main = CurTime
     )
     
     par(xpd = TRUE)
     mtext(expression(paste("Core temperature (",degree,"C)")), side = 4, line = 3)
     par(xpd = FALSE)
     
     
     print("Plot PIR temp")
     print(system.time(
          sapply (1:length(temp1PIR[,1]),function(x) {
               lines(
                    c(temp1PIR[x,1],temp1PIR[x,1]),
                    c(0,temp1PIR[x,2]),
                    col = "gray50",
                    lwd = 0.5
               ) 
          }
          )
     )
     )
     
     
     
     points(
          temp1$timestamp,
          temp1$temp1,
          col = "blue",
          type = "l"
     )
     
	 # lot points from second temperature sensor
	 
     #points(
     #     temp2$timestamp,
     #     temp2$temp2,
     #     col = "purple",
     #     type = "l"
     #)
     
     
     
     
     print("points temp")
     
	 # Plot points from core temperature sensor
	 
     #if (length(coreTemp$coreTemp)<21) {
     #     points(  
     #          coreTemp$timestamp,
     #          coreTemp$coreTemp-25,
     #          col = "red",
     #          type = "l"
     #     )
     #} else {
     #     points(
     #          rollmean(coreTemp$timestamp,7),
     #          rollmean(coreTemp$coreTemp-25,7),
     #          col = "red",
     #          type = "l"
     #     )
     #}
     
     
     par(yaxt = "s")
     #axis(side=2,at=seq(0,100,1),label=seq(0,100,1)+25, cex.axis = 1,lwd = 0.5)
    # axis(
	#	side = 4,
	#	at = seq(-10,100,1),
	#	label = seq(-10,100,1) + 25,
	#	cex.axis = 1,
	#	lwd = 0.5
	#)
     
	 
	# legend(
	#	min(plotTemp$x),
	#	tempMax,
	#	c("DS18B20","AM2302","Core"),
	#	fill = c("blue","purple","red"),
	#	bty = "n"
	#	)
     ##############
     
     
     par(yaxt = "n")
     
     
     plot(
          humidity$timestamp,
          humidity$humidity,
          xlab = "Date/Time",
          ylab = "Relative humidity (%)",
          pch = 16,
          col = "red",
          type = "n",
          main = CurTime
     )
     
     
     print("Plot PIR humidity")
     print(system.time(
          sapply (1:length(humidityPIR[,1]),function(x) {
               lines(
                    c(humidityPIR[x,1],humidityPIR[x,1]),
                    c(0,humidityPIR[x,2]),
                    col = "gray50",
                    lwd = 0.5
               )
               
          }
          )
     )
     )
     
     
     points(
          humidity$timestamp,
          humidity$humidity,
          col = "green",
          type = "l"
     )
     
     
     ##############################
     
     par(yaxt = "n")
     
     
     plot(
          light1$timestamp,
          light1$light,
          xlab = "Date/Time",
          ylab = "Relative light values",
          pch = 16,
          col = "red",
          type = "n",
          main = CurTime
     )
     
     
     print("Plot PIR light")
     print(system.time(
          sapply (1:length(light1PIR[,1]),function(x) {
               lines(
                    c(light1PIR[x,1],light1PIR[x,1]),
                    c(-20,light1PIR[x,2]),
                    col = "gray50",
                    lwd = 0.5
               )
               
          }
          )
     )
     )
     
     
     points(
          light1$timestamp,
          light1$light,
          col = "red",
          type = "l"
     )
 
     
     
     par(yaxt = "s")
     #axis(side=2,at=seq(0,100,1),label=seq(0,100,1)+25, cex.axis = 1,lwd = 0.5)
     #axis(side=2,at=seq(0,-20,-2),labels=rev(seq(0,20,2)),las = 2, cex.axis = 0.75,lwd = 0.5)
     
     dev.off()
     
}
