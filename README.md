# GAMMA-psdsinsar_strip

This GAMMA RS script is for IPTA analysis for StripMap datasets

## Requirements

GAMMA Software Modules:

The GAMMA software is grouped into four main modules:
- Modular SAR Processor (MSP)
- Interferometry, Differential Interferometry and Geocoding (ISP/DIFF&GEO)
- Land Application Tools (LAT)
- Interferometric Point Target Analysis (IPTA)

The user need to install the GAMMA Remote Sensing software beforehand depending on your OS.

For more information: https://gamma-rs.ch/uploads/media/GAMMA_Software_information.pdf

## Process step

Pre-processing: input zip files and DEM file into /input_files_orig

Note: it should be processed orderly from the top (part_00).

It needs to change the mark "off" to "on" when processing.

- part_01="off" # [1] unzip raw data
- part_02="off"	# [2] make SLC
- part_03="off"	# [3] coregistration
- part_04="off"	# [4] Prepare DEM and geocode reference
- part_05="off"	# [5] Crop the area of interest
- part_06="off"	# [6] Compute the average image
- part_07="off"	# [7] Prepare DEM, geocode including refinement, produce geocoded average image, prepare height map in RDC coordinates
- Parts 6 to 9: generation of the combined multi-reference stack ###
- part_08="off"	# [8] Generate multi-look differential interferometric phases
- part_09="off"	# [9] Generate single-pixel (PSI) differential interferometric phases
- part_10="off"	# [10] Combined PSI and multi-look lists and phases into one combined vector data set and generate pmask files documenting the origin of a value (single pixel or multi-look)
- part_11="off"	# [11] Reference point selection
- Parts 11 to 13: unwrap differential phase, estimate atmospheric phases, calculate height correction and calculate a mask
- part_12="off"	# [13] Determine atmospheric phases using multi-reference stack (using multi_def_pt)
- part_13a="off" # [14a] Estimate height correction and update atmospheric phases using multi-reference stack
- part_13b="off" # [14b] Update height corrections and atmospheric phases using multi-reference stack
- part_13c="off" # [14c] Update height corrections and atmospheric phases using multi-reference stack
- part_14="off" # [15] Update height corrections and atmospheric phases and estimate a deformation rate
- part_15="off"	# [16] Phases are converted into a deformation time series and atmospheric phases
- part_16="off"	# [17] Some comparisons and considerations
- part_17="off"	# [18] Results
