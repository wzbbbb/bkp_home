#!/usr/bin/perl
use Mail::Sendmail;

  %mail = ( To      => 'wzbbbb@yahoo.com',
            From    => 'test@here.com',
            Message => "This is a very short message"
           );

  sendmail(%mail) or die $Mail::Sendmail::error;

  print "OK. Log says:\n", $Mail::Sendmail::log;
