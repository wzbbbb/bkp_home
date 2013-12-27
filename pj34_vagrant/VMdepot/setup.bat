d:
mkdir \VMmount
cd \VMmount
call vagrant init
rename Vagrantfile Vagrantfile_blank
copy d:\vmdepot\bootstrap*.sh .
copy d:\vmdepot\Vagrantfile .
d:
cd \VMdepot
