*Chequala Fuller;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program cleans the data by identifying missing observations and removing/replacing them ;
*to omit any outliers or skewness in preparation of preparing data for the model and overall analysis.;


*call out the file path and read in the data file;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270';
libname tmp2 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

*read in data file;
data a1; set tmp2.dtc_noa;
FDYEAR = year(DATADATE);

proc print data = a1(obs = 5000); run;
proc means; run;

*select variables for analysis;
data a2; set a1;
keep GVKEY DATADATE CUSIP CHE MSA SEQ SALE DLTT DLC FDYEAR;

proc print data = a2(obs = 5000); run;

*identify missing observations;
data a3; set a2;
proc univariate; var CHE; run;
proc univariate; var MSA; run;
proc univariate; var SEQ; run;
proc univariate; var SALE; run;
proc univariate; var DLTT; run;
proc univariate; var DLC; run;


data a4; set a3;
if CHE ne ".";
if MSA ne "."; 
if SEQ ne ".";
if SALE ne ".";
if DLTT ne ".";
if DLC ne ".";


proc print data = a4(obs = 5000); run;


*show the outliers;
data a5; set a4;
proc univariate; var CHE; run;
proc univariate; var MSA; run;
proc univariate; var SEQ; run;
proc univariate; var SALE; run;
proc univariate; var DLTT; run;
proc univariate; var DLC; run;


proc print data = a5(obs = 5000); run;


*deal with outliers one year at a time;
data a6; set a5;
data a7; set a6;
if FDYEAR = 2000;
*if FDYEAR = 2001;
*if FDYEAR = 2002;
*if FDYEAR = 2003;


proc print data = a7(obs = 5000); run;


*proc univariate noprint; *var CHE;
*output p1 = M1CHE p99 = M99CHE out = trim1; *min (1%) and max (99%);

proc univariate noprint; var MSA;
output p1 = M1MSA p99 = M99MSA out = trim1;

*proc univariate noprint; *var SEQ;
*output p1 = M1SEQ p99 = M99SEQ out = trim1;

*proc univariate noprint; *var SALE;
*output p1 = M1SALE p99 = M99SALE out = trim1;

*proc univariate noprint; *var DLTT;
*output p1 = M1DLTT p99 = M99DLTT out = trim1;

*proc univariate noprint; *var DLC;
*output p1 = M1DLC p99 = M99DLC out = trim1;


data a8;
if _N_ = 1 then set trim1;
set a7;

*two additional variables have been created (M1AT and M99AT);
*check point: data has been adjusted so it is good to print and check every time an adjustment is made.;
proc print data = a8(obs = 5000); run;

data a9; set a8;

*remove the outliers;
data a10; set a9;
*if CHE > M99CHE then CHE = M99CHE;
*if CHE < M1CHE then CHE = M1CHE;

if MSA > M99MSA then MSA = M99MSA;
if MSA < M1MSA then MSA = M1MSA;

*if SEQ > M99SEQ then SEQ = M99SEQ;
*if SEQ < M1SEQ then SEQ = M1SEQ;

*if SALE > M99SALE then SALE = M99SALE;
*if SALE < M1SALE then SALE = M1SALE;

*if DLTT > M99DLTT then DLTT = M99DLTT;
*if DLTT < M1DLTT then DLTT = M1DLTT;

*if DLC > M99DLC then DLC = M99DLC;
*if DLC < M1DLC then DLC = M1DLC;


proc print data = a10(obs = 5000); run;

*remove unneccessary data;
data a11; set a10;
*drop M1CHE M99CHE;
drop M1MSA M99MSA;
*drop M1SEQ M99SEQ;
*drop M1SALE M99SALE;
*drop M1DLTT M99DLTT;
*drop M1DLC M99DLC;


proc print data = a11(obs = 5000); run;
*proc univariate; *var CHE; *run;
proc univariate; var MSA; run;
*proc univariate; *var SEQ; *run;
*proc univariate; *var SALE; *run;
*proc univariate; *var DLTT; *run;
*proc univariate; *var DLC; *run;




data a12; set a11;
data a13; set a12;


*create temporary files of cleaned data by year one variable at a time;
*data tmp2.CHE2000; *set a13;
*data tmp2.CHE2001; *set a13;
*data tmp2.CHE2002; *set a13;
*data tmp2.CHE2003; *set a13;

data tmp2.MSA2000; set a13;
*data tmp2.MSA2001; *set a13;
*data tmp2.MSA2002; *set a13;
*data tmp2.MSA2003; *set a13;

*data tmp2.SEQ2000; *set a13;
*data tmp2.SEQ2001; *set a13;
*data tmp2.SEQ2002; *set a13;
*data tmp2.SEQ2003; *set a13;

*data tmp2.SALE2000; *set a13;
*data tmp2.SALE2001; *set a13;
*data tmp2.SALE2002; *set a13;
*data tmp2.SALE2003; *set a13;

*data tmp2.DLTT2000; *set a13;
*data tmp2.DLTT2001; *set a13;
*data tmp2.DLTT2002; *set a13;
*data tmp2.DLTT2003; *set a13;

*data tmp2.DLC2000; *set a13;
*data tmp2.DLC2001; *set a13;
*data tmp2.DLC2002; *set a13;
*data tmp2.DLC2003; *set a13;

