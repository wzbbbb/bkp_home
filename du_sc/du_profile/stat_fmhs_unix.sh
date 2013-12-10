#!/bin/ksh
#ORSYP JKE
#2012 03 19
#V3 : 
#meilleur gestion des arguments
#correction de bug lié à EPOCH
#modification du format de sortie
#amelioration indentation et commentaires
#JKE 2012 03 29
#V4 : 
#ré-ecriture des fonction strftime
#et mktime afin de tourner sans gawk
#JKE 2013 02 22



#fonction usage qui finit par sortir du script
function usage {
echo "$0 -t tranche -s date_debut -e date_fin -f chemin/fichier"
echo "m : tranche 1 minute"
echo "dix : 10 minutes"
echo "h : 1 heure"
echo "j : 1 jour"
echo "debut sur 12 char AAAAMMJJHHmm"
echo "fin sur 12 char AAAAMMJJHHmm"
echo "par defaut $0 -t h -s 197001010000 -e 203801190313 -f u_fmhs50.dta"
exit
}


#par defaut, la date de début est EPOCH
debut=197001010000

#par defaut, la date de fin est la date du bug de 2038
fin=203801190313

#par defaut, on prend le fmhs dans le repertoire courant.
fichier_fmhs="u_fmhs50.dta"

#on positionne tranche par defaut à heure : 
tranche=h

#on shift sur les arguments
while [ $# -gt 0 ]
do
    case $1
    in
        -s) debut=$2
            shift 2
        ;;
        -e) fin=$2
            shift 2
        ;;
        -f) fichier_fmhs=$2
            shift 2
        ;;
        -t) tranche=$2
            shift 2
        ;;
        *) usage
    esac
done

#En fonction du premier argument, on passera le nombre de caracteres 
#que prend le format de date qui nous interesse.
case ${tranche} in
    m|M) comptage=12
    ;;
    dix|DIX|ten|TEN) comptage=11
    ;;
    h|H) comptage=10
    ;;
    j|J|d|D) comptage=8
    ;;
    *) usage
esac

awk -v debut=$debut -v fin=$fin -v comptage=$comptage ' 
function weeknumber(flag)
{
        local n;
        if (flag == "U") return int((yearday + 5 - (weekday-1)) / 7);
        if (flag == "W") return int((yearday + 5 - ((weekday>1) ? (weekday-2):6)) / 7);
        n = int((yearday + 8 - (weekday>1 ? (weekday - 2) : 6)) / 7);
        return n ? n : 53;
}

function strftime(fmt,epoc)
{
#calcule de secondes minutes heures jour_mois mois annee jour_an depuis unix time
wipmin = int( epoc / 60 )
second = epoc % 60
wipheure = int( wipmin / 60 )
minute = wipmin % 60
wipjour = int( wipheure / 24 ) + 1
hour = wipheure % 24
year = int( wipjour / 365 ) + 1970
wipjour_an = wipjour % 365
leapmod = 0
for ( an=1970 ; an<year ; an++ )
    { if ( (an % 4 == 0 && an % 100 != 0) || (an % 400 == 0) )
        { leapmod++ } }
if ( leapmod >= wipjour_an ) {
    year = year - 1
    if ( (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) )
        { wipjour_an = 366 + wipjour_an }
    else
        { wipjour_an = 365 + wipjour_an }
    }
yearday = wipjour_an - leapmod

if ( (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) )
    { isleap = "Y" }
longmois=31
month=1
wipjour_an2 = yearday
while ( wipjour_an2 > longmois )
    { if ( month == 1 )
        { if ( isleap == "Y" )
            { wipjour_an2 = wipjour_an2 - longmois ; longmois = 29 }
          else
            { wipjour_an2 = wipjour_an2 - longmois ; longmois = 28 }
        }
      if ( month == 2 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 31 }
      if ( month == 3 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 30 }
      if ( month == 4 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 31 }
      if ( month == 5 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 30 }
      if ( month == 6 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 31 }
      if ( month == 7 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 31 }
      if ( month == 8 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 30 }
      if ( month == 9 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 31 }
      if ( month == 10 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 30 }
      if ( month == 11 )
        { wipjour_an2 = wipjour_an2 - longmois ; longmois = 31 }
      month++
    }
    day = wipjour_an2
#january 1st 1970 was a thursday
    weekday = (wipjour + 3) % 7

        split("Mon Tue Wed Thu Fri Sat Sun",abdaynames)
        split("Monday Tuesday Wednesday Thursday Friday Saturday Sunday",daynames)
        split("January February March April May June July August September October November December",monthnames)
        split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec",abmonthnames)

        gsub("%%","\xff",fmt)   # Change %% so we dont lose them
        # We do not support POSIX locales, so %Ex and %Ox are translated to %x.
        gsub("%E|%O","%",fmt)
        # The %c, %x, %X and %r are country-specific abbreviations for other formats:
        gsub("%c","%a %b %e %H:%M:%S %Z %Y",fmt)
        gsub("%x","%m %d %y",fmt)
        gsub("%X","%H:%M:%S",fmt)
        gsub("%r","%I:%M:%S %p",fmt)
        gsub("%D","%m/%d/%y",fmt)
        gsub("%R","%H:%M",fmt)
        gsub("%T","%H:%M:%S",fmt)

        # Now do the format substitutions
        gsub("%a",abdaynames[weekday],fmt)
        gsub("%A",daynames[weekday],fmt)
        gsub("%B",monthnames[month],fmt)
        gsub("%b",abmonthnames[month],fmt)
        gsub("%C",int(year/100),fmt)
        gsub("%d",sprintf("%02d",day),fmt)
        gsub("%e",sprintf("%2d",day),fmt)
        gsub("%h",abmonthnames[month],fmt)
        gsub("%H",sprintf("%02d",hour),fmt)
        gsub("%I",sprintf("%02d",hour % 12 == 0 ? 12 : hour % 12),fmt)
        gsub("%j",sprintf("%03d",yearday),fmt)

        # %k and %l are not in POSIX, but are SunOS compatible?
        gsub("%k",sprintf("%2d",hour),fmt)
        gsub("%l",sprintf("%2d",hour % 12 == 0 ? 12 : hour % 12),fmt)

        gsub("%m",sprintf("%02d",month),fmt)
        gsub("%M",sprintf("%02d",minute),fmt)
        gsub("%n","\n",fmt)
        gsub("%p",hour < 12 ? "AM" : "PM",fmt)
        gsub("%s",epoc,fmt)
        gsub("%S",sprintf("%02d",second),fmt)
        gsub("%t","\t",fmt)
        # %u is day of week, but assuming 1=Mon, ..., 7=Sun
        gsub("%u",weekday == 1 ? 7 : weekday-1,fmt)
        gsub("%U",sprintf("%02d",weeknumber("U")),fmt)
        gsub("%V",sprintf("%02d",weeknumber("V")),fmt)
        gsub("%w",weekday-1,fmt)
        gsub("%W",sprintf("%02d",weeknumber("W")),fmt)
        gsub("%y",sprintf("%02d",year % 100),fmt)
        gsub("%Y",year,fmt)
        # %Z is time zone name, which is taken from the environment variable.
        # If the TZ environment variable is not set, print nothing.
        gsub("%Z",ENVIRON["TZ"],fmt)  # Time Zone Name

        gsub("\xff","%",fmt)    # Change %% removed above back to %
        return fmt
}


# decide if a year is a leap year
function _tm_isleap(year, ret)
{
    ret = (year % 4 == 0 && year % 100 != 0) ||
            (year % 400 == 0)

    return ret
}

# convert a date into seconds
function _tm_addup(a, total, yearsecs, daysecs,
                         hoursecs, i, j)
{
    hoursecs = 60 * 60
    daysecs = 24 * hoursecs
    yearsecs = 365 * daysecs

    total = (a[1] - 1970) * yearsecs

    # extra day for leap years
    for (i = 1970; i < a[1]; i++)
        if (_tm_isleap(i))
            total += daysecs

    j = _tm_isleap(a[1])
    for (i = 1; i < a[2]; i++)
        total += _tm_months[j, i] * daysecs

    total += (a[3] - 1) * daysecs
    total += a[4] * hoursecs
    total += a[5] * 60
    total += a[6]

    return total
}

function mktime(str, res1, res2, a, b, i, j, t, diff)
{
    i = split(str, a, " ")    # dont rely on FS

    if (i != 6)
        return -1

    # force numeric
    for (j in a)
        a[j] += 0

    # validate
    if (a[1] < 1970 ||
        a[2] < 1 || a[2] > 12 ||
        a[3] < 1 || a[3] > 31 ||
        a[4] < 0 || a[4] > 23 ||
        a[5] < 0 || a[5] > 59 ||
        a[6] < 0 || a[6] > 61 )
            return -1

    res1 = _tm_addup(a)
    t = strftime("%Y %m %d %H %M %S", res1)

    if (_tm_debug)
        printf("(%s) -> (%s)\n", str, t) > "/dev/stderr"

    split(t, b, " ")
    res2 = _tm_addup(b)

    diff = res1 - res2

    if (_tm_debug)
        printf("diff = %d seconds\n", diff) > "/dev/stderr"

    res1 += diff
    return res1
}

BEGIN { clefd = 999999999999 ; cleff = 0 
# Initialize table of month lengths
_tm_months[0,1] = _tm_months[1,1] = 31
_tm_months[0,2] = 28; _tm_months[1,2] = 29
_tm_months[0,3] = _tm_months[1,3] = 31
_tm_months[0,4] = _tm_months[1,4] = 30
_tm_months[0,5] = _tm_months[1,5] = 31
_tm_months[0,6] = _tm_months[1,6] = 30
_tm_months[0,7] = _tm_months[1,7] = 31
_tm_months[0,8] = _tm_months[1,8] = 31
_tm_months[0,9] = _tm_months[1,9] = 30
_tm_months[0,10] = _tm_months[1,10] = 31
_tm_months[0,11] = _tm_months[1,11] = 30
_tm_months[0,12] = _tm_months[1,12] = 31

CONVFMT = "%.0f"
}

    index($0,"D") == "11" && substr($0,"12","12") >= debut && substr($0,"12","12") <= fin { clef = substr($0,"12",comptage) ;
                                                                                            tableau[clef] = tableau[clef] + 1 ;
                                                                                            if ( clef > cleff ) { cleff = clef } ;
                                                                                            if ( clef < clefd ) {clefd = clef} }
    END {   if ( comptage==8 )
                { multip=1000000 ; shift = 86400 ; format="%Y%m%d" ; opt = 1 };
            if ( comptage==10 )
                { multip=10000 ; shift = 3600 ; format="%Y%m%d%H" ; opt = 1 };
            if ( comptage==11 )
                { multip=1000 ; shift = 600 ; format="%Y%m%d%H%M" ; opt = 10 };
            if ( comptage==12 )
                { multip=100 ; shift = 60 ; format="%Y%m%d%H%M" ; opt = 1 };

            clefd = clefd * multip ; cleff = cleff * multip ;

            annee0=substr(clefd,1,4)
            mois0=substr(clefd,5,2)
            jour0=substr(clefd,7,2)
            heure0=substr(clefd,9,2)
            minutes0=substr(clefd,11,2)
            secondes0=substr(clefd,13,2)

            annee1=substr(cleff,1,4)
            mois1=substr(cleff,5,2)
            jour1=substr(cleff,7,2)
            heure1=substr(cleff,9,2)
            minutes1=substr(cleff,11,2)
            secondes1=substr(cleff,13,2);

            date0=mktime(annee0" "mois0" "jour0" "heure0" "minutes0" "secondes0) ;
            date1=mktime(annee1" "mois1" "jour1" "heure1" "minutes1" "secondes1) ;
            compteur=date0 ;

            while (compteur <= date1) 
                { print strftime( "\"%Y/%m/%d--%H:%M\"",compteur) ";" tableau[strftime(format,compteur)/opt]+0  ; compteur = compteur + shift }
        } 
    ' ${fichier_fmhs}
    