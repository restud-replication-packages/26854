This document describes the replication of Tables 1 and 2 and Figure 1,
and average standard errors referenced in Section 5.2

Computations were performed on 

R version 4.3.0 (2023-04-21 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19045)

The analysis requires the randomForest package (version 4.7-1.1),
and readstata13 package (version 0.10.0)

-----------------------------------------------------------------------------------------

1) Data Availability Statement

-----------------------------------------------------------------------------------------

The replication uses data from 

Nicola Lacetera, Mario Macis, and Robert Slonim. Will there be blood? incentives and dis-
placement effects in pro-social behavior. American Economic Journal: Economic Policy, 4
(1):186–223, 2012b.
32

The description of the data and the code for the original paper can be accessed at

Lacetera, Nicola, Macis, Mario, and Slonim, Robert. Replication data for: Will There Be Blood? Incentives and Displacement Effects in Pro-social Behavior. Nashville, TN: American Economic Association [publisher], 2012. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2019-10-13. https://doi.org/10.3886/E114774V1

The data itself is available at:

Nicola Lacetera, Mario Macis, and Robert Slonim. Replication data for: Will there be
blood? incentives and displacement effects in pro-social behavior, 2023. URL https:
//drive.google.com/file/d/1D0h8d29oOt7kpuH9bBBweAmTeIDd6IS7/view.

This data is provided as a part of the package and is located in
../replication_package/data/ subfolder.

This dataset is in the public domain.

The primary data file is called wtbb_publicdata.dta; the file
wtbb_data_variable_list.xlsx file contains the description 
of all variables in wtbb_publicdata.dta

-----------------------------------------------------------------------------------------

2) Replication instructions

-----------------------------------------------------------------------------------------


1. To create the data file used in the paper, run the script data_collection.r,
located in ../replication_package/code/ subfolder. 
This script creates cleaned_data.RData and puts it
in the ../replication_package/data/ subfolder. 



To run the script change the working directory to the location 
of the replication_package folder.

2. To replicate Table 1 and Figure 1, run analysis.r script
located in ../replication_package/code subfolder. 

To run the script change the working directory to the location 
of the replication_package folder.

The script results are summarized in table_1.txt, located in
../replication_package/tables and in var_imp.pdf located in
 ../replication_package/figures.

3. To replicate Table 2, run the simulation.r script located in
../replication_package/code subfolder. The expected running time
on an average laptop is about two hours.

To run the script change the working directory to the location 
of the replication_package folder.

The script results are summarized in table_2.txt and st_errors.txt
located in ../replication_package/tables  subfolder.

-----------------------------------------------------------------------------------------

3) Replication on M1 chips 

-----------------------------------------------------------------------------------------

We are aware of a minor discrepancy in the replication results using other platforms. 
In particular, the results in Table 1 change slightly if the code is run on the machine 
with the following configuration:

R version 4.2.2 (2022-10-31)
Platform: aarch64-apple-darwin20 (64-bit)
Running under: macOS Ventura 13.1

These results are reported in ../replication_package/tables/table_1_M1_results.txt

To the best of our knowledge, all replications on Intel-based chips return results 
presented in the paper. 


