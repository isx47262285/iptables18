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

iptables -t nat -A POSTROUTING -s 172.22.0.0/24 -o enp5s0 -j MASQUERADE #netA
iptables -t nat -A POSTROUTING -s 172.23.0.0/24 -o enp5s0 -j MASQUERADE #netB
iptables -t nat -A POSTROUTING -s 172.24.0.0/24 -o enp5s0 -j MASQUERADE #dmz


# 1.  de la xarxaA només es pot accedir del router/fireall als serveis: ssh i daytime(13)

iptables -A INPUT -s 172.22.0.0/16 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 172.22.0.0/16 -p tcp --dport 13 -j ACCEPT
iptables -A INPUT -s 172.22.0.0/16 -j REJECT

# 2. de la xarxaA només es pot accedir a l'exterior als serveis web, ssh i daytime(2013)

iptables -A FORWARD -s 172.22.0.0/16 -o enp5s0 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -d 172.22.0.0/16 -p tcp --sport 80 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -s 172.22.0.0/16 -o enp5s0 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -d 172.22.0.0/16 -p tcp --sport 22 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -s 172.22.0.0/16 -o enp5s0 -p tcp --dport 2013 -j ACCEPT
iptables -A FORWARD -d 172.22.0.0/16 -p tcp --sport 2013 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A FORWARD -s 172.22.0.0/16 -o enp5s0 -j REJECT
iptables -A FORWARD -d 172.22.0.0/16 -i enp5s0 -j REJECT

# 3. de la xarxaA només es pot accedir dels serveis que ofereix la DMZ al servei web

iptables -A FORWARD -s 172.22.0.0/16 -d 172.24.0.2 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -d 172.22.0.0/16 -s 172.24.0.2 -p tcp --sport 80 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 172.22.0.0/16  -j REJECT

# 4. redirigir els ports perquè des de l'exterior es tingui accés a: 3001->hostA1:80, 3002->hostA2:2013, 3003->hostB1:2080,3004->hostB2:2007

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3001 -j DNAT --to 172.22.0.2:80  -j ACCEPT

	# AQUESTES DIRECTIVAS ENS TANCAN LES CONEXIONS, per tant les hem de definir abans
	#iptables -A FORWARD -s 172.22.0.0/16 -o enp5s0 -j REJECT
	#iptables -A FORWARD -d 172.22.0.0/16 -i enp5s0 -j REJECT

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3002 -j DNAT --to 172.22.0.3:2013  -j ACCEPT
	# AQUESTES DIRECTIVAS ENS TANCAN LES  CONEXIONS
	#iptables -A FORWARD -s 172.22.0.0/16 -o enp5s0 -j REJECT
	#iptables -A FORWARD -d 172.22.0.0/16 -i enp5s0 -j REJECT

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3003 -j DNAT --to 172.23.0.2:2080  -j ACCEPT
	# cami de tornada
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3004 -j DNAT --to 172.23.0.3:2007  -j ACCEPT
	# cami de tornada
	
# 5. S'habiliten els ports 4001 en endavant per accedir per ssh als ports ssh de: hostA1, hostA2, hostB1, hostB2.

iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4001 -j DNAT --to 172.22.0.2:22  -j ACCEPT
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4002 -j DNAT --to 172.22.0.3:22  -j ACCEPT
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4003 -j DNAT --to 172.23.0.2:22  -j ACCEPT
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4004 -j DNAT --to 172.22.0.2:22  -j ACCEPT

# 6.  S'habilita el port 4000 per accedir al port ssh del router/firewal si la ip origen és del host i26.

iptables -t nat -A PREROUTING -i enp5s0 -s 192.168.2.56 -p tcp --dport 4000 -j DNAT --to :22 -j ACCEPT

# 7.  Els hosts de la xarxaB tenen accés a tot arreu excepte a la xarxaA.

iptables -A FORWARD -s 172.23.0.0/16 -d 172.22.0.0/16 -j REJECT
iptables -A FORWARD -s 172.23.0.0/16 -j ACCEPT
iptables -A FORWARD -d 172.23.0.0/16 -j ACCEPT
















