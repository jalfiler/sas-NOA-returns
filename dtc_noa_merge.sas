*Chequala Fuller;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program reads in CHE, MSA, SEQ, SALES, DLTT, and DLC and merges the clean data for NOA.;


*call out the file path and read in the data file;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270';
libname tmp2 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

*pull in cleaned CHE files;
data a1; set tmp2.CHE2000 tmp2.CHE2001 tmp2.CHE2002 tmp2.CHE2003; 
data a2; set a1;
proc sort; by GVKEY FDYEAR;

*pull in cleaned MSA files;
data a3; set tmp2.MSA2000 tmp2.MSA2001 tmp2.MSA2002 tmp2.MSA2003; 
data a4; set a3;
proc sort; by GVKEY FDYEAR;

*pull in cleaned SEQ files;
data a5; set tmp2.SEQ2000 tmp2.SEQ2001 tmp2.SEQ2002 tmp2.SEQ2003; 
data a6; set a5;
proc sort; by GVKEY FDYEAR;

*pull in cleaned LSALES (lag sales) files;
data a7; set tmp2.SALE2000 tmp2.SALE2001 tmp2.SALE2002 tmp2.SALE2003; 
data a8; set a7;
proc sort; by GVKEY FDYEAR;

*pull in cleaned DLTT files;
data a9; set tmp2.DLTT2000 tmp2.DLTT2001 tmp2.DLTT2002 tmp2.DLTT2003; 
data a10; set a9;
proc sort; by GVKEY FDYEAR;

*pull in cleaned DLC files;
data a11; set tmp2.DLC2000 tmp2.DLC2001 tmp2.DLC2002 tmp2.DLC2003; 
data a12; set a11;
proc sort; by GVKEY FDYEAR;

proc print data = a12(obs = 500); run;

*merge all data into a new dataset;
data a13;
merge a2 a4 a6 a8 a10 a12;
by GVKEY FDYEAR;

*check point: check the data;
*proc print data = a13(obs = 5000); *run;

data a14; set a13;
if CHE ne ".";
if MSA ne "."; 
if SEQ ne ".";
if SALE ne ".";
if DLTT ne ".";
if DLC ne ".";

data a15; set a14;
data tmp2.dtc_noa_merged; set a15;
proc means; run;
