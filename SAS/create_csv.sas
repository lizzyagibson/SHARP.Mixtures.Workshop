libname box "C:\Users\Lizzy\OneDrive\Columbia\Summer 2018\MixturesWorkshop\From Ami";

**restart;
data pcbs; set box.pcbs;
run;

proc contents data=pcbs;
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
Pir_cat=.;
if indfmpir=. then Pir_cat=.;
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

****************************************************************
******************************************************************
							ANALYSIS
****************************************************************
***************************************************************;

*create study population
************************************************************;
*remove people who are not in the genetic subset

THIS CODE DOES NOT WORLK--SUBSETS TO ZERO;
data pcbs1; set pcbs;
if ridageyr < 20 or ridageyr > 85 then delete;
if T_S_mean =.  then delete;
run;
*studypop;

data pcbs; set pcbs;
studypop=.;
if ridageyr=. or  ridreth1=. or riagendr=. or lbxcot=. or dmdeduc2=. or bmxbmi=. or sddsrvyr ne 2 or wtspo2yr = . then studypop=0;
else studypop=1;
run;

proc freq data=pcbs;
tables studypop;
where sddsrvyr= 2;
run;

*****************************************************************************************
*****************************************************************************************
										PERCENT NON-DETECT 
*****************************************************************************************
****************************************************************************************;
*percent nondetect;
*pcbs;
proc freq data=PCBS;
tables LBd052lc LBd066lc LBd074lc LBd087lc LBd099lc LBd101lc LBd105lc LBd110lc LBd118lc LBDPCBLC LBd128lc 
LBd138lc LBd146lc LBd149lc LBd151lc LBd153lc LBd156lc LBd157lc LBd167lc LBDHXCLC LBd170lc LBd172lc LBd177lc 
LBd178lc LBd180lc LBd183lc LBd187lc LBd189lc LBd194lc LBd195lc LBd196lc LBd199lc LBd206lc LBDTC2LC;
where studypop=1;
run;

*dioxins;
proc freq data=PCBS;
tables lbdtcdlc LBdd01lc LBdd02lc LBdd03lc LBdd04lc LBdd05lc LBdd07lc lbdf01lc lbdf02lc lbdf03lc 
lbdf04lc lbdf05lc lbdf06lc lbdf07lc lbdf08lc lbdf09lc lbdf10lc;
where studypop=1;
run;

*measure detection limits;
proc freq data=pcbs;
tables LBx074la*LBd074lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx099la*LBd099lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx105la*LBd105lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx118la*LBd118lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx118la*LBd118lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxpcbla*LBdpcblc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx138la*LBd138lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx153la*LBd153lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx156la*LBd156lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx157la*LBd157lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx167la*LBd167lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxHXCla*LBdHXClc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx170la*LBd170lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx180la*LBd180lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx187la*LBd187lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx189la*LBd189lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx194la*LBd194lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx196la*LBd196lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBx199la*LBd199lc;
where studypop=1;
run;

*dioxins;
proc freq data=pcbs;
tables lbxtcdla*lbdtcdlc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxd01la*LBdd01lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxd02la*LBdd02lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxd03la*LBdd03lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxd04la*LBdd04lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxd05la*LBdd05lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxd07la*LBdd07lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf01la*LBdf01lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf02la*LBdf02lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf03la*LBdf03lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf04la*LBdf04lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf05la*LBdf05lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf06la*LBdf06lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf07la*LBdf07lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf08la*LBdf08lc;
where studypop=1;
run;
proc freq data=pcbs;
tables LBxf09la*LBdf09lc;
where studypop=1;
run;


*****************************************************************************************
*****************************************************************************************
										VARIABLE CREATION
*****************************************************************************************
****************************************************************************************;
*transform to pg/g 
*DO NOT RE-RUN THIS CODE!!!!!*
******************************************************************;
/*data pcbs; set pcbs;
lbx052la= lbx052la*1000;
lbx066la= lbx066la*1000;
lbx074la= lbx074la*1000;
lbx087la= lbx087la*1000;
lbx099la= lbx099la*1000;
lbx101la= lbx101la*1000;
lbx105la= lbx105la*1000;
lbx118la= lbx118la*1000;
lbx128la= lbx128la*1000;
lbx138la= lbx138la*1000;
lbx146la= lbx146la*1000;
lbx149la= lbx149la*1000;
lbx151la= lbx151la*1000;
lbx153la= lbx153la*1000;
lbx156la= lbx156la*1000;
lbx157la= lbx157la*1000;
lbx167la= lbx167la*1000;
lbx170la= lbx170la*1000;
lbx172la= lbx172la*1000;
lbx177la= lbx177la*1000;
lbx178la= lbx178la*1000;
lbx180la= lbx180la*1000;
lbx183la= lbx183la*1000;
lbx187la= lbx187la*1000;
lbx189la= lbx189la*1000;
lbx194la= lbx194la*1000;
lbx195la= lbx195la*1000;
lbx196la= lbx196la*1000;
lbx199la= lbx199la*1000;
lbx206la= lbx206la*1000;

LBXBHCLA = LBXBHCLA*1000;
LBXHPELA = LBXHPELA*1000;
LBXOXYLA = LBXOXYLA*1000;
LBXPDELA = LBXPDELA*1000;
LBXTNALA = LBXTNALA*1000;
LBXDIELA = LBXDIELA*1000;
LBXALDLA = LBXALDLA*1000;
LBXENDLA = LBXENDLA*1000;
run;
*/


************************************************************************
*attempt to calculate lipids;
******************************************************************;
data pcbs; set pcbs;
lbx074_pg= lbx074*1000;
lbx138_pg= lbx138*1000;
lbx153_pg= lbx153*1000;
lbx180_pg= lbx180*1000;
lbxd05_pg= lbxd05/1000;
run;

proc print data=pcbs;
var seqn;
where lbx138la = . and lbx153=. and lbx180=. and studypop=1;
run;

data pcbs; set pcbs;
lipid_074=.;
if lbx074la ne . and lbx074_pg ne . and lbd074lc = 0 then lipid_074= lbx074la/lbx074_pg;
else lipid_074=.;
run;
data pcbs; set pcbs;
lipid_138=.;
if lbx138la ne . and lbx138_pg ne . and lbd138lc = 0 then lipid_138= lbx138la/lbx138_pg;
else lipid_138=.;
run;
data pcbs; set pcbs;
lipid_153=.;
if lbx153la ne . and lbx153_pg ne . and lbd153lc = 0 then lipid_153= lbx153la/lbx153_pg;
else lipid_153=.;
run;
data pcbs; set pcbs;
lipid_180=.;
if lbx180la ne . and lbx180_pg ne . and lbd180lc = 0 then lipid_180= lbx180la/lbx180_pg;
else lipid_180=.;
run;
data pcbs; set pcbs;
lipid_d05=.;
if lbxd05la ne . and lbxd05_pg ne . and lbdd05lc = 0 then lipid_d05= lbxd05la/lbxd05_pg;
else lipid_d05=.;
run;

data pcbs; set pcbs;
lipids=.;
if lipid_074=. and lipid_138=. and lipid_153=. and lipid_180=. and lipid_d05= . then lipids=.;
else lipids= mean(lipid_074, lipid_138, lipid_153, lipid_180, lipid_d05);
run;

proc univariate data=pcbs;
var lipids;
where studypop=1;
run;




**************************************** LOG TRANSFORMATION ***********************************************;
data pcbs; set pcbs;
ln_lbx052la= log(lbx052la);
ln_lbx066la= log(lbx066la);
ln_lbx074la= log(lbx074la);
ln_lbx087la= log(lbx087la);
ln_lbx099la= log(lbx099la);
ln_lbx101la= log(lbx101la);
ln_lbx105la= log(lbx105la);
ln_lbx118la= log(lbx118la);
ln_lbxpcbla= log(lbxpcbla); /*pcb 126*/
ln_lbx128la= log(lbx128la);
ln_lbx138la= log(lbx138la);
ln_lbx146la= log(lbx146la);
ln_lbx149la= log(lbx149la);
ln_lbx151la= log(lbx151la);
ln_lbx153la= log(lbx153la);
ln_lbx156la= log(lbx156la);
ln_lbx157la= log(lbx157la);
ln_lbx167la= log(lbx167la);
ln_lbxhxcla= log(lbxhxcla); /*pcb 169*/
ln_lbx170la= log(lbx170la);
ln_lbx172la= log(lbx172la);
ln_lbx177la= log(lbx177la);
ln_lbx178la= log(lbx178la);
ln_lbx180la= log(lbx180la);
ln_lbx183la= log(lbx183la);
ln_lbx187la= log(lbx187la);
ln_lbx189la= log(lbx189la);
ln_lbx194la= log(lbx194la);
ln_lbx195la= log(lbx195la);
ln_lbx196la= log(lbx196la);
ln_lbx199la= log(lbx199la);
ln_lbx206la= log(lbx206la);
ln_lbxcot= log(lbxcot);

ln_LBXTCDLA= log(LBXTCDLA);
ln_LBXD01LA= log(LBXD01LA);
ln_LBXD02LA= log(LBXD02LA);
ln_LBXD03LA= log(LBXD03LA);
ln_LBXD04LA= log(LBXD04LA);
ln_LBXD05LA= log(LBXD05LA);
ln_LBXD07LA = log(LBXD07LA);
ln_LBXF01LA= log(LBXF01LA);
ln_LBXF02LA= log(LBXF02LA);
ln_LBXF03LA= log(LBXF03LA);
ln_LBXF04LA = log(LBXF04LA);
ln_LBXF05LA = log(LBXF05LA);
ln_LBXF06LA = log(LBXF06LA);
ln_LBXF07LA= log(LBXF07LA);
ln_LBXF08LA = log(LBXF08LA);
ln_LBXF09LA = log(LBXF09LA);
ln_LBXF10LA = log(LBXF10LA);
ln_LBXTC2LA = log(LBXTC2LA);
ln_LBXBHCLA = log(LBXBHCLA);
ln_LBXHPELA = log(LBXHPELA);
ln_LBXOXYLA = log(LBXOXYLA);
ln_LBXPDELA = log(LBXPDELA);
ln_LBXTNALA = log(LBXTNALA);
ln_LBXDIELA = log(LBXDIELA);
ln_LBXALDLA = log(LBXALDLA);
ln_LBXENDLA = log(LBXENDLA);
run;



*SUMS
********************************************************************************************;
** NON-ORTHO SUB, NO WEIGHTS;
data pcbs; set pcbs;
non_ortho_noteq=log((lbxpcbla) + (lbxhxcla));
run;

***non-dioxin-like (all);
data pcbs; set pcbs;
ndl_all= log (lbx074la + lbx099la + lbx138la + lbx153la + lbx170la + 
	lbx180la + lbx187la + lbx194la + lbx196la + lbx199la);
run;

**TEQ;
data pcbs; set pcbs;
teq= log(lbxtcdla + lbxd01la + (0.1*lbxd02la) + (0.1*lbxd03la) + (0.1*lbxd04la) + (0.01*lbxd05la) + (0.0003*LBXD07la) +
(lbxf01la*0.1) + (Lbxf02la*0.03) + (lbxf03la*0.3) + (lbxf04la*0.1) + (lbxf05la*0.1) + (lbxf06la*0.1) + (lbxf07la*0.1) +
(lbxf08la*0.01) + (lbxf09la*0.01) + (lbxpcbla*0.1) + (lbxhxcla*0.03) +  (lbx105la*0.00003) + (lbx118la*0.00003) + 
(lbx156la*0.00003) + (lbx157la*0.00003) + (lbx167la*0.00003) + (lbx189la*0.00003));
run;

**TEQ33;
data pcbs; set pcbs;
teq33= log(lbxd01la + (0.1*lbxd02la) + (0.1*lbxd03la) + (0.1*lbxd04la) + (0.01*lbxd05la) + (0.0003*LBXD07la) +
(lbxf03la*0.3) + (lbxf04la*0.1) + (lbxf05la*0.1) + (lbxf08la*0.01) + (lbxpcbla*0.1) + (lbxhxcla*0.03) + 
(lbx118la*0.00003) + (lbx156la*0.00003));
run;
**TEQ50;
data pcbs; set pcbs;
teq50= log((0.1*lbxd03la) + (0.01*lbxd05la) + (0.0003*LBXD07la) + (lbxf03la*0.3) + (lbxf04la*0.1) + 
(lbxf05la*0.1) + (lbxf08la*0.01) + (lbxpcbla*0.1) + (lbxhxcla*0.03) + (lbx118la*0.00003) + 
(lbx156la*0.00003));
run;

**TEQ imputed;
libname pcbs "C:\Users\smitro\Box Sync\NHANES Projects\Non-Persistent Pollutants and Telomeres\Data";

data pcbs.pcbs_imputed; set pcbs.pcbs_imputed;
teq_imp= log(lbxtcdimp + lbxd01imp + (0.1*lbxd02imp) + (0.1*lbxd03imp) + (0.1*lbxd04imp) + (0.01*lbxd05imp) + (0.0003*LBXD07imp) +
(lbxf01la*0.1) + (Lbxf02la*0.03) + (lbxf03imp*0.3) + (lbxf04imp*0.1) + (lbxf05la*0.1) + (lbxf06la*0.1) + (lbxf07imp*0.1) +
(lbxf08imp*0.01) + (lbxf09la*0.01) + (lbxpcbimp*0.1) + (lbxhxcimp*0.03) + (lbx105imp*0.00003) + (lbx118imp*0.00003) + 
(lbx156imp*0.00003) + (lbx157la*0.00003) + (lbx167imp*0.00003) + (lbx189la*0.00003));
run;



**********************************
MAKING QUARTILES;
proc univariate data= pcbs;
var ndl_all non_ortho_noteq teq;
weight wtspo2yr;
where studypop=1;
run;


*ndl_all (ALL);
data pcbs; set pcbs;
ndl_all_cat=.;
if ndl_all=. then ndl_all_cat=.;
else if ndl_all <= 11.22 then ndl_all_cat=1;
else if ndl_all > 11.22 and ndl_all <= 11.82 then ndl_all_cat=2;
else if ndl_all > 11.82 and ndl_all <= 12.41 then ndl_all_cat=3;
else if ndl_all > 12.41 then ndl_all_cat=4;
else ndl_all_cat=5;
run;

*NON ORTHO NO TEQ;
data pcbs; set pcbs;
NONT_cat=.;
if non_ortho_noteq=. then NONT_cat=.;
else if non_ortho_noteq <= 3.29 then NONT_cat=1;
else if non_ortho_noteq > 3.29 and non_ortho_noteq <= 3.80 then NONT_cat=2;
else if non_ortho_noteq > 3.80 and non_ortho_noteq <= 4.27 then NONT_cat=3;
else if non_ortho_noteq > 4.27 then NONT_cat=4;
else NONT_cat=5;
run;

*teq;
data pcbs; set pcbs;
teq_cat=.;
if teq=. then teq_cat=.;
else if teq <= 2.54 then teq_cat=1;
else if teq > 2.54 and teq <= 2.85 then teq_cat=2;
else if teq > 2.85 and teq <= 3.23 then teq_cat=3;
else if teq > 3.23 then teq_cat=4;
else teq_cat=5;
run;
********************proc reg version;
data pcbs; set pcbs;
if teq_cat ne . then do;
	teq1= (teq_cat=1);
	teq2= (teq_cat=2);
	teq3= (teq_cat=3);
	teq4= (teq_cat=4);
	end;
run;


*make a more reasonable output scale (multiply ln TS ratio by 1000);
data pcbs; set pcbs; 
tsmean100= telomean*100;
run;
*log transform telomeres;
data pcbs; set pcbs; 
ln_tsmean= log(telomean);
run;

*****************************************************************************
TABLE 1 DESCRIBES THE SAMPLE SIZE, WEIGHTS, AND LIMIT OF DETECTION FOR EACH CONGENER.

TABLE 2: DESCRIPTIVE STATS
controlling for dioxin-like pcbs and teq + organochlorines
******************************************************************************;
*creating cotinine_cat;
data pcbs; set pcbs;
cotinine_cat=.;
if lbxcot=. then cotinine_cat=.;
else if lbxcot < 0.015 then cotinine_cat=1;
else if lbxcot >= 0.015 and lbxcot <= 9.9 then cotinine_cat=2;
else if lbxcot > 9.9 then cotinine_cat=3;
else cotinine_cat=4;
run;
proc freq data=pcbs;
tables cotinine_cat;
run;


*categorical;
proc surveyfreq data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
tables cotinine_cat age_cat riagendr race_cat edu_cat bmi_cat3 mcq220/chisq row;
where studypop=1;
run;

*LTL ADJUSTED FOR AGE
**********************************************;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model tsmean100=  ridageyr /adjrsq;
domain studypop;
output out=ageadj predicted=pred;
run;

*age adjusted LTL by demographics
***********************************;
%MACRO tableone (cat);
proc sort data=ageadj; 
by &cat;
run;
proc surveymeans data=ageadj;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var pred;
by &cat;
domain studypop;
run;
proc surveyreg data=ageadj;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class &cat;
model pred= &cat;
domain studypop;
run;
%MEND tableone;

%tableone(cotinine_cat);
%tableone(riagendr);
%tableone(race_cat);
%tableone(edu_cat);
%tableone(bmi_cat3);
%tableone(mcq220);

*whole population age-adjusted telomere length mean;
proc surveymeans data=ageadj;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var pred;
domain studypop;
run;

*age (not adjusted for age);
proc sort data=pcbs; 
by age_cat;
run;
proc surveymeans data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var tsmean100;
by age_cat;
domain studypop;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class age_cat;
model tsmean100= age_cat;
domain studypop;
run;



*TABLE 3: POLLUTANT LEVELS BY SUMMED METRIC 
**********************************************************************
********************************************************************************************;
*whole population;
proc surveymeans data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var ndl_all;
domain studypop;
run;
proc surveymeans data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var non_ortho_noteq;
domain studypop;
run;
proc surveymeans data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var teq;
domain studypop;
run;

%MACRO tabletwo (metric, cat);
proc sort data=pcbs; 
by &cat;
run;
proc surveymeans data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
var &metric;
by &cat;
domain studypop;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class &cat;
model &metric= &cat;
domain studypop;
run;
%MEND tabletwo;

%tabletwo(ndl_all, cotinine_cat);
%tabletwo(ndl_all, age_cat);
%tabletwo(ndl_all, riagendr);
%tabletwo(ndl_all, race_cat);
%tabletwo(ndl_all, edu_cat);
%tabletwo(ndl_all, bmi_cat3);
%tabletwo(ndl_all, mcq220);

%tabletwo(non_ortho_noteq, cotinine_cat);
%tabletwo(non_ortho_noteq, age_cat);
%tabletwo(non_ortho_noteq, riagendr);
%tabletwo(non_ortho_noteq, race_cat);
%tabletwo(non_ortho_noteq, edu_cat);
%tabletwo(non_ortho_noteq, bmi_cat3);
%tabletwo(non_ortho_noteq, mcq220);

%tabletwo(teq, cotinine_cat);
%tabletwo(teq, age_cat);
%tabletwo(teq, riagendr);
%tabletwo(teq, race_cat);
%tabletwo(teq, edu_cat);
%tabletwo(teq, bmi_cat3);
%tabletwo(teq, mcq220);



*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE (TABLE 5)
MODEL 1: NOT ADJUSTING FOR ANOTHER METRIC
******************************************************************************;

*non_dioxin_like
*******************************************;
proc sort data=pcbs;
by descending ndl_all;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= ndl_all age_cent age_sq /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class ndl_all_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= ndl_all_cat age_cent age_sq/clparm solution;
domain studypop;
run;


*non ortho NOTEQ
*******************************;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= non_ortho_noteq age_cent age_sq/clparm solution;
domain studypop;
run;
*cats;
proc sort data=pcbs;
by descending nont_cat;
run;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class nont_cat;
model ln_tsmean= nont_cat age_cent age_sq /clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= nont_cat age_cent age_sq /clparm solution;
domain studypop;
run;


*teq
**********************************************;
PROC SORT DATA=PCBS;
BY DESCENDING TEQ;
RUN;
****not adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= teq age_cent age_sq /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class teq_cat;
model ln_tsmean= teq_cat age_cent age_sq /clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= teq_cat age_cent age_sq /solution;
domain studypop;
run;



*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE (TABLE 5)
MODEL 2: FULLY ADJUSTED BUT NOT ADJUSTING FOR ANOTHER METRIC
******************************************************************************;
*non_dioxin_like
*******************************************;
proc sort data=pcbs;
by descending ndl_all;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ndl_all_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;


*non ortho NOTEQ
*******************************;
******multiplied by 100;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*cats;
proc sort data=pcbs;
by descending nont_cat;
run;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat nont_cat;
model ln_tsmean= nont_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= nont_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;



*teq
**********************************************;
PROC SORT DATA=PCBS;
BY DESCENDING TEQ;
RUN;
****not adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat teq_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct/solution;
domain studypop;
run;


*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE (TABLE 3)
MODEL 3: ADJUSTING FOR ANOTHER METRIC
******************************************************************************;
**ndl adjusted for non-ortho;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ndl_all_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq /clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq /solution;
domain studypop;
run;


****non ortho adjusted for non-dioxin-like all;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ;
model ln_tsmean= non_ortho_NOTEQ age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat nont_cat;
model ln_tsmean= nont_cat age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= nont_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;


****teq adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat teq_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/solution;
domain studypop;
run;



************************************************************************************************************************************
*************************************************************************************************************************************
		EFFECT MEASURE MODIFICATION: VALUES FOR FIGURE 1
*********************************************************************************************************************************
**********************************************************************************************************************************;

*AGE
*********************************************************************************************************************;
*P-VALUES;
*non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat AGE_CAT;
model ln_tsmean= ndl_all ndl_all*AGE_cat age_cAT RIDAGEYR ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq/solution;
domain studypop;
run;
*non ortho;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat AGE_CAT;
model ln_tsmean= non_ortho_noteq non_ortho_noteq*AGE_cat age_cAT RIDAGEYR ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/solution;
domain studypop;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat AGE_CAT;
model tsmean100= teq teq*AGE_cat RIDAGEYR ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct Ndl_all /solution;
domain studypop;
run;

*stratified values for the graph;
*non dioxin like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq/solution clparm;
domain studypop*age_cat;
run;
*non ORTHO;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*age_cat;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*age_cat;
run;



*SEX;
**************************************************************************************************************************;
*P-VALUES;
*non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat riagendr;
model tsmean100= ndl_all ndl_all*riagendr age_cent age_sq ln_lbxcot riagendr race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq /solution;
domain studypop;
run;
*dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat riagendr;
model tsmean100= non_ortho_noteq non_ortho_noteq*riagendr age_cent age_sq ln_lbxcot riagendr race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/solution;
domain studypop;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat riagendr;
model tsmean100= teq teq*riagendr age_cent age_sq ln_lbxcot riagendr race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/solution;
domain studypop;
run;

*STRATIFIED VALUES FOR THE GRAPH;
*non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq/solution clparm;
domain studypop*RIAGENDR;
run;
*non ORTHO;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*RIAGENDR;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*RIAGENDR;
run;


*RACE
*********************************************************************************************************************;
*P-VALUES;
*non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all ndl_all*race_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq/solution;
domain studypop;
run;
*non ortho;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq non_ortho_noteq*race_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all/solution;
domain studypop;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model tsmean100= teq teq*race_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct Ndl_all /solution;
domain studypop;
run;

*stratified VALUES FOR THE GRAPH;
*non dioxin like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq/solution clparm;
domain studypop*race_cat;
run;
*non ORTHO;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*race_cat;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*race_cat;
run;


*CANCER
*************************************************************************;
*P-VALUES;
*non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat mcq220;
model ln_tsmean= ndl_all ndl_all*mcq220 age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq mcq220/solution;
domain studypop;
run;
*non ortho;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat mcq220;
model ln_tsmean= non_ortho_noteq non_ortho_noteq*mcq220 age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all mcq220/solution;
domain studypop;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat mcq220;
model tsmean100= teq teq*mcq220 age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct Ndl_all mcq220/solution;
domain studypop;
run;

*stratified VALUES FOR THE MODEL;
*non dioxin like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq/solution clparm;
domain studypop*MCQ220;
run;
*non ORTHO;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*MCQ220;
run;
*teq;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct NDL_ALL/solution clparm;
domain studypop*MCQ220;
run;






*********************************************************************
SENSITIVITY ANALYSIS: TEQ 33 AND 50: SUPPLEMENTAL TABLE 1
***********************************************************************;
****teq33 adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq33 age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;

****teq50 adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq50 age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;

****teq IMPUTED, adjusted for non-dioxin-like;
libname pcbs "C:\Users\smitro\Box Sync\NHANES Projects\Non-Persistent Pollutants and Telomeres\Data";

data pcbs_imp; set pcbs.pcbs_imputed;
keep seqn teq_imp;
run; 
proc sort data=pcbs_imp;
by seqn;
run;
proc sort data=pcbs;
by seqn;
run;

data pcbs; set pcbs;
drop teq_imp;
run;

data pcbs;
merge pcbs pcbs_imp;
by seqn;
run;

proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_imp age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;

proc print data=pcbs.pcbs;
var seqn studypop;
where seqn=18217;
run; 



*************************************************************
**********************************************************************************
*****************************************************************************************************
***************************************************************************************************
SENSITIVITY ANALYSIS: REDO TABLE 5 WITHOUT ADJUSTMENT FOR LIPIDS TO PREPARE TABLE S2
**************************************************************************************************;
data pcbs; set pcbs;
lbx074_pg= lbx074*1000;
lbx099_pg= lbx099*1000;
lbx105_pg= lbx105*1000;
lbx118_pg= lbx118*1000;
lbxpcb_pg= lbxpcb/1000;
lbx138_pg= lbx138*1000;
lbx153_pg= lbx153*1000;
lbx156_pg= lbx156*1000;
lbx157_pg= lbx157*1000;
lbx167_pg= lbx167*1000;
lbxhxc_pg= lbxhxc/1000;
lbx170_pg= lbx170*1000;
lbx180_pg= lbx180*1000;
lbx187_pg= lbx187*1000;
lbx189_pg= lbx189*1000;
lbx194_pg= lbx194*1000;
lbx196_pg= lbx196*1000;
lbx199_pg= lbd199*1000;

lbxtcd_pg= lbxtcd/1000;
lbxd01_pg= lbxd01/1000;
lbxd02_pg= lbxd02/1000;
lbxd03_pg= lbxd03/1000;
lbxd04_pg= lbxd04/1000;
lbxd05_pg= lbxd05/1000;
lbxd07_pg= lbxd07/1000;
lbxf01_pg= lbxf01/1000;
lbxf02_pg= lbxf02/1000;
lbxf03_pg= lbxf03/1000;
lbxf04_pg= lbxf04/1000;
lbxf05_pg= lbxf05/1000;
lbxf06_pg= lbxf06/1000;
lbxf07_pg= lbxf07/1000;
lbxf08_pg= lbxf08/1000;
lbxf09_pg= lbxf09/1000;

run;


**************************************** LOG TRANSFORMATION ***********************************************;
data pcbs; set pcbs;
ln_lbx074_pg= log(lbx074_pg);
ln_lbx099_pg= log(lbx099_pg);
ln_lbx105_pg= log(lbx105_pg);
ln_lbx118_pg= log(lbx118_pg);
ln_lbxpcb_pg= log(lbxpcb_pg); /*pcb 126*/
ln_lbx138_pg= log(lbx138_pg);
ln_lbx153_pg= log(lbx153_pg);
ln_lbx156_pg= log(lbx156_pg);
ln_lbx157_pg= log(lbx157_pg);
ln_lbx167_pg= log(lbx167_pg);
ln_lbxhxc_pg= log(lbxhxc_pg); /*pcb 169*/
ln_lbx170_pg= log(lbx170_pg);
ln_lbx180_pg= log(lbx180_pg);
ln_lbx187_pg= log(lbx187_pg);
ln_lbx189_pg= log(lbx189_pg);
ln_lbx194_pg= log(lbx194_pg);
ln_lbx196_pg= log(lbx196_pg);
ln_lbx199_pg= log(lbx199_pg);

ln_LBXTCD_pg= log(LBXTCD_pg);
ln_LBXD01_pg= log(LBXD01_pg);
ln_LBXD02_pg= log(LBXD02_pg);
ln_LBXD03_pg= log(LBXD03_pg);
ln_LBXD04_pg= log(LBXD04_pg);
ln_LBXD05_pg= log(LBXD05_pg);
ln_LBXD07_pg = log(LBXD07_pg);
ln_LBXF01_pg= log(LBXF01_pg);
ln_LBXF02_pg= log(LBXF02_pg);
ln_LBXF03_pg= log(LBXF03_pg);
ln_LBXF04_pg = log(LBXF04_pg);
ln_LBXF05_pg = log(LBXF05_pg);
ln_LBXF06_pg = log(LBXF06_pg);
ln_LBXF07_pg= log(LBXF07_pg);
ln_LBXF08_pg = log(LBXF08_pg);
ln_LBXF09_pg = log(LBXF09_pg);

run;



*SUMS
*********************************************;
** NON-ORTHO SUB, NO WEIGHTS;
data pcbs; set pcbs;
non_ortho_noteq_pg=log((lbxpcb_pg) + (lbxhxc_pg));
run;

***non-dioxin-like (all);
data pcbs; set pcbs;
ndl_all_pg= log (lbx074_pg + lbx099_pg + lbx138_pg + lbx153_pg + lbx170_pg + 
	lbx180_pg + lbx187_pg + lbx194_pg + lbx196_pg + lbx199_pg);
run;

**TEQ;
data pcbs; set pcbs;
teq_pg= log(lbxtcd_pg + lbxd01_pg + (0.1*lbxd02_pg) + (0.1*lbxd03_pg) + (0.1*lbxd04_pg) + (0.01*lbxd05_pg) + (0.0003*LBXD07_pg) +
(lbxf01_pg*0.1) + (Lbxf02_pg*0.03) + (lbxf03_pg*0.3) + (lbxf04_pg*0.1) + (lbxf05_pg*0.1) + (lbxf06_pg*0.1) + (lbxf07_pg*0.1) +
(lbxf08_pg*0.01) + (lbxf09_pg*0.01) + (lbxpcb_pg*0.1) + (lbxhxc_pg*0.03) +  (lbx105_pg*0.00003) + (lbx118_pg*0.00003) + 
(lbx156_pg*0.00003) + (lbx157_pg*0.00003) + (lbx167_pg*0.00003) + (lbx189_pg*0.00003));
run;

**********************************
MAKING QUARTILES;
proc univariate data= pcbs;
var ndl_all_pg non_ortho_noteq_pg teq_pg;
weight wtspo2yr;
where studypop=1;
run;


*ndl_all (ALL);
data pcbs; set pcbs;
ndl_all_cat_pg=.;
if ndl_all_pg=. then ndl_all_cat_pg=.;
else if ndl_all_pg <= 6.10 then ndl_all_cat_pg=1;
else if ndl_all_pg > 6.10 and ndl_all_pg <= 6.77 then ndl_all_cat_pg=2;
else if ndl_all_pg > 6.77 and ndl_all_pg <= 7.39 then ndl_all_cat_pg=3;
else if ndl_all_pg > 7.39 then ndl_all_cat_pg=4;
else ndl_all_cat_pg=5;
run;

*NON ORTHO NO TEQ;
data pcbs; set pcbs;
NONT_cat_pg=.;
if non_ortho_noteq_pg=. then NONT_cat_pg=.;
else if non_ortho_noteq_pg <= -1.79 then NONT_cat_pg=1;
else if non_ortho_noteq_pg > -1.79 and non_ortho_noteq_pg <= -1.24 then NONT_cat_pg=2;
else if non_ortho_noteq_pg > -1.24 and non_ortho_noteq_pg <= -0.74 then NONT_cat_pg=3;
else if non_ortho_noteq_pg > -0.74 then NONT_cat_pg=4;
else NONT_cat_pg=5;
run;

*teq;
data pcbs; set pcbs;
teq_cat_pg=.;
if teq_pg=. then teq_cat_pg=.;
else if teq_pg <= -2.53 then teq_cat_pg=1;
else if teq_pg > -2.53 and teq_pg <= -2.21 then teq_cat_pg=2;
else if teq_pg > -2.21 and teq_pg <= -1.74 then teq_cat_pg=3;
else if teq_pg > -1.74 then teq_cat_pg=4;
else teq_cat_pg=5;
run;



*****************************************************************************
SUPPLEMENTAL TABLE S2
MULTIPLE REGRESSION: PERCENT CHANGE 
MODEL 1: NOT ADJUSTING FOR ANOTHER METRIC
******************************************************************************;
*non_dioxin_like
*******************************************;
proc sort data=pcbs;
by descending ndl_all_pg;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= ndl_all_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class ndl_all_cat_pg;
model ln_tsmean= ndl_all_cat_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= ndl_all_cat_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;

*non ortho NOTEQ
*******************************;
******multiplied by 100;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= non_ortho_noteq_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;
*cats;
proc sort data=pcbs;
by descending nont_cat_pg;
run;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class nont_cat_pg;
model ln_tsmean= nont_cat_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= nont_cat_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;

*teq
**********************************************;
PROC SORT DATA=PCBS;
BY DESCENDING TEQ_pg;
RUN;
****not adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= teq_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class teq_cat_pg;
model ln_tsmean= teq_cat_pg age_cent age_sq lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
model ln_tsmean= teq_cat_pg age_cent age_sq lipids/solution;
domain studypop;
run;



*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE
MODEL 2: FULLY ADJUSTED BUT NOT ADJUSTING FOR ANOTHER METRIC
******************************************************************************;
*non_dioxin_like
*******************************************;
proc sort data=pcbs;
by descending ndl_all_pg;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ndl_all_cat_pg;
model ln_tsmean= ndl_all_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;

*non ortho NOTEQ
*******************************;
******multiplied by 100;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq_pg age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;
*cats;
proc sort data=pcbs;
by descending nont_cat_pg;
run;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat nont_cat_pg;
model ln_tsmean= nont_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= nont_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;

*teq
**********************************************;
PROC SORT DATA=PCBS;
BY DESCENDING TEQ_pg;
RUN;
****not adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat teq_cat_pg;
model ln_tsmean= teq_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct lipids/solution;
domain studypop;
run;


*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE 
MODEL 3: ADJUSTING FOR ANOTHER METRIC
******************************************************************************;
**ndl adjusted for non-ortho;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq_pg lipids /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ndl_all_cat_pg;
model ln_tsmean= ndl_all_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq_pg lipids /clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct non_ortho_noteq_pg lipids /solution;
domain studypop;
run;


****non ortho adjusted for non-dioxin-like all;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ;
model ln_tsmean= non_ortho_NOTEQ_pg age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all_pg lipids /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat nont_cat_pg;
model ln_tsmean= nont_cat_pg age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all_pg lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= nont_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all_pg lipids /clparm solution;
domain studypop;
run;


****teq adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all_pg lipids /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat teq_cat_pg;
model ln_tsmean= teq_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all_pg lipids/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_cat_pg age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct lbxnepct lbxeopct lbxbapct lbxmopct ndl_all_pg lipids/solution;
domain studypop;
run;


**************************************************************************************
SENSITIVITY ANALYSIS 2: LIPID ADJUSTED, REMOVING NEUTROPHILS FROM THE MODEL
**************************************************************************************;
*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE (this did not make the final supplemental material)
MODEL 2: FULLY ADJUSTED BUT NOT ADJUSTING FOR ANOTHER METRIC
******************************************************************************;

*non_dioxin_like
*******************************************;
proc sort data=pcbs;
by descending ndl_all;
run;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ndl_all_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*non ortho NOTEQ
*******************************;
******multiplied by 100;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= non_ortho_noteq age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*cats;
proc sort data=pcbs;
by descending nont_cat;
run;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat nont_cat;
model ln_tsmean= nont_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= nont_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*teq
**********************************************;
PROC SORT DATA=PCBS;
BY DESCENDING TEQ;
RUN;
****not adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat teq_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct/solution;
domain studypop;
run;


*****************************************************************************
MULTIPLE REGRESSION: PERCENT CHANGE (TABLE 3)
MODEL 3: ADJUSTING FOR ANOTHER METRIC
******************************************************************************;
**ndl adjusted for non-ortho;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct non_ortho_noteq /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ndl_all_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct non_ortho_noteq /clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= ndl_all_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct non_ortho_noteq /solution;
domain studypop;
run;


****non ortho adjusted for non-dioxin-like all;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat ;
model ln_tsmean= non_ortho_NOTEQ age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat nont_cat;
model ln_tsmean= nont_cat age_cent age_sq LN_LBXCOT female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct ndl_all/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= nont_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;


****teq adjusted for non-dioxin-like;
proc surveyreg data=pcbs;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct ndl_all /clparm solution;
domain studypop;
run;
*cats;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat teq_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct ndl_all/clparm solution;
domain studypop;
run;
*ptrend;
proc surveyreg data=pcbs order=data;
cluster sdmvpsu;
strata sdmvstra;
weight wtspo2yr;
class race_cat bmi_cat3 edu_cat;
model ln_tsmean= teq_cat age_cent age_sq ln_lbxcot female male race_cat bmi_cat3 edu_cat
lbxwbcsi lbxlypct /*lbxnepct*/ lbxeopct lbxbapct lbxmopct ndl_all/solution;
domain studypop;
run;

*************************************************************
CORRELATION BETWEEN METRICS;
proc corr data=pcbs;
var ndl_all non_ortho_NOTEQ teq;
where studypop=1;
run;

************************************************************
DF CALCULATION;
proc freq data=pcbs;
table sdmvstra sdmvpsu;
where studypop=1;
run;


*create dataset;
data studypop; 
set pcbs (keep = Ridageyr age_cat bmxbmi bmi_cat3 smoke_cpn indfmpir Pir_cat dmdeduc2 edu_cat race_cat ridreth1 
riagendr male female smq040 smoke3cat yrssmoke numcigs smokepackyrs Lbxcot sddsrvyr wtspo2yr LBd052lc LBd066lc 
LBd074lc LBd087lc LBd099lc LBd101lc LBd105lc LBd110lc LBd118lc LBDPCBLC LBd128lc LBd138lc LBd146lc LBd149lc 
LBd151lc LBd153lc LBd156lc LBd157lc LBd167lc LBDHXCLC LBd170lc LBd172lc LBd177lc LBd178lc LBd180lc LBd183lc 
LBd187lc LBd189lc LBd194lc LBd195lc LBd196lc LBd199lc LBd206lc LBDTC2LC lbdtcdlc LBdd01lc LBdd02lc LBdd03lc 
LBdd04lc LBdd05lc LBdd07lc lbdf01lc lbdf02lc lbdf03lc lbdf04lc lbdf05lc lbdf06lc lbdf07lc lbdf08lc lbdf09lc 
lbdf10lc lbxpcbla lbxhxcla non_ortho_noteq ndl_all lbx074la lbx099la lbx138la lbx153la lbx170la lbx180la 
lbx187la lbx194la lbx196la lbx199la teq lbxtcdla lbxd01la lbxd02la lbxd03la lbxd04la lbxd05la LBXD07la lbxf01la 
Lbxf02la lbxf03la lbxf04la lbxf05la lbxf06la lbxf07la lbxf08la lbxf09la lbxpcbla lbxhxcla lbx105la lbx118la 
lbx156la lbx157la lbx167la lbx189la wtspo2yr studypop ndl_all_cat NONT_cat teq_cat tsmean100 telomean cotinine_cat
lbxcot sdmvpsu sdmvstra mcq220 age_cent age_sq ndl_all_cat nont_cat teq_cat lbxwbcsi lbxlypct lbxnepct lbxeopct 
lbxbapct lbxmopct LBd052lc LBd066lc LBd074lc LBd087lc LBd099lc LBd101lc LBd105lc LBd110lc LBd118lc LBDPCBLC LBd128lc 
LBd138lc LBd146lc LBd149lc LBd151lc LBd153lc LBd156lc LBd157lc LBd167lc LBDHXCLC LBd170lc LBd172lc LBd177lc 
LBd178lc LBd180lc LBd183lc LBd187lc LBd189lc LBd194lc LBd195lc LBd196lc LBd199lc LBd206lc LBDTC2LC lbdtcdlc LBdd01lc LBdd02lc LBdd03lc LBdd04lc LBdd05lc LBdd07lc lbdf01lc lbdf02lc lbdf03lc 
lbdf04lc lbdf05lc lbdf06lc lbdf07lc lbdf08lc lbdf09lc lbdf10lc lipids);
where studypop = 1;
run;

proc export data=work.studypop
   outfile='C:\Users\Lizzy\OneDrive\Columbia\Summer 2018\MixturesWorkshop\Data\studypop.csv'
   dbms=csv
   replace;
run;
