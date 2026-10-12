# brainbehaviorcoupling

Overview:

This repository contains the code and data associated with the scientific publication:

Rhythmic brain-behavior coupling in the visuo-motor system: theta-band coherence links saccades and oculomotor brain regions

Authors: Yvonne Buschermöhle, Jan-Ole Radecke, Andreas Sprenger, Tim Erdbrügger, Till R. Schneider, Rebekka Lencer, Carsten H. Wolters, Joachim Gross

Journal: currently under review in Communications Biology

DOI: 

Contents:

code/:          Code used for data processing and analysis.
source_data/:   source data underlying the main figures of the manuscript

The analysis was developed using Matlab (R2022b). The code uses the toolbox fieldtrip. 


How to reproduce the analysis: 

The code can be used to reproduce the analysis, if the necessary input data are available (see "Data availability"): 
Download or clone this repository.
Install the fieldtrip toolbox.
Make sure the required input data are available and the paths in the code are set properly.
In Matlab, run 
  1. code/run1_coherence.m
  2. code/run2_statistics.m 
The analysis produces the statistical results from our analysis. 


How to reproduce the figures: 

Download or clone this repository.
In Matlab, run code/plotcode.m
The data from source_data/ will be loaded and the main result figures of the paper will be reproduced. 


Data availability:

Raw data are protected by data privacy laws and can be made available by means of a formal data sharing agreement.


Citation:

If you use this code or data, please cite:

[Full bibliographic reference or DOI]

Contact

For questions about the code or analysis, contact yvonne.buschermoehle@uni-muenster.de.
