#PBS -S /bin/bash
#PBS -q batch
#PBS -N Change_SNtags_SAMheader
#PBS -l nodes=1:ppn=6
#PBS -l walltime=5:00:00
#PBS -l mem=10gb
#PBS -M dittmare@gmail.com
#PBS -m abe

### This script changes the SN SAM tag header lines
###	using a .txt file with the first column being the old SN name (and first part of filename)
###	and the second column the new SN name

module load SAMtools/1.10-GCC-8.2.0-2.31.1

# 1st column old name, 2nd column, new name:
KEY="/scratch/eld72413/Salty_Nut/CultivatedOnly/Plate1_InbredKEY.txt"

# Input BAM files
RH_INPUT="/scratch/eld72413/Salty_Nut/CultivatedOnly/SNPcalling/Plate1_Bams"

# Output (reheadered) BAM files
RH_OUTPUT="/scratch/eld72413/Salty_Nut/CultivatedOnly/SNPcalling/Plate1_Bams/Test_Rehead"

while read line; do
SN1=$(echo "$line" | awk '{print $1}')
SN2=$(echo "$line" | awk '{print $2}')
file=$(find $RH_INPUT -maxdepth 1 -name "$SN1[!0-9]*.bam")
name=$(basename ${file%%.bam}"") #sample ID
echo "Changing sample name from $SN1 to $SN2 for sample $name"
samtools view -H ${file} | sed -e "s/SM:${SN1}/SM:${SN2}/g" | samtools reheader - $file > ${RH_OUTPUT}/${name}_reheadered.bam
done < $KEY

