#! /bin/bash 
# roberto@edt 
# ip tables
# apuntes:
# 		o -> interficie sortida
#		i -> interficie entrada 
# 		j -> accio
#		s -> source 
# 		d -> destination 
# 		echo 1  > /proc/sys/ipv4/ip_forward
#######################################################################
#	FALTA POSAR A LES CONEXIONS  INPUT '-m state --state RELATED,ESTABLISHED'
# 
#######################################################################
# regles de flush 
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# politicas per default
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
#iptables -t nat -P PREROUTING ACCEPT
#iptables -t nat -P POSTROUTING ACCEPT

# obrir el localhost
iptables -A INPUT  -i lo -j ACCEPT 
iptables -A OUTPUT  -o lo -j ACCEPT

# amb la nostra ip oberta
iptables -A INPUT -s 192.168.2.58 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.58 -j ACCEPT

# sortida a internet 

iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o enp5s0 -j MASQUERADE

# ---------------------------------------------------
# OBRIR EL TRAFIC DNS (LO QUE TENIM DEFINIT AL '/etc/resolv.conf')
# apunte: al ser input i output tenemos que tener encuenta que somos la referencia per tant el source i el port origen seran los mateixos.

iptables -A INPUT -s 192.168.0.10 -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.10 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -s 10.1.1.200 -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 10.1.1.200 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -s 208.67.222.222 -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 208.67.222.222 -p udp --dport 53 -j ACCEPT

# OBRIM TRAFIC PER SERVEI DHCLIENT ( PORT SERVER 67 ,CLIENT 68) NOMES CAL OBRIR EL 68 PERQUE LES PETICIONS LES FEM COM A CLIENT Y ENS CONTESTARA PER EL 68 
iptables -A INPUT -p udp --sport 68 -j ACCEPT 
iptables -A OUTPUT -p udp --dport 68 -j ACCEPT

# servei ssh 22
iptables -A INPUT -p tcp --sport 22 -j ACCEPT 
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# servei rpc (111 , 507)
iptables -A INPUT -p tcp --sport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 111 -j ACCEPT

iptables -A INPUT -p tcp --sport 507 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 507 -j ACCEPT

# servei chronyd (123 , 371)
iptables -A INPUT -p tcp --sport 123 -j ACCEPT 
iptables -A OUTPUT -p tcp --dport 123 -j ACCEPT 

iptables -A INPUT -p tcp --sport 371 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 371 -j ACCEPT 

# CUPS 631 
iptables -A INPUT -p tcp --sport 631 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 631 -j ACCEPT

# XINETD 3411

iptables -A INPUT -p tcp --sport 3411 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3411 -j ACCEPT

# POSTGREST 5432
iptables -A INPUT -p tcp --sport 5432 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5432 -j ACCEPT

# X11 FORWARDING 6010 ,6011

iptables -A INPUT -p tcp --sport 6010 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 6010 -j ACCEPT

iptables -A INPUT -p tcp --sport 6011 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 6011 -j ACCEPT


#AVAHI 368
iptables -A INPUT -p tcp --sport 368 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 368 -j ACCEPT


# ALPES 462

iptables -A INPUT -p tcp --sport 462 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 462 -j ACCEPT

# TCPNETHASPSRV 475	

iptables -A INPUT -p tcp --sport 475 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 475 -j ACCEPT

# rxe 761

iptables -A INPUT -p tcp --sport 761 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 761 -j ACCEPT



#### altres ports importants per el funcionament del sistema ####

# pings 

iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# ldap (389)
iptables -A INPUT -p tcp --sport 389 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 389 -j ACCEPT

# kerberos (88)

iptables -A INPUT -p tcp --sport 88 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 88 -j ACCEPT

# Servicios Kerberos de cambio de contraseñas y llaves 

iptables -A OUTPUT -p tcp --dport 464 -j ACCEPT
iptables -A INPUT -p tcp --sport 464 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 749 -j ACCEPT
iptables -A INPUT -p tcp --sport 749 -j ACCEPT

iptables -A INPUT   -p udp --sport 543  -j ACCEPT
iptables -A OUTPUT  -p udp --dport 543 -j ACCEPT

# apache 80

iptables -A INPUT   -p tcp --sport 80  -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 80  -j ACCEPT
iptables -A INPUT   -p tcp --sport 443  -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 443  -j ACCEPT


iptables -A INPUT   -p tcp --sport 8080  -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 8080 -j ACCEPT

# smtp 25
iptables -A INPUT -p tcp --sport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT

# telnet 23,84

iptables -A INPUT -p tcp --sport 23 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 23 -j ACCEPT
iptables -A INPUT   -p tcp --sport 84  -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 84  -j ACCEPT

# nfs 2049

iptables -A INPUT -p tcp --sport 2049 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 2049 -j ACCEPT

# Server local: servei daytime-stream (13,83)
iptables -A INPUT   -p tcp --sport 13   -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 13   -j ACCEPT
iptables -A INPUT   -p tcp --sport 83   -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 83   -j ACCEPT

# servei tftp 69

iptables -A INPUT   -p udp --sport 69  -j ACCEPT
iptables -A OUTPUT  -p udp --dport 69  -j ACCEPT

# servei ftp 20, 21

iptables -A INPUT   -p udp --sport 20  -j ACCEPT
iptables -A OUTPUT  -p udp --dport 20  -j ACCEPT


iptables -A INPUT   -p udp --sport 21  -j ACCEPT
iptables -A OUTPUT  -p udp --dport 21  -j ACCEPT


