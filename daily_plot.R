
# Load packages

require(chron)
require(zoo)
require(testthat)
# require(ggplot2) # doesn't support chron objects at present

 a <- read.csv(
   "Log.csv", 
   header = FALSE, 
   sep = ","
   )
     
 CurTime <- Sys.time()
 CurDate <- Sys.Date()
     
 a[,1:2] <- cbind(
   as.character(a[,1]), 
   as.character(a[,2])
   )
     
 colnames(a) <- c(
	"date",
	"time",
	"temp1",
	"temp2",
	"light1",
	"humidity",
	"PIR"
)
     
	# convert date and time to chron objects
   
a$date <- dates(
  as.character(a$date), 
  format = "y-m-d"
  )

a$time <- times(
  as.character(a$time), 
  format = "h:m:s"
  )

a$timestamp <- chron(
  a$date, 
  a$time
  )
     
	# Use just the current 24 hours!
     
a <- subset(
  a, 
  date == as.chron(CurDate)
  )

#Create subsets for plotting - actually this would be much better in dplyr,
#however the R version available on the Rpi does not support dplyr
	 
temp1 <- subset(a,temp1 > 0 & temp1 < 100,c(timestamp,temp1,PIR))
temp2 <- subset(a,temp2 > 0 & temp2 < 100,c(timestamp,temp2,PIR))
#coreTemp <- subset(a,coreTemp > 0 & coreTemp < 100,c(timestamp,coreTemp))
humidity <- subset(a,humidity > 0 & humidity < 100,c(timestamp,humidity,PIR))
light1 <- subset(a,light1 > 0 ,c(timestamp,light1,PIR)) # this has been changed!
light1$light <- log(light1$light1) * -1
     
temp1PIR <- subset(temp1,PIR > 0, c(timestamp,temp1))
light1PIR <- subset(light1,PIR > 0, c(timestamp,light))
humidityPIR <- subset(humidity,PIR > 0, c(timestamp,humidity))
     
# Set graph axes max and min
     
tempMax <- max(
	#max(coreTemp$coreTemp-25),
	#max(temp2$temp2),
	max(temp1$temp1)
) # * 1.025
				
tempMin <- min(
	#min(coreTemp$coreTemp-25),
	#min(temp1$temp1),
	min(temp1$temp1)
) # * 1.025
     
#tempMax<-max(temp1$temp1) #*1.025
#tempMin<-min(temp1$temp1) #*0.975
     
png(
  "/var/www/gfx/daily_temp_plot.png", 
  width = 6, 
  height = 4.5, 
  units = "in", 
  res = 200
  )	 
	 
par(
	mar = c( 5.1, 4.1, 3.1, 4.1),
	lend = "square"
)
     
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
     
#par(xpd = TRUE)
#mtext(expression(paste("Core temperature (",degree,"C)")), side = 4, line = 3)
#par(xpd = FALSE)
     

sapply(
	1:length(temp1PIR[,1]),
	function(x) {
		lines(
			c(temp1PIR[x,1],temp1PIR[x,1]),
			c(0,temp1PIR[x,2]),
			col = "gray50",
			lwd = 0.5
		) 
	}
)
    
points(
    temp1$timestamp,
    temp1$temp1,
    col = "blue",
    type = "l"
)

points(
  temp2$timestamp,
  temp2$temp2,
  col = "blue",
  type = "l",
  lty = 2
)
 
dev.off()

 png("/var/www/gfx/daily_humidity_plot.png",width=6,height=4.5,units="in",res=200)	
     
par(
	mar = c( 5.1, 4.1, 3.1, 4.1),
	lend = "square"
)
	 
plot(
	humidity$timestamp,
	humidity$humidity,
	xlab = "Date/Time",
	ylab = "Relative humidity (%)",
	pch = 16,
	col = "red",
	type = "n"
)
     
     

sapply(
	1:length(humidityPIR[,1]), 
	function(x) {
		lines(
			c(humidityPIR[x,1],humidityPIR[x,1]),
			c(0,humidityPIR[x,2]),
			col = "gray50",
			lwd = 0.5
		)
	}
)
     
 points(
	humidity$timestamp,
	humidity$humidity,
	col = "green",
	type = "l"
)
     
dev.off()
     
 png("/var/www/gfx/daily_light_plot.png",width=6,height=4.5,units="in",res=200)

par(
	mar = c( 5.1, 4.1, 3.1, 4.1),
	lend = "square"
)
 
plot(
	light1$timestamp,
	light1$light,
	xlab = "Date/Time",
	ylab = "Relative light values",
	pch = 16,
	col = "red",
	type = "n"
)
     
     


sapply(
	1:length(light1PIR[,1]), 
	function(x) {
		lines(
			c(light1PIR[x,1],light1PIR[x,1]),
			c(-20,light1PIR[x,2]),
			col = "gray50",
			lwd = 0.5
            )
	}
)

points(
	light1$timestamp,
	light1$light,
	col = "red",
	type = "l"
)
 

#axis(side=2,at=seq(0,100,1),label=seq(0,100,1)+25, cex.axis = 1,lwd = 0.5)
#axis(side=2,at=seq(0,-20,-2),labels=rev(seq(0,20,2)),las = 2, cex.axis = 0.75,lwd = 0.5)
     
     dev.off()
     

