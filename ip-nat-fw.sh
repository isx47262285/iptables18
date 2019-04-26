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


# fer nat per las nostres xarxes internes
# -172.21.0.0/24

iptables -t nat -A POSTROUTING -s 172.22.0.0/24 -o enp5s0 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 172.23.0.0/24 -o enp5s0 -j MASQUERADE


#  REGLES FORWARD 
# NO SE PUEDE CONECTAR DE LA RED A , A LA RED B 

#iptables -A FORWARD -s 172.22.0.0/24 -d 172.23.0.0/24 -j REJECT


# TODO LO QUE PROVENGA DE LA INTERCIE DE HOSTA NO PUEDE IR A HOSTB2
#iptables -A FORWARD -i  br-51aceb7515b6 -d 172.23.0.3 -j REJECT


# PROHIBIMOS QUE EL HOST A1 AL HOST B1
#iptables -A FORWARD -s 172.22.0.2 -d 172.23.0.3 -j REJECT


# tdoo el trafico de la red A al port 13, meg
#iptables -A FORWARD -s 172.22.0.0/24 -p tcp --dport 13 -j REJECT


# trafico de la red A a l port 2013 de la red B
#iptables -A FORWARD -s 172.22.0.0/24 -p tcp --dport 2013 -d 172.23.0.0/24 -j REJECT

# xarxaA permetre navegar per internet pero resmes al exterior 

#iptables -A FORWARD -s 172.22.0.0/24 -p tcp --dport 80 -o enp5s0 -j ACCEPT
#iptables -A FORWARD -d 172.22.0.0/24 -p tcp --sport 80 -i enp5s0 \
#      -m state --state  RELATED,ESTABLISHED -j ACCEPT

#iptables -A FORWARD -s 172.22.0.0/24 -o enp5s0 -j REJECT 
#iptables -A FORWARD -d 172.22.0.0/24 -i enp5s0 -j REJECT


# XARXA A POT ACCEDIR AL SERVEI 2013  DE TOT INTERNET EXECPTE DE LA XARXA HISIX2 


#iptables -A FORWARD -s 172.22.0.0/24 -d 192.168.2.0/16 -p tcp --dport 2013 -o enp5s0 -j REJECT

#iptables -A FORWARD -s 172.22.0.0/24 -p tcp --dport 2013 -o enp5s0 -j ACCEPT


# EVITAR SPUFFING ( SUPLANTACION DE DE IPS )
# CUALQUIER PAQUETE QUE TE LLEGUE QUE NO PROVENGA DE LA IP .... Y LA INTERFICIE DE ENTRADA ES EL BR- .....   HAZ DROP!

#iptables -A FORWARD ! -s 172.22.0.0/24 -i br-51aceb7515b6 -j DROP



