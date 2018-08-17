libname box "C:\Users\Lizzy\OneDrive\Columbia\Summer 2018\MixturesWorkshop\From Ami";
*You will need to change the libname to the file path on your pc;

**restart;
data pcbs; set box.pcbs;
run;

proc contents data=box.pcbs;
run;

**resave;
data box.pcbs; set pcbs;
run;

*******************************************************
******************************************************
				CREATE VARIABLES
******************************************************
*****************************************************;
*create age groups (age_cat)
********************************************************;
data pcbs; set pcbs;
age_cat=.;
if ridageyr =. then age_cat=.;
else if ridageyr >= 20 and ridageyr <40 then age_cat=1;
else if ridageyr >= 40 and ridageyr <60 then age_cat=2;
else if ridageyr >= 60 then age_cat=3;
run;
*making binary proc reg variable format;
data pcbs; set pcbs;
if ridageyr ne . then do;
	age1= (age_cat=1);
	age2= (age_cat=2);
	age3= (age_cat=3);
	end;
run;


*making  BMI categories;
*bmi 3 categories
********************************************************************;
data pcbs; set pcbs;
bmi_cat3=.;
if bmxbmi=. then bmi_cat3=.;
if bmxbmi < 25 then bmi_cat3=1;
else if bmxbmi >=25 and bmxbmi <30 then bmi_cat3=2;
else if bmxbmi >=30 then bmi_cat3=3;
run;
*proc reg version;
data pcbs; set pcbs;
if bmxbmi ne . then do;
	bmi3_1= (bmi_cat3=1);
	bmi3_2= (bmi_cat3=2);
	bmi3_3= (bmi_cat3=3);
	end;
run;

*making smoking (pack-year) categories
*************************************************************************;
data pcbs; set pcbs;
if smq040=7 or smq040=9 then smq040=.;
if smq020 in (7,9) then smq020=.;
run;

*smoke_cpn
*****************************************************************;
data pcbs; set pcbs;
smoke_cpn=.;
if smq020=. then smoke_cpn=.;
else if smq020=2 then smoke_cpn=0;
else if smq040 in (1,2) then smoke_cpn=2;
else if smq040=3 then smoke_cpn=1;
else if smq040=. then smoke_cpn=.;
else smoke_cpn=8;
run;
*proc reg version;
data pcbs; set pcbs;
if smoke_cpn ne . then do;
	current_smk= (smoke_cpn=2);
	past_smk= (smoke_cpn=1);
	never_smk= (smoke_cpn=0);
	end;
run;

proc freq data=pcbs;
tables smoke_cpn;
where studypop=1;
run;

*making PIR categories
*******************************************************;
data pcbs; set pcbs; 
PIR=.;
if indfmpir=. then PIR=.;
else if indfmpir <1 then Pir_cat=1;
else if indfmpir >=1 and indfmpir <= 3 then pir_cat=2;
else if indfmpir >3 then pir_cat=3;
run;
*proc reg version;
data pcbs; set pcbs;
if pir_cat ne . then do;
	pir1= (pir_cat=1);
	pir2= (pir_cat=2);
	pir3= (pir_cat=3);
	end;
run;

*making education categories
*********************************************;
data pcbs; set pcbs;
if dmdeduc2=7 or dmdeduc2=9 then dmdeduc2=.;
edu_cat=.;
if dmdeduc2=. then edu_cat=.;
else if dmdeduc2=1 or dmdeduc2=2 then edu_cat=1;
else if dmdeduc2=3 then edu_cat=2;
else if dmdeduc2=4 then edu_cat=3;
else if dmdeduc2=5 then edu_cat=4;
run;
*proc reg version;
data pcbs; set pcbs;
if edu_cat ne . then do;
	edu1= (edu_cat=1);
	edu2= (edu_cat=2);
	edu3= (edu_cat=3);
	edu4= (edu_cat=4);
end;
run;

*making race categories
*****************************************************;
data pcbs; set pcbs;
race_cat=.;
if ridreth1=. then race_cat=.;
else if ridreth1=1 then race_cat=2;
else if ridreth1=3 then race_cat=4;
else if ridreth1=4 then race_cat=3;
else if ridreth1=2 or ridreth1=5 then race_cat=1;
run;

*proc reg version;
data pcbs; set pcbs;
if ridreth1 ne . then do;
	race1= (race_cat=1);
	race2= (race_cat=2);
	race3= (race_cat=3);
	race4= (race_cat=4);
	end;
run;

*proc reg for gender
**************************************;
data pcbs; set pcbs; 
male=.; 
female=.;
if riagendr=1 then male=1;
else male=0;
if riagendr=2 then female=1;
else female=0;
run;

*making pack years
**********************************;
data pcbs; set pcbs;
if smq040 in (3,.) then smokenow=0;
if smq040 in (1,2) then smokenow=1;
if smq040 in (7,9) then smokenow=.;

if smq040=3 then smokepast=1;
if smq040 in (1,2,.) then smokepast=0;
if smq040 in (7,9) then smokepast=.;

if smq040=. then neversmoke=1;
if smq040 in (1,2,3) then neversmoke=0;
if smq040 in (7,9) then neversmoke=.;

if smokenow=1 then smoke3cat=1;
if smokepast=1 then smoke3cat=2;
if neversmoke=1 then smoke3cat=3;
if smokenow=. then smoke3cat=.;

	*age started smoking;
smoke1st=smd030;
if smd030 in (0,777,999,.) then smoke1st=.;

	*age stopped smoking;
smokelast=smd055;
if smd055 in (777,999,.) then smokelast=.;

	*number of years smoked;
if smokenow=1 then yrssmoke=ridageyr-smoke1st;
if smokepast=1 then yrssmoke=smokelast-smoke1st;
if neversmoke=1 then yrssmoke=0;

	*number of cigarettes smoked per day - now or when quit;
if smd057 in (777,999) then numcigs=.;
if smd070 in (777,999) then numcigs=.;
if smokepast=1 then numcigs=smd057;
if smokenow=1 then numcigs=smd070;
if neversmoke=1 then numcigs=0;

packyrs=(numcigs*yrssmoke)/20;
if numcigs=. or yrssmoke=. then packyrs=.;
	*pack years categories;
packyrs0=0;
if packyrs=0 then packyrs0=1;
if packyrs=. then packyrs0=.;
packyrslt30=0;
if packyrs gt 0 and packyrs lt 30 then packyrslt30=1;
if packyrs=. then packyrslt30=.;
packyrs30_59=0;
if packyrs ge 30 and packyrs lt 60 then packyrs30_59=1;
if packyrs=. then packyrs30_59=.;
packyrs60=0;
if packyrs ge 60 then packyrs60=1;
if packyrs=. then packyrs60=.;
if packyrs0=1 then smokepackyrs=0;
else if packyrslt30=1 then smokepackyrs=1;
else if packyrs30_59=1 then smokepackyrs=2;
else if packyrs60=1 then smokepackyrs=3;
run;

proc freq data=pcbs;
tables smokepackyrs;
where studypop=1;
run;

*create study population
************************************************************;

proc contents data = pcbs;
run;

*remove people who are not in the genetic subset;
data pcbs1; set pcbs;
if ridageyr < 20 or ridageyr > 85 then delete;
if t_s_mean = .  then delete;
run;
********************************************************This part deletes all observations;
********************************************************T_S_mean = . for everyone;
proc means data = pcbs;
var telomean;
run;

*studypop;
data pcbs; set pcbs;
studypop=.;
if ridageyr=. or  ridreth1=. or riagendr=. or lbxcot=. or dmdeduc2=. or bmxbmi=. or sddsrvyr ne 2 or wtspo2yr = . then studypop=0;
else studypop=1;
run;
* From the population with sufficient
DNA samples to generate LTL data, we
then excluded individuals without environmental
chemical analysis data (n = 2,850) or
who were missing data on body mass index
(BMI) (n = 70), education (n = 2), or serum
cotinine (n = 8), leaving a study population of 1,330 individuals;

proc means data=pcbs;
var studypop;
run;

proc means data=pcbs nmiss n;
var ridageyr  
ridreth1 
riagendr 
lbxcot 
dmdeduc2
bmxbmi
sddsrvyr 
wtspo2yr;
run;

data box.studypop; set pcbs;
where studypop = 1;
run;

*Export to CSV;
proc export data=box.studypop
   outfile='C:\Users\Lizzy\OneDrive\Columbia\Summer 2018\MixturesWorkshop\Data\studypop.csv'
   dbms=csv
   replace;
run;
