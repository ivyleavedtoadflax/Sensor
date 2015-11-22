
##################### Temperature Log File first

# Check that file log file exists in folder!


     
     a <- read.csv(
     "Log.csv", 
     header = FALSE, 
     sep = ","
     )
     
     CurTime <- Sys.time()
     CurDate <- Sys.Date()
     
     # format log file
     
     colnames(a) <- c(
          "timestamp",
          "int_temp1",
          "ext_temp1",
          "int_temp2",
          "light",
          "humidity"
     )
     
     # convert date and time to chron objects
     
     a$timestamp <- as.POSIXct(strptime(a$timestamp, "%Y-%m-%d %H:%M:%S"))
     
     # check for eroneous values in the data
     
     int_temp1 <- subset(a,int_temp1 > 0 & int_temp1 < 100,c(timestamp,int_temp1))
     int_temp2 <- subset(a,int_temp2 > 0 & int_temp2 < 100,c(timestamp,int_temp2))
     ext_temp1 <- subset(a,ext_temp1 > 0 & ext_temp1 < 100,c(timestamp,ext_temp1))
     humidity <- subset(a,humidity > 0 & humidity < 100,c(timestamp,humidity))
     light <- subset(a,light > 0 ,c(timestamp,light)) # this has been changed!
     light$light <- log(light$light) * -1
     
     # Set graph axes max and min
     
     tempMax<-max(
				max(int_temp1$int_temp1),
				max(int_temp2$int_temp2),
				max(ext_temp1$ext_temp1)
				)  * 1.025
				
       tempMin <- min(
				min(int_temp1$int_temp1),
				min(int_temp2$int_temp2),
				min(ext_temp1$ext_temp1)
				)  * 0.975
     pdf("/home/pi/Sensor/Log.pdf",width=6,height=12)
     par(mfrow=c(3,1))
				
     par(
     mar = c( 5.1, 4.1, 3.1, 4.1),
     lend = "square"
)
     
     plot(
          int_temp1$timestamp,
          int_temp1$int_temp1,
          xlab = "Date/Time",
          ylab = expression(Temperature~(degree~C)),
          pch = 16,
          col = "blue",
          type = "n",
          ylim = c(tempMin,tempMax),
          main = CurTime
     )
     
     points(
          int_temp1$timestamp,
          int_temp1$int_temp1,
          col = "blue",
          type = "l"
     )

     points(
          int_temp2$timestamp,
          int_temp2$int_temp2,
          col = "red",
          type = "l"
     )

     points(
          ext_temp1$timestamp,
          ext_temp1$ext_temp1,
          col = "green",
          type = "l"
     )
     
legend(
"topleft",
c("Internal 1","Internal 2","External 1"),
fill = c("blue","red","green"),
bty = "n"
)

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
     
     points(
          humidity$timestamp,
          humidity$humidity,
          col = "purple",
          type = "l"
     )
     
     
     plot(
          light$timestamp,
          light$light,
          xlab = "Date/Time",
          ylab = "Relative light values",
          pch = 16,
          col = "red",
          type = "n",
          main = CurTime
     )
     
     points(
          light$timestamp,
          light$light,
          col = "red",
          type = "l"
     )
 
     dev.off()
