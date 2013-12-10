rec_b = load 'testdir/123456*' using PigStorage(';') as (Company_id:chararray,Node:chararray,Product:chararray,Year:int,Month:int,Date:int,Hour:int,Country:chararray,Region:chararray,City:chararray,OS:chararray,Command:chararray);
flted_rec = filter rec_b by Command == 'uname -a';
os = group flted_rec by OS;
o = foreach os {
	n = flted_rec.Node;
	uniq = distinct n;
	generate group , COUNT(uniq) as num:long ; 
}
h = order o by num desc;
dump h ;
