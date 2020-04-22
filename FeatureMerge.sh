#!/bin/bash

set -o pipefail

### Script to merge intervals containing features of interest from Genome Annotation File

####################################
########### DEPENDENCIES ###########
####################################

module load BEDOPS/2.4.30

module load BEDTools/2.29.2-GCC-8.2.0-2.31.1

####################################
##### USER-SUPPLIED VARIABLES ######
####################################

#	Genome Annotation File
GEN_ANN="/scratch/eld72413/Ha412HOv2.0/Ha412HOv2.0-20181130.gff3"
#GEN_ANN="/scratch/eld72413/Ha412HOv2.0/Ha412HOv2.0-20181130.gtf"

# What feature to capture? (Gene, Exon, etc)
FEATURE="gene"
#FEATURE="exon"

#	Maximum distance between features (in bp) to be merged?
INT_DIST=500000

# Where do you want output files?
OUTPUTDIR="/scratch/eld72413/Salty_Nut/CultivatedOnly/SNPcalling/GenicRegionsTests"

# Name for final output .bed file (no .bed extension here)
OUT_NAME="GFF_Test1"

####################################
########## INTERVALS CODE ##########
####################################

# GFF3 or GTF file?
ANN_ext="$(basename ${GEN_ANN##*.})"

if [[ "$ANN_ext" == "gff3" ]]; then
	echo "Merging $FEATURE regions within $INT_DIST from GFF3 file"
	gff2bed < ${GEN_ANN} > ${OUTPUTDIR}/BED_Convert.bed
elif [[ "$ANN_ext" == "gtf" ]]; then
	echo "Merging $FEATURE regions within $INT_DIST from GTF file"
	gtf2bed < ${GEN_ANN} > ${OUTPUTDIR}/BED_Convert.bed
else
	echo "The genome annotation file does not appear to be a recognized file format, exiting..."
	#exit 1
fi


#echo "$COMMAND < ${GEN_ANN}" | head
awk -v var="${FEATURE}" '{if ($8 == var) {print $0}}' ${OUTPUTDIR}/BED_Convert.bed | \

bedtools merge -i stdin -d ${INT_DIST} > ${OUTPUTDIR}/${OUT_NAME}.bed

rm ${OUTPUTDIR}/BED_Convert.bed
