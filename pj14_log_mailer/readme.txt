...........Purpose:
1. To have all of the warning and error messages sent to the intended recipients.
2. To establish a centralized control and  avoid to configure a mail server on each testing node.


...........Package contents
1. LogMailer.ksh
2. LogMailer.conf
3. readme.txt


...........Work flow
The LogMailer.ksh will read the configuration file LogMailer.conf for 2 information:
1. the log files to check and send?
2. the intended recipients' email addresses


...........Reading the LogMailer.conf
1. Application name
This is designed to group recipients according to applications. 
Every record begins with a application name, for example:

APS:recipient=zwa@orsyp.com;wzbbbb@yahoo.com

APS here is the application name.

2. Email title

For example the email title for the following records: 
APS: frsdlsup01, error message!=/dadata/APS/frsdlsup01/err_log

would be "APS: frsdlsup01, error message!".

...........The separators
Please note that the ":", "=" and ";" are used to separate different fields. 

