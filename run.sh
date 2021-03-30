fasta_length -i GVD_sequences.fa |sort -rnk2 > GVD_sequences.sort.len
fasta_length -i GPD_sequences.fa |sort -rnk2 > GPD_sequences.sort.len


makeblastdb -in GVD_sequences.fa -out GVD_sequences.fa -dbtype nucl
makeblastdb -in GPD_sequences.fa -out GPD_sequences.fa -dbtype nucl


mkdir Temp
split_fa.pl s 100 GPD_sequences.fa Temp/GPD
split_fa.pl s 100 GVD_sequences.fa Temp/GVD


find Temp/GPD* |awk '{print "blastn -query "$0" -db GPD_sequences.fa -out "$0".m8 -outfmt 6 -evalue 1e-10 -num_alignments 999999 -word_size 16 -num_threads 20"}' |split -d -l 10 - Temp/r1.sh ; find Temp/r1.sh* | awk '{print "nohup sh "$0" &"}' |sh
find Temp/GVD* |awk '{print "blastn -query "$0" -db GVD_sequences.fa -out "$0".m8 -outfmt 6 -evalue 1e-10 -num_alignments 999999 -word_size 16 -num_threads 20"}' |split -d -l 25 - Temp/r2.sh ; find Temp/r2.sh* | awk '{print "nohup sh "$0" &"}' |sh


find Temp/*.m8 |awk '{print "perl blast_cvg.pl "$0" "$0".cvg"}' |split -d -l 4 - Temp/r3.sh ; find Temp/r3.sh* | awk '{print "nohup sh "$0" &"}' |sh


cat Temp/GPD*cvg > GPD.cvg
cat Temp/GVD*cvg > GVD.cvg


perl blast_cluster.v2.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c75.uniq 75 95
perl blast_cluster.v2.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c70.uniq 70 95
perl blast_cluster.v2.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c60.uniq 60 95
perl blast_cluster.v2.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c50.uniq 50 95
perl blast_cluster.v2.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c40.uniq 40 95
perl blast_cluster.v2.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c75.uniq 75 95
perl blast_cluster.v2.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c70.uniq 70 95
perl blast_cluster.v2.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c60.uniq 60 95
perl blast_cluster.v2.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c50.uniq 50 95
perl blast_cluster.v2.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c40.uniq 40 95




perl blast_cluster.v3.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c75.set 75 95
perl blast_cluster.v3.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c70.set 70 95
perl blast_cluster.v3.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c60.set 60 95
perl blast_cluster.v3.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c50.set 50 95
perl blast_cluster.v3.pl GPD_sequences.sort.len GPD.cvg GPD.i95_c40.set 40 95
perl blast_cluster.v3.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c75.set 75 95
perl blast_cluster.v3.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c70.set 70 95
perl blast_cluster.v3.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c60.set 60 95
perl blast_cluster.v3.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c50.set 50 95
perl blast_cluster.v3.pl GVD_sequences.sort.len GVD.cvg GVD.i95_c40.set 40 95


#seqkit: https://github.com/shenwei356/seqkit
grep '^0' GPD.i95_c70.uniq  |sed -e 's/.*>//' -e 's/\.* \*$//' |seqkit grep -f - GPD_sequences.fa > GPD_i95_c70.uniq.fa
grep '^0' GPD.i95_c75.uniq  |sed -e 's/.*>//' -e 's/\.* \*$//' |seqkit grep -f - GPD_sequences.fa > GPD_i95_c75.uniq.fa
