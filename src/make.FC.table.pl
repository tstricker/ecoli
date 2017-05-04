#$/usr/bin/perl
use warnings;
use strict;
use data::Dumper;

my @samples;
my $sample_file = "/Users/tstricker/ecoli/ecoli.1.3.sample.table.txt";
open(BB,"$sample_file")||die "Can't open $sample_file!";
while(<BB>){
    chomp $_;
    my @temp = split(/\t/, $_);
    if($temp[2]=~/KRG/){
	push @samples, $temp[2];
    }
}


my %exp;
my @files = `find /Users/tstricker/ecoli/data/count/ -name "*count"`;
foreach my $i (0..$#files){
    chomp $files[$i];
    my @name = split(/\//, $files[$i]);
    my @ID = split(/\./, $name[$#name]);
    
    open(AA, "$files[$i]")||die "Can't open $files[$i]!";
    while(<AA>){
	chomp $_;
	my @temp = split(/\t/, $_);
	unless($_=~/featureCounts/){
	    if($temp[0] =~ /gene/){
		$exp{$temp[0]}{$ID[0]}=$temp[6];
	    }
	}
    }
}

#print Dumper \%exp;
#print Dumper \@samples;

my $out_file = "/Users/tstricker/ecoli/data/count/count.matrix.txt";
open(OUT, ">$out_file")||die "Can't open $out_file!";

print OUT "GENE\t";
foreach my $k (0..$#samples){
    print OUT "$samples[$k]\t";
}
print OUT "\n";
foreach my $foo (keys %exp){
    print OUT "$foo\t";
    foreach my $i (0..$#samples){
	print OUT "$exp{$foo}{$samples[$i]}\t";
    }
    print OUT "\n";
}


print "GENE\t";
foreach my $k (0..$#samples){
    print "$samples[$k]\t";
}
print  "\n";
foreach my $foo (keys %exp){
    #print  "$foo\t";
    foreach my $i (0..$#samples){
	#print "$exp{$foo}{$samples[$i]}\t";
    }
 #   print  "\n";
}

