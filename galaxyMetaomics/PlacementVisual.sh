# Rothamsted Research Metagenomic Pipeline.
# Placement Visualization.

# --------------------------------------------------------------------------------------------

# DESCRIPTION:
# This program takes as input a 'jplace' file, produced with the software 'pplacer', and
# outputs a graphic file (in one of PDF, BMP, JPEG, PNG or TIFF formats) displaying the
# placement of the Metagenome onto a Reference Tree. It uses the package 'ape' in the 
# 'R' environment to produce the graphics.
# For more information contact: elisa.loza@rothamsted.ac.uk

# ---------------------------------------------------------------------------------------------

# Copyright (C) Rothamsted Research, 2011-2013.

# Licensed under the GNU General Public License version 3.0 (the "License").

# You may obtain a copy of the License at <http://www.gnu.org/licenses/gpl-3.0.txt>.

# This program is free software: you can redistribute it and/or modify it under the terms 
# of the GNU General Public License as published by the Free Software Foundation, either 
# version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
# See the GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along with this program. 
# If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

# Date: 14/11/2012.

# ---------------------------------------------------------------------------------------------


#########################################################   SINTAXIS:   ##########################################################
#     $ chmod +x <path>/PlacementVisual.sh												   
#     $ <path>/PlacementVisual.sh <JPLACE_FILE> <READ_IDFIER> <GRAPHIC_FORMAT> <SCALE_BLOB> <SCALE_TIPID> <BINARIES_DIRECTORY>   
#                           <EXPERIMENT_DIRECTORY>                                                                     	   
#         where:														       	   
#		JPLACE_FILE: placement file produced in 'pplacer'									   
#		READ_IDFIER: a character or string of characters common to ALL the labels of the Metagenomic sequences   	   
#		GRAPHIC_FORMAT: one of PDF, BMP, JPEG, PNG or TIFF (case sensitive) specifying the graphic file format to output   
#		SCALE_BLOB: a positive value. 1: default scale; <1: reduce blob size; >1: augment blob size			   
#		SCALE_TIPID: a positive value. 1: default scale; <1: reduce tip label size; >1: augment tip label size		   
#	       BINARIES_DIRECTORY: directory that contains the R script called 'PlacementVisual.R'			       	   
#	       EXPERIMENT_DIRECTORY: directory that will contain the 'Output_PlacementVisual' directory				   
##################################################################################################################################

#!/bin/bash
echo "	  PlacementVisual.sh STARTS NOW"

if [ $# -lt 5 ]
then
	
	echo "$0 error: you must supply 5 arguments"

else

	# Read in the arguments
	echo "		1. Reading in the arguments..."
		jplace=$1
		readid=$2
		gformat=$3
		blobscale=$4
		tipscale=$5
		#BIN_DIR=$6
		#EXP_DIR=$6

		#OUT_DIR="$EXP_DIR/Output_PlacementVisual"
		#mkdir $OUT_DIR

	# Produce a visualization of the placement of the Metagenome onto the Reference Tree
	echo "		2. Producing a visualization of the placement of the Metagenome onto the Reference Tree..."
		# Link to required files for R call
		echo $jplace >./jplace.file.name
		echo $readid >./read.identifier
		echo $gformat >./graphic.format
		echo $blobscale >./scale.blob
		echo $tipscale >./scale.tipid
		ln -s ./jplace.file.name
		ln -s ./read.identifier
		ln -s ./graphic.format
		ln -s ./scale.blob
		ln -s ./scale.tipid
		R CMD BATCH --slave /home/data/galaxy-python/galaxy-dist/tools/metagenomics_decypher/PlacementVisual.r PlacementVisual.rout
		unlink jplace.file.name
		unlink read.identifier
		unlink graphic.format
		unlink scale.blob
		unlink scale.tipid

		#mv PlacementVisualGraph* $OUT_DIR

fi

echo "	  PlacementVisual.sh FINISHES NOW"

