# braineyecoupling

Overview: <br>
This repository contains the code and data associated with the scientific publication:

"Rhythmic brain-behavior coupling in the visuo-motor system: theta-band coherence links saccades and oculomotor brain regions"

Authors:<br>
Yvonne Buschermöhle, Jan-Ole Radecke, Andreas Sprenger, Tim Erdbrügger, Till R. Schneider, Rebekka Lencer, Carsten H. Wolters, Joachim Gross

Journal: <br>
currently under review in Communications Biology; preprint available

DOI: <br>
https://doi.org/10.21203/rs.3.rs-7757022/v1

Contents:<br>
code/:          Code used for data processing and analysis.<br>
source_data/:   source data underlying the main figures of the manuscript

The analysis was developed using Matlab (R2022b). The code uses the toolbox fieldtrip. 

How to reproduce the analysis: <br>
The code can be used to reproduce the analysis, if the necessary input data are available (see "Data availability"): <br>
Download or clone this repository.<br>
Install the fieldtrip toolbox.<br>
Make sure the required input data are available and the paths in the code are set properly.<br>
In Matlab, run <br>
  1. code/run1_coherence.m <br>
  2. code/run2_statistics.m <br>
The analysis produces the statistical results from our analysis. 

How to reproduce the figures: <br>
Download or clone this repository.<br>
In Matlab, run code/plotcode.m<br>
The data from source_data/ will be loaded and the main result figures of the paper will be reproduced. <br>

Data availability:<br>
Raw data are protected by data privacy laws and can be made available by means of a formal data sharing agreement.<br>

Citation: <br>
If you use this code or data, please cite:

Buschermöhle, Y., Radecke, J.-O., Sprenger, A., Erdbrügger, T., Schneider, T., Lencer, R., Wolters, C., Gross, J., 2025. Rhythmic brain-behavior coupling in the visuo-motor system: theta-band coherence links saccades and oculomotor brain region. Research Square [preprint]. https://doi.org/10.21203/rs.3.rs-7757022/v1

Contact:<br>
For questions about the code or analysis, contact yvonne.buschermoehle@uni-muenster.de.
