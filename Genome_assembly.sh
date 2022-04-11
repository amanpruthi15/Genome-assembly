# Genome assembly pipeline for Bryum argenteum using long and short reads data

#############################
### Draft genome assembly ###
#############################

#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=genome_assembly
#SBATCH --output=%x.o%j
#SBATCH --error=%x.e%j
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=128
#SBATCH --time=48:00:00

flye --nano-raw --genome-size 300m --threads 128 ./nanopore_reads.fq --out-dir ./

########################
### Genome polishing ###
########################

### Round1 ###

bwa index assembly.fasta

bwa mem -t 128 assembly.fasta /lustre/scratch/apruthi/Illumina/female_R1.fq /lustre/scratch/apruthi/Illumina/female_R2.fq |\
  samtools view -Sb - -@ 128 |\
  samtools sort -@ 128  -o wgs.sorted.bam
 
 samtools index ./wgs.sorted.bam
 
 java -Xmx512G -jar ~/pilon-1.24.jar --genome ./assembly.fasta --changes --frags ./wgs.sorted.bam --threads 128 --output ./ |\
  tee ./round1.fasta
  
### Round2 ###

bwa index round1.fasta

bwa mem -t 128 round1.fasta /lustre/scratch/apruthi/Illumina/female_R1.fq /lustre/scratch/apruthi/Illumina/female_R2.fq |\
  samtools view -Sb - -@ 128 |\
  samtools sort -@ 128  -o wgs2.sorted.bam
 
 samtools index ./wgs2.sorted.bam
 
java -Xmx512G -jar ~/pilon-1.24.jar --genome ./round1.fasta --changes --frags ./wgs.sorted.bam --threads 128 --output ./ |\
  tee ./round2.fasta

mv ./round2.fasta bryum_genome.fasta

##### THE END ###### 
