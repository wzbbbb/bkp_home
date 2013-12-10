IMPORT '/dev/shm/load_info.macro';
rec_s = load_specific('hdfs://localhost/user/root/testdir/123456*') ;
flt = filter rec_s by Content matches '.*fmhs.*' ;
ls_t = foreach flt {
	nod = Node;
	n = STRSPLIT(Content, ' ++');
	generate nod as node_name:chararray, n.$8 as file_name:chararray, (int)n.$4 as size:long; 
}
-- to cast size to int explicitly
dump ls_t;

o = group ls_t by node_name;
m = FOREACH o GENERATE group, SUM(ls_t.size);
dump m;
