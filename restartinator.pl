#!/usr/bin/env perl

#TODO - Restart on normal exit?
#TODO - Reporting
#TODO - Signal handling
#TODO - STDOUT, STDERR

use File::Monitor;
use File::Monitor::Object;
use Proc::Simple;

my $command = "/bin/sleep 30";

my $proc = Proc::Simple->new();
my $monitor = File::Monitor->new();

#TODO - Get files from arguments, exclude from file
my @files = ( '.' );

for my $file ( @files ) {
	$monitor->watch ( $file );
}

#Initial Scan
$monitor->scan;

my $wannarun = 1;
my $failed = 0;
my $running  = 0;

#Start Process
$proc->start($command);
print "Started Command: \"$command\" with pid: ".$proc->pid."\n";

#After time
while ($wannarun) {
	my $changed = 0;
	for my $change ( $monitor->scan ) {
		$changed = 1;
	}
	$running = $proc->poll();
	if ($changed) {
		print "Change detected!\n";
		if ($running || $failed){
			$proc->kill() if $running;
			$proc->start($command);
			print "Started Command: \"$command\" with pid: ".$proc->pid."\n";
		}
	}else{
		if (! $running){
			$failed = $proc->exit_status;
			if ( $failed == 0 ) {
				print "Normal Exit\n";
				$wannarun = 0;
			}else{
				print "Abnormal exit: $failed\n";
			}
		}
	}
	sleep 2;
}
