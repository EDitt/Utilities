# A script for concatenating SAM sequence files for downstream sequence handling

#PBS -S /bin/bash
#PBS -q batch
#PBS -N Concatenate
#PBS -l nodes=1:ppn=6
#PBS -l walltime=24:00:00
#PBS -l mem=20gb

#PBS -M dittmare@gmail.com
#PBS -m abe

cd /scratch/eld72413/SAM_seq/

for d in *PPN*/; do
if [[ -d "$d" ]]; then
name=${d%%/}""
for f1 in `ls "$d"*R1.fastq.gz`; do
if [[ -f "$f1" ]]; then
f2=${f1%%1.fastq.gz}"2.fastq.gz"
echo "Concatenating $name R1"
zcat $f1 >> /scratch/eld72413/SAM_seq/merged/"$name"_R1.fastq.gz
echo "Concatenating $name R2"
zcat $f2 >> /scratch/eld72413/SAM_seq/merged/"$name"_R2.fastq.gz
fi
done
fi
done
