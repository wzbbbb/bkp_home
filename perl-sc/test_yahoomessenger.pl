#!/usr/bin/perl
use strict;
use warnings;
use Net::YahooMessenger;

        my $yahoo = Net::YahooMessenger->new(
                id       => 'xxx',
                password => 'ddd',
		hostname => 'cs39.msg.dcn.yahoo.com',
        );
	print $yahoo->id . "\n";
	print $yahoo->password;
        $yahoo->login or die "Can't login Yahoo!Messenger";
        $yahoo->send('wzbbbb', 'Hello World!');
