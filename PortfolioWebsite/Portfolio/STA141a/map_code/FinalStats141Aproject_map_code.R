#STATS141Aproject

#loading functions
library(dplyr)
library(plyr)
library(labeling)
library(ggrepel)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

#reading in datas as a csv file
mydata = read.csv("/Users/rurikoimai/Downloads/FinalConstData.csv")
rawdata = read.csv("/Users/rurikoimai/Downloads/FinalConstData.csv")
regions_mydata = read.csv("/Users/rurikoimai/Downloads/college_regions.csv")

#looking at the names of columns in data
names(mydata)
attach(mydata)
names(rawdata)
attach(rawdata)

#constructing a data frame of the data
mydata = data.frame(schoolname, collegeID, spend_student)
rawdata = data.frame(schoolname,collegeID,alt,reconstruct,repair,relocate,edu_building,career_tech,community1,community2,gen_facilities,admin)
#filter by unique collegeID
#remove row containing NA value
mydata = mydata %>% distinct(collegeID, .keep_all = TRUE)
mydata$Type_of_Projects = sums_proj

#out of the merged data take name of schools
College = merged_data$schoolname


#add ,CA,USA to all names 
College = paste(College, ",CA,USA", sep=" ")

#geocode, find locations
College_loc = lapply(College, geocode, output="more")

#saving school locations#
str(College_loc)
cachefile = tempfile()
saveRDS(College_loc, file = cachefile)
College_loc = readRDS(cachefile)
#saved geocode of schools
College_loc
#
LON = sapply(College_loc, function(loc) {loc[[1]]})
LAT = sapply(College_loc, function(loc) {loc[[2]]})
#
mydata$longitude = LON
mydata$latitude = LAT

mydata = mydata[complete.cases(mydata),]
#################
#map it
states = map_data("state")
ca_df = subset(states, region == "california")
counties = map_data("county")
ca_county = subset(counties, region == "california")

#############
#trying to get county names

#loading functions
library(sp)
library(maps)
library(maptools)

latlong2counties = function(pointsDF) {
	#Prepare SpatialPolygons object with one SpatialPolygon
	counties1 = map('county', "california", fill=TRUE, col="transparent")
	IDs = sapply(strsplit(counties1$names, ":"), function(x) x[1])
	counties1_sp = map2SpatialPolygons(counties1, IDs=IDs, proj4string=CRS("+proj=longlat +datum=WGS84"))
	#Convert pointsDF to a SpatialPoints object
	pointsSP = SpatialPoints(pointsDF, proj4string=CRS("+proj=longlat +datum=WGS84"))
	#Use 'over' to get _indices_ of the Polygons object containing each point
	indices = over(pointsSP, counties1_sp)
	#Return the state names of the Polygons object containing each point
	countyNames = sapply(counties1_sp@polygons, function(x) x@ID)
	countyNames[indices]
}

#making a data frame of the coordinates
testPoints = data.frame(x=c(mydata$longitude), y=c(mydata$latitude))

#storing county names in counties2
counties2 = latlong2counties(testPoints)

#adding Counties to the merged_data frame
mydata$Counties = counties2


##################
#############
##find most popular project type in each county
#getting all county names in California
subregions = ca_county$subregion
subregions = unique(subregions)
#finding how many schools there are in each counties 
working = sapply(subregions, grep, mydata$Counties, ignore.case=TRUE)
working

cnames = aggregate(cbind(long,lat) ~ subregion, data=ca_county, FUN=function(x)mean(range(x)))
cnames$Projects = Projects
###############

#the sums of spendings in each counties
Projects = c("alt/gen_facilities",NA,NA,"alt",NA,NA,"gen_facilities",NA,"alt/community2","edu_building/gen_facilities/admin", NA,"edu_building","edu_building","gen_facilities","alt/community2/gen_facilities", NA,NA, "gen_facilities", "gen_facilities", NA, "alt", NA,"edu_building","alt",NA,NA,"alt","gen_facilities",NA,"gen_facilities","gen_facilities","community2","gen_facilities","edu_building",NA,"gen_facilities","gen_facilities","alt","gen_facilities","gen_facilities","gen_facilities","gen_facilities","gen_facilities","gen_facilities/alt","gen_facilities/edu_building","edu_building",NA,"edu_building","gen_facilities","gen_facilities","gen_facilities",NA,NA,NA,"gen_facilities","edu_building","gen_facilities","alt/edu_building/gen_facilities")

#adding the spend_student from the merged data frame using the indicies of the counties that were found previously, the NA values indicate that there are no spendings.
#alt/gen_facilities
alameda = c(mydata$Type_of_Projects[31], mydata$Type_of_Projects[32], mydata$Type_of_Projects[33], mydata$Type_of_Projects[42], mydata$Type_of_Projects[48], mydata$Type_of_Projects[49])
alpine = NA
amador = NA
#alt
butte = mydata$Type_of_Projects[10]
calaveras = NA
colusa = NA
#gen_facilities
contra_costa = c(mydata$Type_of_Projects[26], mydata$Type_of_Projects[27], mydata$Type_of_Projects[28])
del_norte = NA
#alt/community2
el_dorado = mydata$Type_of_Projects[17]
#edu_building/gen_facilities/admin
fresno =  c(mydata$Type_of_Projects[58], mydata$Type_of_Projects[59], mydata$Type_of_Projects[60])
glenn = NA
#edu_building
humboldt = mydata$Type_of_Projects[14]
#edu_building
imperial = mydata$Type_of_Projects[3]
#gen_facilities
inyo = mydata$Type_of_Projects[53]
#alt/community2/gen_facilities 
kern = c(mydata$Type_of_Projects[52], mydata$Type_of_Projects[71])
kings = NA
lake = NA
#gen_facilities
lassen = mydata$Type_of_Projects[12]
#gen_facilities
los_angeles = c(mydata$Type_of_Projects[64], mydata$Type_of_Projects[67], mydata$Type_of_Projects[72], mydata$Type_of_Projects[73], mydata$Type_of_Projects[74], mydata$Type_of_Projects[75], mydata$Type_of_Projects[76],
mydata$Type_of_Projects[77], mydata$Type_of_Projects[78], mydata$Type_of_Projects[79], mydata$Type_of_Projects[80], mydata$Type_of_Projects[81], mydata$Type_of_Projects[82], mydata$Type_of_Projects[83], mydata$Type_of_Projects[85], mydata$Type_of_Projects[89], mydata$Type_of_Projects[90], mydata$Type_of_Projects[97])

madera = NA
#alt
marin = mydata$Type_of_Projects[29]
mariposa = NA
#edu_building
mendocino = mydata$Type_of_Projects[13]
#alt
merced = mydata$Type_of_Projects[55]
modoc = NA
mono = NA
#alt
monterey = c(mydata$Type_of_Projects[44], mydata$Type_of_Projects[45])
#gen_facilities 
napa = mydata$Type_of_Projects[21]
nevada = NA
#gen_facilities
orange = c(mydata$Type_of_Projects[7], mydata$Type_of_Projects[86], mydata$Type_of_Projects[87], mydata$Type_of_Projects[88], mydata$Type_of_Projects[91], mydata$Type_of_Projects[92], mydata$Type_of_Projects[93], mydata$Type_of_Projects[94], mydata$Type_of_Projects[95], mydata$Type_of_Projects[96], mydata$Type_of_Projects[98], mydata$Type_of_Projects[99])
#gen_facilities
placer = mydata$Type_of_Projects[23]
#community2
plumas = mydata$Type_of_Projects[11]
#gen_facilities
riverside = c(mydata$Type_of_Projects[102], mydata$Type_of_Projects[103], mydata$Type_of_Projects[104], mydata$Type_of_Projects[105])
#edu_building
sacramento = c(mydata$Type_of_Projects[18], mydata$Type_of_Projects[19], mydata$Type_of_Projects[20])
san_benito = NA
#gen_facilities
san_bernardino = c(mydata$Type_of_Projects[100], mydata$Type_of_Projects[101], mydata$Type_of_Projects[106], mydata$Type_of_Projects[107], mydata$Type_of_Projects[108], mydata$Type_of_Projects[109])
#gen_facilities
san_diego = c(mydata$Type_of_Projects[1], mydata$Type_of_Projects[2], mydata$Type_of_Projects[4], mydata$Type_of_Projects[5], mydata$Type_of_Projects[8], mydata$Type_of_Projects[9])
#alt
san_francisco = mydata$Type_of_Projects[34] 
#gen_facilities
san_joaquin = mydata$Type_of_Projects[56]
#gen_facilities
san_luis_obipso = mydata$Type_of_Projects[65]
#gen_facilities
san_mateo = c(mydata$Type_of_Projects[35], mydata$Type_of_Projects[36])
#gen_facilities
santa_barbara = mydata$Type_of_Projects[63] 
#gen_facilities
santa_clara = c(mydata$Type_of_Projects[40], mydata$Type_of_Projects[41], mydata$Type_of_Projects[43], mydata$Type_of_Projects[46], mydata$Type_of_Projects[47], mydata$Type_of_Projects[50], mydata$Type_of_Projects[51])
#gen_facilities/alt
santa_cruz = c(mydata$Type_of_Projects[38], mydata$Type_of_Projects[39])
#"gen_facilities/edu_building"
shasta = mydata$Type_of_Projects[15]
sierra = NA
#edu_building
siskiyou = mydata$Type_of_Projects[16]
#gen_facilities
solano = mydata$Type_of_Projects[24]
#gen_facilities
sonoma = mydata$Type_of_Projects[22]
stanislaus = mydata$Type_of_Projects[62]
sutter = NA
tehama = NA
trinity = NA
#gen_facilities
tulare = c(mydata$Type_of_Projects[57], mydata$Type_of_Projects[54])
#edu_building
tuolumne = mydata$Type_of_Projects[61]
#gen_facilities
ventura = c(mydata$Type_of_Projects[68], mydata$Type_of_Projects[69])
yolo = NA
#alt/edu_building/gen_facilities
yuba = mydata$Type_of_Projects[25]

#################
#map it
states = map_data("state")
ca_df = subset(states, region == "california")
counties = map_data("county")
ca_county = subset(counties, region == "california")

#############

#mapping california with borders
ca_base = 
	ggplot() + 
	geom_path(data=ca_df, mapping=aes(x=long, y=lat, group=group), color="black") +
	coord_fixed(1.3) +
	geom_polygon(data=ca_df, mapping=aes(x=long, y=lat, group=group), fill="gray") +
	geom_polygon(data=ca_county, mapping=aes(x=long, y=lat, group=group), fill=NA, color="white") +
	#get the border back on top
	geom_polygon(color="black", fill=NA)
	
ca_base 

#categorizing student spendings (spend_student) to
#stu_spend = cut_interval(merged_data$spend_student, n = 25)

##########
mymap = ca_base +
		#adding locations of schools on ca_base map
		geom_point(data=mydata, mapping=aes(x=longitude, y=latitude, color=collegeID),hjust=0.25) +
		coord_fixed(1)
				
mymap = mymap + 
	       #names of counties on the map
	       geom_text(data=cnames, aes(long,lat,label=subregion),fontface=2,color="black", size=2,hjust=0.5) 
	      
mymap = mymap +
		#labeling counties with the total spendings per student
	       geom_label_repel(data=cnames, aes(long, lat, label=Projects), size=3, segment.color="red", na.rm=TRUE, label.size=0.1, force=15, label.padding=unit(0.1, "lines"), segment.alpha= 0.25) 
	
mymap = mymap + 	
	#labeling title
	ggtitle("Community College Spendings by Types by Regions") + 
	#centering title
	theme(plot.title = element_text(hjust=0.5)) + 
	#boxing the legend
	theme(legend.background = element_rect(color="black")) +
	#making a legend for the total spending of each couties
	geom_label(aes(-122.5,31,label="The Most popular types of\n Projects per Counties"))

mymap












###################Looking for indices of unique colleges#################
regex.pattern = c("^21$", "^22$","^31$","^51$","^61$","^70$","^71$","^72$","^73$","^91$","^111$","^121$","^131$","^141$","^161$","^171$","^181$","^221$","^230$","^231$","^232$","^233$","^234$","^241$","^261$","^271$","^281$","^291$","^292$","^311$","^312$","^313$","^334$","^340$","^341$","^343$","^344$","^345$","^361$","^371$","^372$","^373$","^411$","^421$","^422$","^431$","^441$","^451$","^461$","^471$","^472$","^481$","^482$","^492$","^493$","^521$","^522$","^523$","^531$","^551$","^561$","^570$","^571$","^572$","^576$","^580$","^581$","^582$","^590$","^591$","^592$","^611$","^621$","^641$","^651$","^660$","^661$","^681$","^682$","^683$","^691$","^711$","^721$","^731$","^740$","^741$","^742$","^743$","^744$","^745$","^746$","^747$","^748$","^749$","^771$","^781$","^811$","^821$","^831$","^832$","^833$","^841$","^851$","^861$","^862$","^863$","^870$","^871$","^872$","^873$","^881$","^891$","^892$","^911$","^921$","^931$","^941$","^951$","^961$","^962$","^963$","^971$","^981$","^982$","^991$")

sapply(regex.pattern, grep, rawdata$collegeID)

#looking for total for each type of construction
sum(college1$alt)
sum(college1$reconstruct)
sum(college1$repair)
sum(college1$relocate)
sum(college1$edu_building)
sum(college1$career_tech)
sum(college1$community1)
sum(college1$community2)
sum(college1$gen_facilities)
sum(college1$admin)


