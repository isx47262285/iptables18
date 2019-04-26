#! /bin/bash 
# roberto@edt 
# ip tables

# echo 1  > /proc/sys/ipv4/ip_forward


# regles de flush 

iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# politicas per default

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT



# obrir el localhost
# o -> interficie sortida
# i -> interficie entrada 
# j -> accio


iptables -A INPUT  -i lo -j ACCEPT 
iptables -A OUTPUT  -o lo -j ACCEPT

# amb la nostra ip oberta
# s -> source 
# d -> destination 

iptables -A INPUT -s 192.168.2.45 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.45 -j ACCEPT


################  REGLES OUTPUT  #################
# -A append al final de la lista de regles

#iptables -A OUTPUT -j ACCEPT

# accedir al port 13 de qualsevol desti 

#iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 13 -d 0.0.0.0/0 -j ACCEPT

#accedir a qualsevol desti al 2013 exepte al i21 ( hay que comentar la regla de si a todo )
#iptables -A OUTPUT -p tcp --dport 2013 -d 192.168.2.51 -j REJECT
#iptables -A OUTPUT -p tcp --dport 2013 -j ACCEPT 

# denegat a qualsevol i si al i21

#iptables -A OUTPUT -p tcp --dport 3013 -d 192.168.2.51 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 3013 -j REJECT


# port 4012 obert tothom, tancat a clase hisix2  , obert a i21

#iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.2.51 -j ACCEPT
#iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.2.0/16 -j REJECT
#iptables -A OUTPUT -p tcp --dport 4013 -j ACCEPT 


# NO PODEMOS SALIR A NINGUN PUERTO 80,13,7

#iptables -A OUTPUT -p tcp --dport 80 -j REJECT
#iptables -A OUTPUT -p tcp --dport 13 -j REJECT
#iptables -A OUTPUT -p tcp --dport 7 -j REJECT

#no podemos salir al destino i21
#iptables -A OUTPUT -d 192.168.2.51 -j REJECT


# NO ES POT ACCEDIR A HISIX1  HISXI 2
#iptables -A OUTPUT -d 192.168.2.0/24 -j REJECT
#iptables -A OUTPUT -d 192.168.2.0/24 -j REJECT


# NO ES POT ACCEDIR A LA XARXA HISX2, PERO SI PER SSH

iptables -A OUTPUT -p tcp --dport 22 -d 192.168.2.0/24 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.0/24 -j REJECT


