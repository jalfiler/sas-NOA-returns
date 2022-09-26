*Chequala Fuller;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program cleans the SALES raw data by identifying missing observations and removing/replacing them ;
*to omit any outliers or skewness in preparation of preparing data for the model and overall analysis.;


*call out the file path and read in the data file;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270';
libname tmp2 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

*read in data file;
data a1; set tmp2.dtc_sales;
FDYEAR = year(DATADATE);
GVKEY2 = GVKEY * 1;

*proc print data = a1(obs = 500); *run;
*proc means; *run;

*select variables for analysis;
data a2; set a1;
keep GVKEY2 DATADATE CUSIP SALE FDYEAR;

*proc print data = a2(obs = 5000); run;

*identify missing observations;
data a3; set a2;
proc univariate; var SALE; run;


data a4; set a3;
if SALE ne ".";

*proc print data = a4(obs = 5000); *run;

*show the outliers;
data a5; set a4;
proc univariate; var SALE; run;


*proc print data = a5(obs = 5000); *run;


*deal with outliers one year at a time;
data a6; set a5;
data a7; set a6;
if FDYEAR = 2000;
if FDYEAR = 2001;
if FDYEAR = 2002;
if FDYEAR = 2003;


*proc print data = a7(obs = 5000); *run;


proc univariate noprint; var SALE;
output p1 = M1SALE p99 = M99SALE out = trim1;


data a8;
if _N_ = 1 then set trim1;
set a7;

*two additional variables have been created (M1AT and M99AT);
*check point: data has been adjusted so it is good to print and check every time an adjustment is made.;
*proc print data = a8(obs = 5000); *run;

data a9; set a8;

*remove the outliers;
data a10; set a9;
if SALE > M99SALE then SALE = M99SALE;
if SALE < M1SALE then SALE = M1SALE;

*proc print data = a10(obs = 5000); *run;

*remove unneccessary data;
data a11; set a10;
drop M1SALE M99SALE;


*proc print data = a11(obs = 5000); *run;


proc univariate; var SALE; run;


data a12; set a11;
data a13; set a12;

proc print data = a13(obs = 5000); run;


*create temporary files of cleaned data by year one variable at a time;
data tmp2.SALE2000; set a13;
data tmp2.SALE2001; set a13;
data tmp2.SALE2002; set a13;
data tmp2.SALE2003; set a13;
