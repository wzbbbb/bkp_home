import subprocess
def send_msg(msg,gw):
    subprocess.call(['curl','-X', 'POST', '-H','Content-Type: application/json','-d',msg,gw]) # not checking return code
    return
msg='[{"username":"xyz","password":"xyz","something":80}]' # in JSON format
gw='http://192.168.114.174/SDC/msg/'
#send_msg(msg,gw)

def fn2code(cfile):
    d=dict()
    with open(cfile, 'r') as f:
        for line in f:
            s=line.split()
            d[s[1]]=s[0]
    return d
#print fn2code('./coding.txt')


def findoutput(tmp_path):
    tmp_file=tmp_path + 'SD_temp.txt'
    with open(tmp_file, 'r') as f:
        for line in f:
            file=line
    return file.split('\n')[0], tmp_file
#print findoutput('/home/temp/')

def zip2send(tmp_path): # inut: the $U_TMP_PATH. read SD_temp.txt to find the output file
    file,tmp_file=findoutput(tmp_path)
    gw='http://192.168.114.174/SDC/upload/'
    out=tmp_path + file
    #print 'out' ,out + '=='
    subprocess.call(['gzip',out])  
    out=out+ '.gz'
    the_file='the_file=@' + out  # compress
    print the_file
    subprocess.call(['curl','-i','-F',the_file,gw]) # send compressed output
    subprocess.call(['rm',out, tmp_file]) # delete SD_temp.txt and output
#zip2send('/home/temp/')

#import json
from itertools import *
def dup2json(fi,fo,area):
    ti="" # time inverval used
    with open(fi, 'r') as f:
        with open(fo, 'a') as fw:
            for line in f: 
                if '===TimeFrame' in line:
                    ti=line.split(' ')[1].split('\n')[0] # h or m, and revmoe the \n at the end
                    ti_key='ti' + ti
                    continue
                list1 = [area]+line.split('\n')[0].split(',')
                list1[2]=int(list1[2])
                d=dict(izip(["area",ti_key,"nexe"], list1))
		ns=str(d).replace('\'','\"')
                fw.write(ns+'\n')
            fw.flush()
fi='./dup.txt'
fo='./dup2json.txt'
dup2json(fi,fo,'X')

