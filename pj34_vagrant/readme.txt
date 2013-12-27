Content -
==================
-  bootstrap1.sh
-  bootstrap2.sh
-  bootstrap3.sh
-  testvm11.box
-  testvm12.box
-  testvm13.box
-  Vagrantfile
==================
The files above is used internally, please don't change it.
-  setup.bat    # setup the environment before every new test
-  boot1.bat  # To launch 1 VM 
-  boot2.bat  # To launch 2 VM 
-  boot3.bat  # To launch 3 VM 
-  cleanup.bat  # To clean up everything 
-  pause.bat    # To suspend VM, and free memory

4. The UVMS and UVC webconsole is on testvm1. 


Preparation -

1. Creat directory D:\VMdepot  # Store every files in VMdepot  

2. Create directory D:\VMmount # this directory is accessable in every VM



Usage -
1. cd to D:\VMdepot

2. Run setup.bat and one of the launch script, for example, boot1.bat

3. Access the UVC through web browser, http://localhost:8081

4. After test, run cleanup.bat

5. To keep the environment for later, run pause.bat

6. SSH access to the node: 
testvm11: 127.0.0.1:2021
testvm12: 127.0.0.1:2022
testvm13: 127.0.0.1:2023

7. For dump, unpack uxtrace in D:\VMmount, and run boot1.bat, then dudmp6 in testvm11.
