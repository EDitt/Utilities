#PBS -S /bin/bash
#PBS -q batch
#PBS -N Concatenate_S_AfricaSeqs
#PBS -l nodes=1:ppn=6
#PBS -l walltime=124:00:00
#PBS -l mem=20gb
#PBS -M dittmare@gmail.com
#PBS -m abe
#PBS -t 1-10


###Script used for merging South_African_seqs

SAMPLELIST="/scratch/eld72413/SAM_seq/South_Africa_seqs/To_merge_list.txt"

OUTPUTDIR="/scratch/eld72413/SAM_seq/South_Africa_seqs/Merged"

dir=$(sed -n ${PBS_ARRAYID}p $SAMPLELIST)

if [[ -d "$dir" ]]; then
	name=$(basename ${dir})
	cd $dir
	for f1 in `find -maxdepth 1 -name "*R1_*" | sort -V`; do
		zcat $f1 >> $OUTPUTDIR/"$name"_R1.fastq.gz
	done
	for f2 in `find -maxdepth 1 -name "*R2_*" | sort -V`; do
		zcat $f2 >> $OUTPUTDIR/"$name"_R2.fastq.gz
	done
else
	echo "$dir is not a directory"
fi
