
This script will find out all the moment, when the job submission rate is over a threshold. Please note, this is not the same as, smaller than, the amount of jobs that were running at that moment. 
It will display the submission number for all the minutes on the terminal, and output the moment that is over the threshold to a file ./loaded_moment.txt.

It will read one or two parameters as input.

The first one will be the date to check. It should be like: 09\/24\/2009
The second one is optional, the threshold, the default is 80. 
