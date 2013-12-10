#!/bin/bash
#ORSYP JKE
#2012 03 21
#V2.1 : correction sur regexp du awk
#V3 : 
#meilleur gestion des arguments
#correction de bug lié à EPOCH
#modification du format de sortie
#amelioration indentation et commentaires
#JKE 2012 03 29


#fonction usage qui finit par sortir du script
function usage {
echo "$0 -t tranche -s date_debut -e date_fin -f chemin/fichier"
echo "m : tranche 1 minute"
echo "dix : 10 minutes"
echo "h : 1 heure"
echo "j : 1 jour"
echo "debut sur 12 char AAAAMMJJHHmm"
echo "fin sur 12 char AAAAMMJJHHmm"
echo "par defaut $0 -t h -s 197001010000 -e 203801190313 -f u_fmcx50.dta"
exit
}


#par defaut, la date de début est EPOCH
debut=197001010000

#par defaut, la date de fin est la date du bug de 2038
fin=203801190313

#par defaut, on prend le fmhs dans le repertoire courant.
fichier_fmcx="u_fmcx50.dta"

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
        -f) fichier_fmcx=$2
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
case $tranche in
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

awk -v debut=$debut -v fin=$fin -v comptage=$comptage ' BEGIN { clefd = 999999999999 ; cleff = 0 }
    substr($0,"1","1") ~ /[0-9A-Z_ ]/ && substr($0,"45","12") >= debut && substr($0,"45","12") <= fin { clef = substr($0,"45",comptage) ;
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
    ' $fichier_fmcx
    