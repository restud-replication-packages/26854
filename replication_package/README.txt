This document describes the replication of Tables 1 and 2 and Figure 1,
and average standard errors referenced in Section 5.2

Computations were performed on 

R version 4.2.2 (2022-10-31)
Platform: aarch64-apple-darwin20 (64-bit)
Running under: macOS Ventura 13.1

The analysis requires randomForest package (version 4.7-1.1),
and readstata13 package (version 0.10.0)

0. The original data can be obtained at 
https://sites.google.com/site/nicolacetera and is stored in 
../replication_package/data/ subfolder.
The main data file is called wtbb_publicdata.dta; the file
wtbb_data_variable_list.xlsx file contains the description 
of all variables in wtbb_publicdata.dta

1. To creat the data file used in the paper run the script data_collection.r,
located in ../replication_package/code/ subfolder. 
This script creates cleaned_data.RData and puts it
in the ../replication_package/data/ subfolder. 

To run the script change the working directory to the location 
of the replication_package folder.

2. To replicate Table 1 and Figure 1 run analysis.r script
located in ../replication_package/code subfolder. 

To run the script change the working directory to the location 
of the replication_package folder.

The script results are summarized in table_1.txt located in
../replication_package/tables and in var_imp.pdf located in
 ../replication_package/figures.

3. To replicated Table 2 run simulation.r script located in
../replication_package/code subfolder. Expected running time
on average laptop is about two hours.

To run the script change the working directory to the location 
of the replication_package folder.

The script results are summarized in table_2.txt and st_errors.txt
located in ../replication_package/tables  subfolder.