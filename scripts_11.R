#to read csv file
#inside the parenthesis, write the location of the csv file including the filename

all.vu.grads.run <- read.csv("all vu grads run.csv")

#to view the file
View(all.vu.grads.run)

#to convert to date format
variable_Dates  <- list('VUGrads$Acad.Commencement.Date', 'VUGrads$Acad.Degree.Date', 
                        'VUGrads$Acad.End.Date', 'VUGrads$X.Acad.Degree.Date.Fmt',
                        'VUGrads$X.Acad.End.Date.Fmt', 'VUGrads$X.Acad.Start.Date')

variable_Dates

#for loop to covert all variable dates in to date format
for (datename in variable_Dates){
  VUGrads[[datename]] <- as.Date(VUGrads[datename], format= "%m/%d/%y")}


#to check if columns were transformed into Date format
#return TRUE for columns with Date format
sapply(all.vu.grads.run, function(x) !all(is.na(as.Date(as.character(x),format="%d/%m/%Y"))))


#taking grad students only
newdata <- `CENFA10.(scrubbed)_modified`[which(`CENFA10.(scrubbed)_modified`$Acad.Level1 =='G'), ]


#making the ordered list to make one dataframe of all csv files
filelist <- list('S110','S210','FA10', 'SP11', 'S111', 'S211', 'FA11', 'SP12', 'S112', 'S212', 
                 'FA12', 'SP13', 'S1SMR13', 'S213', 'FA13', 'SP14', 'S1SMR14', 'S214', 'FA14',
                 'SP15', 'S1SMR15', 'S215', 'FA15', 'SP16', 'S1SMR16', 'S216')
#questions?
#assure that the list is ordered?
newdf<-list()
for (dataname in filelist){
  newname<-paste0("~/CEN",dataname," (scrubbed)_modified.csv")
  tmp<-as.data.frame(read_csv(newname))
  assign(dataname, tmp)
}

datalist <- list(S110,S210,FA10, SP11, S111, S211, FA11, SP12, S112, S212, 
                 FA12, SP13, S1SMR13, S213, FA13, SP14, S1SMR14, S214, FA14,
                 SP15, S1SMR15, S215, FA15, SP16, S1SMR16, S216)

allIDs=list()

testlist <- list(S110, S210, SP11)

for (dataname in testlist){
  allIDs<-union(allIDs,dataname$`DUMMY ID`)
  
  #print(dataname)
  
  #for (currentID in dataname$'DUMMY ID'){
  #  if (is.element(allIDs, currentID)){
  #Do nothing
  #    }
  #  else{
  #    append(allIDs,currentID)
  #  }
  #}
}

#Extract the columns that don't change between semesters from the first Census file. This will
# allow us to pre-populate the end data-frame with the columns we want.
Race1<-datalist[[1]]$`Reported Race/Ethnicity`[which(datalist[[1]]$'DUMMY ID'==intersect(allIDs,datalist[[1]]$'DUMMY ID'))]
Gender1<-datalist[[1]]$Gender[which(datalist[[1]]$'DUMMY ID'==intersect(allIDs,datalist[[1]]$'DUMMY ID'))]
Denomination1<-datalist[[1]]$Denomination[which(datalist[[1]]$'DUMMY ID'==intersect(allIDs,datalist[[1]]$'DUMMY ID'))]
Citizenship1<-datalist[[1]]$Citizenship[which(datalist[[1]]$'DUMMY ID'==intersect(allIDs,datalist[[1]]$'DUMMY ID'))]

#Create an initial data-frame with just the first census file's data.
IDData<-data.frame(ID=intersect(allIDs,datalist[[1]]$'DUMMY ID'), Race=Race1, Gender=Gender1, Denomination=Denomination1, Citizenship=Citizenship1)

testlist<-list(S210,SP11)
#------------------------------------------------
#Not finished. There may still be some issues with duplication by using the current "interset" logic. 
#Need to think more on this to make sure not creating duplicate records.

#Loop over all the datasets to store all the unique data

#dataname=S210
for (dataname in testlist){
  not_found_yet<-setdiff(dataname$DUMMY.ID, IDData$ID)
  indx_not_found=match(not_found_yet, dataname$DUMMY.ID)
  
  #Broken out to increase readability.
  Race_tmp<-dataname$Reported.Race.Ethnicity[indx_not_found]
  Gender_tmp<-dataname$Gender[indx_not_found]
  Denomination_tmp<-dataname$Denomination[indx_not_found]
  Citizenship_tmp<-dataname$Citizenship[indx_not_found]
  
  #Attach it to our growing data structure.
  rowcnt<-nrow(IDData)
  IDData<-rbind(IDData, data.frame(ID=not_found_yet, Race=Race_tmp, Gender=Gender_tmp, Denomination=Denomination_tmp, Citizenship=Citizenship_tmp))
  
}


tmpdf<-data.frame(Sem=filelist[1],data=datalist[[1]][1,])

#IDData$semester <- tmpdf

IDSemData<-data.frame(ID=datalist[[1]]$DUMMY.ID[1])

#adding new column
IDSemData[["SemInfo"]]<-rbind(IDSemData$SemInfo, tmpdf)


#loop until length(filelist)
#loop until length(datalist)
#check if the dummyID appears in each semester
#not working :(



for (i in 1:length(filelist)){
  tempdf <- data.frame(sem=filelist[i],data=datalist[[i]][i,])
  IDSemData_sample<-data.frame(ID=datalist[[i]]$DUMMY.ID[i])
  sample[["data_sample"]] <- rbind(sample[["data_sample"]], tempdf) 
  #IDSemData_sample[["SemInfo"]]<-rbind(IDSemData_sample[["SemInfo"]], data.frame(sem=filelist[i+1],data=datalist[[i]][i,]))
}


#nested for loop to add student information
#and check if student appears in each semester
for(var in testlist){
  for(i in 1:length(filelist))
    tmpdf <- data.frame(sem=filelist[i])
}
  
  








#adding more columns
#not yet working
#IDSemData[["SemInfo"]]<-rbind(IDSemData[["SemInfo"]], data.frame(Sem=filelist[2], data=datalist[[1]][1,]))
#sample <- data.frame(Sem=filelist[2], data=datalist[[1]][1,])
