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

1. Install latest VirutalBox and Vagrant

2. Creat a directory D:\VMdepot, put all files in it  




Usage -
1. cd to D:\VMdepot

2. Run setup.bat and one of the launch script, for example, boot1.bat

3. Access the UVC through web browser, http://localhost:8081/univiewer_webconsole_6.1.21_all_os/

4. After test, run cleanup.bat

5. To keep the environment for later, run pause.bat

6. SSH access to the node: 
testvm11: 127.0.0.1:2021, root:test
testvm12: 127.0.0.1:2022, root:test
testvm13: 127.0.0.1:2023, root:test

7. For dump, unpack uxtrace in D:\VMmount, and run boot1.bat, then dudmp6 in testvm11.
