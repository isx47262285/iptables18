#! /bin/bash 
# roberto@edt 
# iptables
# descripcion:
#	firewall que controla una xarxa interna on hi han
#	dos host clientes y un host router 
#############################################################

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

iptables -A INPUT -s 172.203.0.1 -j ACCEPT
iptables -A OUTPUT -d 172.203.0.1 -j ACCEPT

# 1. farem que la nostra xarxa tingui sortida a internet 
iptables -t nat -A POSTROUTING -s 172.203.0.0/16 -o enp5s0 -j MASQUERADE

# (2) en el router el port 3001 porta a un servei del host1 i el port 3002 a un servei del host2.

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3001 -j DNAT --to 172.203.0.2:13

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3002 -j DNAT --to 172.203.0.3:13

# (3) en el router el port 4001 porta al servei ssh del host1 i el port 4002 al servei ssh del host2.

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4001 -j DNAT --to 172.203.0.2:22 
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4002 -j DNAT --to 172.203.0.3:22 


# (4) en el router el port 4000 porta al servei ssh del propi router. ** COMPROVAT!

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4000 -j DNAT --to :22


# (5) als hosts de la xarxa privada interna se'ls permet navegar per internet, però no cap altre accés a internet.

iptables -A FORWARD -s 172.203.0.0/16 -p tcp --dport 80 -o enp5s0 -j ACCEPT
iptables -A FORWARD -p tcp --sport 80 -d 172.203.0.0/16 -m state --state RELATED,ESTABLISHED -i enp5s0 -j ACCEPT


# AIXO ES PER OBRIR LAS CONEXIONS DEL EXERCICI 2-3 

iptables -A FORWARD -i enp5s0 -p tcp --dport 22 -d 172.203.0.0/16 -j ACCEPT 
iptables -A FORWARD -o enp5s0 -p tcp --sport 22 -s 172.203.0.0/16 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -i enp5s0 -p tcp --dport 13 -d 172.203.0.0/16 -j ACCEPT
iptables -A FORWARD -o enp5s0 -p tcp --sport 13 -s 172.203.0.0/16 -m state --state RELATED,ESTABLISHED -j ACCEPT


#iptables -A FORWARD -s 172.203.0.0/16 -o enp5s0 -j REJECT
#iptables -A FORWARD -d 172.203.0.0/16 -i enp5s0 -j REJECT


# tallar trafic
iptables -A FORWARD -s 172.203.0.0/16 -o enp5s0 -p tcp  -j DROP
iptables -A FORWARD -s 172.203.0.0/16 -o enp5s0 -p udp  -j DROP
iptables -A FORWARD -d 172.203.0.0/16 -i enp5s0 -p tcp  -j DROP
iptables -A FORWARD -d 172.203.0.0/16 -i enp5s0 -p udp  -j DROP

# (6) no es permet que els hosts de la xarxa interna facin ping a l'exterior.

iptables -A FORWARD -s 172.203.0.0/16 -p icmp --icmp-type=8 -o enp5s0 -j DROP

# (7) el router no contesta als pings que rep, però si que pot fer ping.

iptables -A INPUT -p icmp --icmp-type=8 -i enp5s0 -j DROP
iptables -A OUTPUT -p icmp --icmp-type=0 -o enp5s0 -j DROP

