#!/usr/bin/perl
use strict;
#Read : open(my $File,"<file.txt");
#Write : open(my $File,">file.txt");
#Append : open(my $File,">>file.txt");

my $Version = "0.0.02";

sub Help
{
	print "Author: Dan (DJ) Coffman\n";
	print "Program: newPerl\n";
	print "Version: $Version\n";
	print "Purpose: make new Perl Scripts\n";
	print "Usage: newPython.pl <args>\n";
	print "\t-n <name> : program name\n";
	print "\t--name <name> : program name\n";
	print "\t--cli : enable command line (Main file ONLY)\n";
	print "\t--main : main file\n";
	print "\t--shell : unix shell\n";
	print "\t--write-file : enable \"write\" file method\n";
	print "\t--read-file : enable \"read\" file method\n";
	print "\t--os : import OS\n";

}

my $Name = "";
my $CLI = "False";
my $MAIN = "False";
my $READ = "False";
my $WRITE = "False";

my $ArgNum = $#ARGV + 1;
#Grab Args
if ($ArgNum > 0)
{
	my $count = $0;
	#loop through Args
	foreach my $a(@ARGV)
	{
		#Get Name of program
		if ($a eq "--name")
		{	
			$count += 1;
			$Name = $ARGV[$count];
		}
		#Get Name of program
		elsif ($a eq "--name")
		{	
			$count += 1;
			$Name = $ARGV[$count];
		}
		#Enable CLI
		elsif ($a eq "--cli")
		{
			$CLI = "True";
			$count += 1;
		}
		#Enable Main
		elsif ($a eq "--main")
		{
			$MAIN = "True";
			$count += 1;
		}
		#Enable Read
		elsif ($a eq "--read-file")
		{
			$READ = "True";
			$count += 1;
		}
		#Enable Write
		elsif ($a eq "--write-file")
		{
			$WRITE = "True";
			$count += 1;
		}
		#Increment
		else
		{
			$count += 1;
		}
	}
}

if ($Name eq "")
{
	Help();
}
else
{
	print "$Name.pl\n";
	if ($CLI eq "True")
	{
		print "Enable cli\n";
	}
	if ($MAIN eq "True")
	{
		print "Enable main\n";
	}
	if ($READ eq "True")
	{
		print "Enable read\n";
	}
	if ($WRITE eq "True")
	{
		print "Enable write\n";
	}
}
