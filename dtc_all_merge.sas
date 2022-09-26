*Chequala Fuller, Taylor Mack, Monica Cao, Jomaica Alfiler;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program reads in CHE, MSA, SEQ, SALES, DLTT, and DLC and merges the clean data for NOA.;


*call out the file path and read in the data file;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
libname tmp2 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
libname tmp3 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
libname tmp4 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;


*pull in cleaned CHE files;
data a1; set tmp1.CHE2000 tmp1.CHE2001 tmp1.CHE2002 tmp1.CHE2003; 
GVKEY2 = GVKEY * 1;
keep GVKEY2 CUSIP CHE FDYEAR;		*remove SALE since handled separately;
data a2; set a1;
proc sort; by GVKEY2 FDYEAR;

*pull in cleaned MSA files;
data a3; set tmp1.MSA2000 tmp1.MSA2001 tmp1.MSA2002 tmp1.MSA2003; 
GVKEY2 = GVKEY * 1;
keep GVKEY2 CUSIP MSA FDYEAR;		*remove SALE since handled separately;
data a4; set a3;
proc sort; by GVKEY2 FDYEAR;

*pull in cleaned SEQ files;
data a5; set tmp1.SEQ2000 tmp1.SEQ2001 tmp1.SEQ2002 tmp1.SEQ2003; 
GVKEY2 = GVKEY * 1;
keep GVKEY2 CUSIP SEQ FDYEAR;		*remove SALE since handled separately;
data a6; set a5;
proc sort; by GVKEY2 FDYEAR;

*pull in cleaned DLTT files;
data a7; set tmp1.DLTT2000 tmp1.DLTT2001 tmp1.DLTT2002 tmp1.DLTT2003; 
GVKEY2 = GVKEY * 1;
keep GVKEY2 CUSIP DLTT FDYEAR;		*remove SALE since handled separately;
data a8; set a7;
proc sort; by GVKEY2 FDYEAR;

*pull in cleaned DLC files;
data a9; set tmp1.DLC2000 tmp1.DLC2001 tmp1.DLC2002 tmp1.DLC2003;
GVKEY2 = GVKEY * 1; 
keep GVKEY2 CUSIP DLC FDYEAR;		*remove SALE since handled separately;
data a10; set a9;
proc sort; by GVKEY2 FDYEAR;

*merge all cleaned NOA data into a new dataset;
data a11;
merge a2 a4 a6 a8 a10;
by GVKEY2 FDYEAR;

*check point: check the data;
proc print data = a11(obs = 1000); run;

data a12; set a11;
if CHE ne ".";
if MSA ne "."; 
if SEQ ne ".";
if DLTT ne ".";
if DLC ne ".";

data a13; set a12;
data tmp1.dtc_noa_merged; set a13;
proc means; run;


*pull in cleaned SALES files;
data a14; set tmp2.SALE2000 tmp2.SALE2001 tmp2.SALE2002 tmp2.SALE2003; 
keep GVKEY2 CUSIP SALE FDYEAR;
data a15; set a14;
proc sort; by GVKEY2 FDYEAR;

proc print data = a15(obs = 5000); run;

*check point: check the data;
proc print data = a16(obs = 7000); run;

data a16; set a15;
if SALE ne ".";

data a17; set a16;
keep GVKEY2 CUSIP SALE FDYEAR;		
data tmp2.dtc_sale_merged; set a17;
proc means; run;


*pull in cleaned RET files;
data a18; set tmp3.RET2000 tmp3.RET2001 tmp3.RET2002 tmp3.RET2003; 
data a19; set a18;
proc sort; by GVKEY2 FDYEAR;

proc print data = a19(obs = 5000); run;


data a20; set a19;
if RET ne ".";

data a21; set a20;
data tmp3.dtc_return_merged; set a21;
proc means; run;


*merge all cleaned data into a new dataset;
data a22;
merge a2 a4 a6 a8 a10 a16 a20;
by GVKEY2 FDYEAR;

*check point: check the data;
proc print data = a22(obs = 5000); run;


data a23; set a22;
if CHE ne ".";
if MSA ne "."; 
if SEQ ne ".";
if DLTT ne ".";
if DLC ne ".";
if SALE ne ".";
if RET ne ".";

proc print data = a23(obs = 5000); run;


data a24; set a23;
data tmp4.dtc_all_combined; set a24;
proc means; run;


*check point: check the data;
proc print data = a25(obs = 5000); run;
