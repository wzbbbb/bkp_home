#!/usr/bin/python
import commands
import sys
cmd = 'curl casplda02/'
#cmd = 'curl 192.168.115.51/'
cmd1 = 'curl casplda02/time/'
#cmd1 = 'curl 192.168.115.51/time/'
cmd2 = 'curl casplda02/ttt'
#cmd2 = 'curl 192.168.115.51/ttt'
for i in range(int(sys.argv[1])):
    (status, output) = commands.getstatusoutput(cmd)
    print status
    (status, output) = commands.getstatusoutput(cmd1)
    print status
    (status, output) = commands.getstatusoutput(cmd2)
    print status
