#!/usr/bin/perl

# Peter  Delevoryas 1/7/16
# scrub_doc.pl v 0.1 
#	- creates 'scrubbed' output file
#	- creates map file for translating back to original
#	
# limitations: .xml must have newlines 

$|=1;

my $INFILE;

if ( $#ARGV == 0 ){ 
  $INFILE=$ARGV[0];
} else {
  print "Input file: ";
  $INFILE=<STDIN>;
  chomp $INFILE;	
}

my $SCRUB_FILE = "${INFILE}.$$.scrub";
my $MAPFILE = "${INFILE}.$$.map";


my $key="SCRUBBED";
my $delim=":";

my $key_delim="${key}${delim}";


print "Input file: $INFILE\n";
print "Output (scrubbed) file: $SCRUB_FILE\n";
print "Map file: $MAPFILE\n";

print "Press return to start: ";
my $this = <STDIN>;

open IN, $INFILE;
open OUT, ">> $SCRUB_FILE";
open MAP, ">> $MAPFILE";


while ( <IN> ){
  print "."; 
  my $line = $_;

  if ( $line =~ /${key_delim}/ ){

	# >SCRUBBED:abcd<	
	# get the value 

	my $left_strip = $line; 

	$left_strip =~ s/.*$key_delim/$key_delim/;

	my @str_split  = split( /</, $left_strip );

	my $value;

	($dummy, $value) = split( /$key_delim/, $str_split[0] );

	my $rand = int(rand(10000));	

	my $new_line = $line;
	#$new_line =~ s/${key}${delim}$value/${key}${delim}$rand/;

	my $match = quotemeta( "${key}${delim}$value" );
	my $replace = "${key}${delim}$rand";

	$new_line =~ s/$match/$replace/;

	#print "Writing to map file $MAPFILE\n";
	#print MAP "${key}${delim}$rand -> ${key}${delim}$value\n"; 

	print MAP "$replace -> $value\n"; 

	#print "Writing to output file $SCRUB_FILE\n";
	print OUT "$new_line"; 
  } else {
	print OUT "$line";
  } 

}

close OUT;
close IN;
close MAP;

print "\n";
print "Done\n";
print "Scrub file: $SCRUB_FILE\n";
print "Map file: $MAPFILE\n";
		
