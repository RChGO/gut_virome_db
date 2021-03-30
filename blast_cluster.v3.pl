#!/usr/bin/perl
use warnings;
use strict;

############################################################
### Author: Shenghui Li, lsh2@qq.com                     ###
### Version: 1.0 (Nov. 1st, 2020)                        ###
############################################################

die "perl $0 [in.len.sort] [in.blast.cvg] [out.fasta] [%cvg] [%iden]\n" unless @ARGV == 5;
my ($len, $in_f, $out_f, $cov, $iden) = @ARGV;
die "Overlap In-Output...\n" if $in_f eq $out_f;
### print STDERR "Program $0 Start...\n";

my $similar = $iden;
my $coverage = $cov;

###
my (@seq, %len, %cvg, %idt) = ();
my $curr = 9999999;

open IN, $len or die $!;
while(<IN>){
	chomp;
	my @s = split /\s+/;
	
	die "$len MUST BE SORTED.\n" if $s[-1] > $curr;
	$curr = $s[-1];

	push @seq, $s[0];
	$len{$s[0]} = $s[1];
}
close IN;

###
open IN, $in_f or die $!;
while(<IN>){
	chomp;
	my @s = split /\s+/;
	
	next if $s[0] eq $s[1];
	next unless exists $len{$s[0]} and exists $len{$s[1]}; ###
	next unless $len{$s[1]} >= $len{$s[0]}; ###
	next unless $s[3] >= $similar;

	my $cvg = $s[2] / $len{$s[0]} * 100;
	next unless $cvg >= $coverage;
	$cvg{$s[0]}{$s[1]} = $cvg;
	$idt{$s[0]}{$s[1]} = $s[3];
}
close IN;

###
my (%clust, %list) = ();
my $num = 0;

open OT, ">$out_f" or die $!;
foreach my $i(0..$#seq){
        my $seq = $seq[$i];
	my ($mcvg, $sub, $idt) = (0,"represent",0);

        foreach my $j(0..($i-1)){
		my $sc = $seq[$j];
		next unless exists $cvg{$seq}{$sc};
                if($cvg{$seq}{$sc} > $mcvg){
			($mcvg, $sub, $idt) = ($cvg{$seq}{$sc}, $sc, $idt{$seq}{$sc});
			$clust{$seq} = $clust{$sc};
		}
		delete $cvg{$seq}{$sc};
        }
	if($mcvg==0){ 
		$num++;
		$clust{$seq} = $num;
		($mcvg, $idt) = (100,100);
	}
	printf OT "$seq\t$len{$seq}\t$clust{$seq}\t$sub\t$idt\t%.2f\n",$mcvg;
	push @{$list{$clust{$seq}}}, $seq;
}
close OT;

open OT, ">$out_f.list" or die $!;
foreach(1..$num){
	my @a = @{$list{$_}};
	print OT "clu$_\t".($#a+1)."\t".(join ",",@a)."\n";
}
close OT;

print STDERR "Program End...\n";
############################################################
sub function {
	return;
}
############################################################

