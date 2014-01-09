fo=./dup2json.txt
with open(fo,'rw') as fw:
  for line in fw:
    line.replace('\'','\"')


