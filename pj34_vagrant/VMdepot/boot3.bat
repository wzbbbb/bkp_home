d:
cd \VMmount
call vagrant box add testvm11 d:\vmdepot\testvm11.box
call vagrant box add testvm12 d:\vmdepot\testvm12.box
call vagrant box add testvm13 d:\vmdepot\testvm13.box
call vagrant up testvm11
call vagrant up testvm12
call vagrant up testvm13
cd \VMdepot
