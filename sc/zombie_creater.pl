#!/usr/bin/perl

print "I am PID $$.\n";

$pid = fork();
if($pid == 0) {
  print "PID $$ about to die and become a zombie.\n";
  die;
}

while(1) {
  sleep(5);
  print "PID $$ still spinning!\n";
}
