#!/bin/bash
#$ -V
#$ -cwd
#$ -S /bin/bash
#$ -N abyss
#$ -o $JOB_NAME.o$JOB_ID
#$ -e $JOB_NAME.e$JOB_ID
#$ -q omni
#$ -pe sm 10
#$ -P quanah

#Create and migrate to your working directory
mkdir /lustre/work/apruthi/abyss
cd /lustre/work/apruthi/abyss

#Load the necessary packages
module load intel/18.0.3.222 openmpi/1.10.7 abyss bwa samtools

#Create a list of k-mers to test assemblies
LIST="26 36 46 56 66 76 86 96"

#For every k-mer in that list, build an assembly in a dedicated directory
for k in $LIST
        do mkdir "ng_hybrid_k"$k
        cd "ng_hybrid_k"$k
        abyss-pe np=10 k=$k name="ng_hybrid_k"$k \
        in='/lustre/work/apruthi/unicycler/data/neisseriagonorrhoeae/short_reads_1.fastq.gz /lustre/work/apruthi/unicycler/data/neisseriagonorrhoeae/short_reads_2.fastq.gz' \
        long='longa' \
        longa='/lustre/work/apruthi/unicycler/data/neisseriagonorrhoeae/long_reads_high_depth.fastq.gz'
        cd ../
done
