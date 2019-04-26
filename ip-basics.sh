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


# INPUT 

# PROVAMOS TODO EL MUNDO A UN PORT DESTINO
iptables -A INPUT -p tcp --dport 80 -j ACCEPT  

iptables -A INPUT -p tcp --dport 2080 -j REJECT
iptables -A INPUT -p tcp --dport 3080 -j DROP


# tots no y tu si 
# PRIMERO SE TRATAN LAS REGLAS PARTICULARES Y DESPUES LO GENERALES

iptables -A INPUT -p tcp --dport 3080 -s 192.168.2.56 -j ACCEPT
iptables -A INPUT -p tcp --dport 3080 -j DROP

# PUEDE TODOS MENOS EL I26
iptables -A INPUT -p tcp --dport 4080 -s 192.168.2.56 -j REJECT
iptables -A INPUT -p tcp --dport 4080 -j ACCEPT #LA POLITICA POR DEFECTO DICE QUE ESTA ABIERTO 

# tancat a tothom , obert a hisix2  y tancat a i26

iptables -A INPUT -p tcp --dport 5080 -s 192.168.2.56 -j REJECT
iptables -A INPUT -p tcp --dport 5080 -s 192.168.2.0/16 -j ACCEPT
iptables -A INPUT -p tcp --dport 5080 -j DROP

# port 7000 obert a tothon tancat a hixsi 2 y obert a i21


iptables -A INPUT -p tcp --dport 7080 -s 192.168.2.51  -j ACCEPT

iptables -A INPUT -p tcp --dport 7080 -s 192.168.2.0/16  -j REJECT

iptables -A INPUT -p tcp --dport 7080 -s 0.0.0.0 -j ACCEPT


# tancar tot acces del 3000:8000

#iptables -A INPUT -p tcp --dport 3000:8000 -j REJECT
# BARRERAS FINALS DE TANCAR 


