#!/usr/bin/perl
use strict;	#important pragma
use warnings;	#another import pragma
print "What is your username";
my $username;
$username=<STDIN>;
#chomp($username);
print "Hello, $username. \n ";
