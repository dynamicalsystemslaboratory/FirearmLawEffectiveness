This folder contain the scripts for analysis of time series to test hypotheses and replicate the results presented in the manuscript.


## processed-data
This folder contains the processed time series which are loaded by the main.m script. These data are the same as the ones inside the data-processing/processed-data folder.


## scripts
- main.m: reads the time series in processed-data and computes transfer entropy and partial correlations between time series, considering interaction delays ranging from 0 to 11 months.
- compute_entropy.m: computes the entropy of multiple time series of the same length.
- compute_transfer_entropy.m: computes transfer entropy between two time series and performs a permutation test.
- correct_pvals.m: corrects delay analyses for multiple comparisons using the False Discovery Rate method.

To replicate our results, run the main.m script only.

