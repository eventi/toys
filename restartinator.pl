#!/usr/bin/env perl

#TODO - Reporting
#TODO - Restart on normal exit?
#TODO - Signal handling
#TODO - STDOUT, STDERR
#TODO - exclude from .ignore file
#TODO - recurse in directory

use File::Monitor;
use File::Monitor::Object;
use Proc::Simple;
use Getopt::Long;
Getopt::Long::Configure('bundling');

my $debug   = 0;
my $verbose = 0;
my @files = ( );

my $options = GetOptions(
	"debug!" =>\$debug,
	"v|verbose:+" =>\$verbose,
	"w|watch=s"   =>\@files
);
@files = ('.') unless $files[0];

#TODO - get command from remainder of ARGS
my @cmdargs = @ARGV;
print STDERR ("ARGV: ",join('|',@ARGV),"\n");
my $command = join(' ',@cmdargs);

# Proc::Simple::debug($debug);
my $proc = Proc::Simple->new();
my $monitor = File::Monitor->new();


print STDERR ("Watching ",join(":",@files),"\n") if $debug;
for my $file ( @files ) {
	$monitor->watch ( {
			name => $file,
			recurse => 1
	});
}

#Initial Scan
$monitor->scan;

my $wannarun = 1;
my $failed = 0;
my $running  = 0;
my $failure_reported = 0;

#Start Process
if ($proc->start(@cmdargs)) {
	print "Started Command: \"$command\" with pid: ".$proc->pid."\n";
}else{
	die "exit_status=".$proc->exit_status."\n";
}

#After time
while ($wannarun) {
	print "Checking\n" if $debug;
	my $changed = 0;
	for my $change ( $monitor->scan ) {
		print "Changed!\n" if $debug;
		$changed = 1;
	}
	$running = $proc->poll();
	if ($changed) {
		print "Change detected!\n";
		if ($running || $failed){
			$proc->kill() if $running;
			$proc->start(@cmdargs);
			print "Started Command: \"$command\" with pid: ".$proc->pid."\n";
			$failure_reported = 0;
		}
	}else{
		if (! $running){
			$failed = $proc->exit_status;
			if ( $failed == 0 ) {
				$wannarun = 0;
			}else{
				print "Abnormal exit: $failed\nWaiting for change before restarting" unless $failure_reported;
				$failure_reported = 1;
			}
		}
	}
	sleep 2;
}
