rec_b = load 'testdir/123456*' using PigStorage(';') as (Company_id:chararray,Node:chararray,Product:chararray,Year:int,Month:int,Date:int,Hour:int,Country:chararray,Region:chararray,City:chararray,OS:chararray,Command:chararray);
flted_rec = filter rec_b by Command == 'uname -a'; -- to remove most records
gpos =  group flted_rec by (Country,OS) ; 
oc = foreach gpos   {
        n = flted_rec.Node ;
	uniq = distinct n; -- count OS used with unique node
	generate FLATTEN(group) , COUNT(uniq) as num:int;
}
h = order oc by Country, num desc;
dump h;
