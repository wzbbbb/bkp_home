Purpose
The purpose of this project is to create an automatic dump procedure for $U V6. It should easily dump customer data from a V6 $U uxtrace, and generate job records listings as the dudmpmu in V5. It should also follow the same principal of the dudmpmu concerning data processing. 

Background
Because of the limitation of V6 security control, we can not use the V6 data files if dumped the same way as in $U V5. To analyze $U V6 data files become extremely cumbersome. To maintain our work efficiency, a new dump tool for V6 is urgently demanded.
Since V6's object IDs and names are mapped through dedicated data files, to extract records from the data files, we need a $U node with the same node and company name. The dudmp6 will install a new node and put in customer's data.

Usage
1. Uncompress all of the compressed data files in the uxtrace;
2. Go to the DUFILES 
3. You may need to be root in some occasions.
4. Run it with customer's node name and company name.
dudmp6 [node_name] [company_name]
5. The installed node will the in /apps/du/600 

Implementation 
Over view
dudmp6 uses the silent install to prepare the new node. Most of configurations are hard coded in the template file. For example, UVMS, user, password, ..., etc. To implement it into a different environment, you will have to update the file.
dudmp6 requirs specific settings to work. Once implemented, it should be maintenance free. Those specific settings also reduced possible situations the tool has to handle; and hence, to a large extent, reduced the complexity of the script. 
dudmp6 should be able to work on all kinds of Unix, with minimum modification.

Structure
dudmp6 included 2 parts
1. dudmp6.sh; the main script
2. templete.install.file; the template used to build the response file for new installation.
3. installion directory /apps/du/600 
4. A link /apps/du/600/v6_kit to the current V6 kit

Implementation consideration
Since the response file can not be used for a different version of kit, so a template file can not be generated after an interactive installation. For the first version, we have to use the 6.0.05 kit. The good news is that $U V6 is fairly easy to upgrade.
dudmp6 will pick random ports and use them after verification for $U installation.
On Montreal server, the dudmp6.sh is set to SUID root. So average user should not need to be root to run it. 
The /apps/du/600/current.install.file is generated for the current/last installation. This file should not have root as owner. Otherwise, the next installation may have problems. 
