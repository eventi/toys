#!/usr/bin/env perl
use Getopt::Long;
use File::Basename;

my $USAGE =  "Usage ". basename $0 ." [ -b ] -a OPTIONA FILE [ FILE... ]";

## Hey, this might be a cool way to test
# TEST ; fails with 255 and STDERR matches /^Usage/
# TEST -b ; fails with 255 and STDERR matches /^Usage/
# TEST -a ; fails with 255 and STDERR matches /^Usage/
# TEST -a optiona ; succeeds and STDOUT matches /^OPTIONA optiona/
# TEST -b -a optiona ; succeeds and STDOUT matches /^OPTIONA optiona/ and STDOUT matches /^OPTIONB 1/
# TEST -a optiona filea fileb filec ; succeeds and STDOUT matches /^OPTIONA optiona/
# TEST -b -a optiona ; succeeds and STDOUT matches /^OPTIONA optiona/ and STDOUT matches /^OPTIONB 1/

my $optiona = '';
my $optionb = 0;

my $options = GetOptions(
	"a=s" =>\$optiona,
	"b!" =>\$optionb,
);
# TODO - Invalid options -c, etc?
# TEST -c ; fails with -1 and STDERR matches /^Usage/


#require option -a
if ($optiona eq '') {
	print STDERR $USAGE . "\n";
	exit -1;
}

print "OPTIONA $optiona\n";
print "OPTIONB $optionb\n";

my @files = @ARGV;
for my $file (@files) {
	print "FILE: $file\n";
}
