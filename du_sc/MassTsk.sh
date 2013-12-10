#!/usr/bin/ksh -x
num=1
#upr_name=""

LOOP_1()
{
upr_base=TC3600
mu_name=DA_US_U_02
num_2=1
area=app
user=univa
vupr=001
max=200
until [ ${num_2} -gt $max ]
do
        [ ${num_2} -ge 10 ] || uproc_name=${upr_base}0${num_2}
        [ ${num_2} -ge 10 ] && uproc_name=${upr_base}${num_2}
        uxadd TSK $area UPR=${uproc_name} VUPR=$vupr MU=${mu_name} TECHINF type=p USER=$user
        num_2=` expr ${num_2} + 1`
done
num=` expr ${num} + 1`
}

# Main #
LOOP_1 
echo "== The End =="
