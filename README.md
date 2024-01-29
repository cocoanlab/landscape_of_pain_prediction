# Decoding Pain: Uncovering the Factors that Affect Performance of Neuroimaging-Based Pain Models

This repository contains the codes and data which are used in the following paper.

> Dong Hee Lee, Sungwoo Lee, Choong-Wan Woo, Decoding Pain: Uncovering the Factors that Affect Performance of Neuroimaging-Based Pain Models, 2023, bioRxiv ([link](https://doi.org/10.1101/2023.12.22.573021))

## Dependencies
- CanlabCore toolbox ([link](https://github.com/canlab/CanlabCore))
- Mediation toolbox ([link](https://github.com/canlab/MediationToolbox))
- SPM12 ([link](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/))
- MATLAB Statistics and Machine Learning Toolbox ([link](https://www.mathworks.com/products/statistics.html))

## Usage
Below are the codes that allow you to generate the main figures in the manuscript.
- `fig_3_litearture_survey.m`
- `fig_4_literature_survey.R`
- `fig_5_litearture_survey.m`
- `fig_7_benchmarking_analysis.m`
- `fig_8_benchmarking_analysis.m`
- `fig_9_benchmarking_analysis.m`
- `fig_10_benchmarking_analysis.m`

To use these scripts, download all files and unzip the zipfile (i.e. data.zip). Open the script that you want to run in Matlab or R and set the current folder to the  working directory. Add the paths for the dependencies. The other functions (e.g., lpp_plot_boxplot.m) are necessary to create the main figures. Make sure that the functions have to be saved in the same directory with the main scripts.
