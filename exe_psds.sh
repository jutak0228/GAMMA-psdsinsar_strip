#!/bin/bash

# you prepare zip files and DEM file into /input_files_orig

##########################################################################
# [flags] 
##########################################################################
part_01="off"			 # [1] unzip raw data 
part_02="off"			 # [2] make SLC
part_03="off"		 	 # [3] coregistration
part_04="off"			 # [4] Prepare DEM and geocode reference
part_05="off"			 # [5] Crop the area of interest
part_06="off"			 # [6] Compute the average image
part_07="off"			 # [7] Prepare DEM, geocode including refinement, produce geocoded average image, prepare height map in RDC coordinates
### Parts 6 to 9: generation of the combined multi-reference stack ###
part_08="off"			 # [8] Generate multi-look differential interferometric phases
part_09="off"			 # [9] Generate single-pixel (PSI) differential interferometric phases
part_10="off"			 # [10] Combined PSI and multi-look lists and phases into one combined vector data set and generate pmask files documenting the origin of a value (single pixel or multi-look)
part_11="off"			 # [11] Reference point selection
### Parts 11 to 13: unwrap differential phase, estimate atmospheric phases, calculate height correction and calculate a mask
part_12="off"		 	 # [13] Determine atmospheric phases using multi-reference stack (using multi_def_pt)
part_13a="off"		 	 # [14a] Estimate height correction and update atmospheric phases using multi-reference stack
part_13b="off"		 	 # [14b] Update height corrections and atmospheric phases using multi-reference stack
part_13c="off"		 	 # [14c] Update height corrections and atmospheric phases using multi-reference stack
part_14="off"			 # [15] Update height corrections and atmospheric phases and estimate a deformation rate
part_15="off"			 # [16] Phases are converted into a deformation time series and atmospheric phases
part_16="off"			 # [17] Some comparisons and considerations
part_17="off"			 # [18] Results

####################################################################################
# setting parameters
####################################################################################
work_dir="/home/jutak/data/inumodori/psdsinsar_strip"
python="${work_dir}/python"
shell="${work_dir}/shell"
gamma_mod="${work_dir}/gamma_mod"
config="${gamma_mod}/makeslc.conf" # configuration file (please select satellite type)

#* Parameter Setting
ref_date="YYYYMMDD" # registration master date
polar="HH" # target polarization (HH, HV, VV, VH)
rlks="4" # range look number for interferometry
azlks="4" # azimuth look number for interferometry
dem_name="XXXXXX" # dem name for output
delta_t_max="-" # maximum number of days between passes
delta_n_max="3" # maximum scene number difference between passes
cc_thres_ds="0.1" # default: 0.1 --> glacier areas, layover and shadow areas, water surfaces and forests are below thres.
th_spcc="0.32" # default: 0.32 --> select ps points with spectral coherence 
th_msr="1.5" # default: 1.5 --> select ps points with dispersion index
ref_point="XXXXX" # select reference point which is nearby point and has a higher backcatter than previous point

####################################################################################
# ps-dsinsar process
####################################################################################
if [ "${part_01}" = "on" ];then bash ${shell}/part01.sh ${work_dir} ${config}; fi
if [ "${part_02}" = "on" ];then bash ${shell}/part02.sh ${work_dir} ${config} ${python}; fi
if [ "${part_03}" = "on" ];then bash ${shell}/part03.sh ${work_dir} ${ref_date}; fi
if [ "${part_04}" = "on" ];then bash ${shell}/part04.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${dem_name}; fi
if [ "${part_05}" = "on" ];then bash ${shell}/part05.sh ${work_dir} ${ref_date} ${rlks} ${azlks}; fi
if [ "${part_06}" = "on" ];then bash ${shell}/part06.sh ${work_dir} ${ref_date} ${rlks} ${azlks}; fi
if [ "${part_07}" = "on" ];then bash ${shell}/part07.sh ${work_dir} ${ref_date} ${dem_name}; fi
if [ "${part_08}" = "on" ];then bash ${shell}/part08.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${delta_t_max} ${delta_n_max} ${cc_thres_ds}; fi
if [ "${part_09}" = "on" ];then bash ${shell}/part09.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${th_spcc} ${th_msr}; fi
if [ "${part_10}" = "on" ];then bash ${shell}/part10.sh ${work_dir} ${ref_date} ${rlks} ${azlks}; fi
if [ "${part_11}" = "on" ];then bash ${shell}/part11.sh ${work_dir} ${ref_date} ${rlks} ${azlks}; fi
if [ "${part_12}" = "on" ];then bash ${shell}/part12.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point}; fi
if [ "${part_13a}" = "on" ];then bash ${shell}/part13a.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point}; fi
if [ "${part_13b}" = "on" ];then bash ${shell}/part13b.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point}; fi
if [ "${part_13c}" = "on" ];then bash ${shell}/part13c.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point}; fi
if [ "${part_14}" = "on" ];then bash ${shell}/part14.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point}; fi
if [ "${part_15}" = "on" ];then bash ${shell}/part15.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point} ${dem_name}; fi
if [ "${part_16}" = "on" ];then bash ${shell}/part16.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point} ${dem_name}; fi
if [ "${part_17}" = "on" ];then bash ${shell}/part17.sh ${work_dir} ${ref_date} ${rlks} ${azlks} ${ref_point} ${dem_name}; fi
