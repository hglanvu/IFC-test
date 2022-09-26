
#####Part 1 

##1- Importing
cd "/Users/huongvu/Documents/STATA/IFC"
import delimited "/Users/huongvu/Documents/STATA/IFC/New Variables.csv"
save "/Users/huongvu/Documents/STATA/IFC/New_Variables.dta", replace
use "/Users/huongvu/Documents/STATA/IFC/Main Dataset.dta", clear
merge 1:1 uniqueid using "/Users/huongvu/Documents/STATA/IFC/New_Variables.dta"
save "/Users/huongvu/Documents/STATA/IFC/Main Dataset_1.dta"
use "/Users/huongvu/Documents/STATA/IFC/Main Dataset_1.dta", clear
append using "/Users/huongvu/Documents/STATA/IFC/New Observations.dta"
save "/Users/huongvu/Documents/STATA/IFC/Main Dataset_final.dta"

##2-Cleaning
egen surveyorid = group(surveyor)
label variable surveyorid "Surveyor ID"
drop surveyor
recode vandalismyn trespassingyn (-666=.) (-999=.d) (-997=.r) (-777=.b) (-555=.n)
la def yesno .d "Don't know" .r "Refusal" .b "Blank" .n "Not applicable", modify

rename surveydate surveydate_string
gen surveydate = date(surveydate_string, "MDY")
format surveydate %td
drop surveydate_string

destring hhid

save "/Users/huongvu/Documents/STATA/IFC/Main Dataset_final.dta", replace

#####Part 2

# calculate the total number of deceased children under 28 months and 1 year old

use "/Users/huongvu/Documents/STATA/IFC/Part 2/deceased-13.dta.dta"
drop if missing(lived) #drop missing value so we know total number of deceased children 
tab lived_unit #show total number of dead children - 5,257 deceased children

#the total number of deceased children under 28 months
gen lived_28days=1 if inlist(lived_unit,1,2)| (inrange(lived,0,28) & lived_unit==3) 
sum lived_28days #the total number of deceased children under 28 months -   1,947 
#the total number of deceased children under 28 months 
tab lived_28days sex_deceased
#the total number of deceased children under 28 months with the percentage of boy and girl
tab lived_28days sex_deceased, row nofreq 
#keep the total number of deceased children lived 28 days and below
keep if lived_28days==1
save "/Users/huongvu/Documents/STATA/IFC/Part 2/deceased-13-lived28days.dta"

#the total number of deceased children under 1 year old
gen lived_1yrold=1 if inlist(lived_unit,1,2,3,4)|(lived==1 & lived_unit==5)
sum lived_1yrold #the total number of deceased children under 1 year old -  4,228  
#the total number of deceased children under 1 year old
tab lived_1yrold sex_deceased
#the total number of deceased children under 1 year old with the percentage of boy and girl
tab lived_1yrold sex_deceased, row nofreq 
#keep the total number of deceased children lived 1 year old and below
keep if lived_1yrold==1
save "/Users/huongvu/Documents/STATA/IFC/Part 2/deceased-13-lived1yrold.dta"

use "/Users/huongvu/Documents/STATA/IFC/Part 2/deceased-13-lived1yrold.dta"
#understand the relation between drinking water/latrine/insurance with the rate to deceased children
asdoc tab drinking_water if lived_1yrold==1
asdoc tab insurance if lived_1yrold==1
asdoc tab latrine if lived_1yrold==1










