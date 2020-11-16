#!/bin/sh
#$ -V
#$ -cwd
#$ -S /bin/bash
#$ -N celegansk96
#$ -o $JOB_NAME.o$JOB_ID
#$ -e $JOB_NAME.e$JOB_ID
#$ -q omni
#$ -pe mpi 36
#$ -P quanah

#Load the necessary dependency software
module load intel impi abyss

#Define k-mer size
k=96

#Define your working directory name
WORKDIR="celegans-k"$k

#Go to your abyss directory, which should already have been created
cd /lustre/work/apruthi/abyss

#Identify your data directory, which should already have been created. DATA is now a variable that can be used to signal this directory rather than typing the path over and over.
DATA=/lustre/work/apruthi/abyss/data

#Create your working directory
mkdir $WORKDIR
#Go to your working directory
cd $WORKDIR

###Line-by-line explanation of the next command
#Run abyss-pe with a k-mer size of 'k' and using 36 processors.
#Output data should be placed in a directory called 'cehybridk'<kmersize>
#Use two paired end libraries, a and b.
#Use two long read libraries, a and b.
#Define paired end library a, pea, and give the location of the files.
#Define paired end library b, peb, and give the location of the files.
#Define long read library a, longa, and give the location of the files.
#Define long read library b, longb, and give the location of teh files.
abyss-pe k=$k np=36 name="cehybridk"$k \
        lib='pea peb' \
        long='longa longb' \
        pea="$DATA/celegans/H9_S5_L001_R1_001.fastq.gz
        $DATA/celegans/H9_S5_L001_R2_001.fastq.gz" \
        peb="$DATA/celegans/N2_A15_USD16081291_HG2G3ALXX_L8_1.fastq.gz
        $DATA/celegans/N2_A15_USD16081291_HG2G3ALXX_L8_2.fastq.gz" \
        longa="$DATA/celegans/nanopore_him9.tar.gz" \
        longb="$DATA/celegans/nanopore_N2.tar.gz"
