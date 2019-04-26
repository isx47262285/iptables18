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


#exemples port forwarding
#iptables -A FORWARD -p tcp --dport 13 -j REJECT

## EXEMPLES QUE SON PREROUTING PERQUE FEM LA REDIRECCIO DE PORTS I
## QUE TAMBE PODEN SER HOSTS DIFERENTS

#iptables -A INPUT -p tcp --dport 13 -j REJECT

#iptables -t nat -A PREROUTING -p tcp --dport 5001 -j DNAT  --to 172.22.0.2:13 

#iptables -t nat -A PREROUTING -p tcp --dport 5002 -j DNAT \
#        --to 172.22.0.3:13
#iptables -t nat -A PREROUTING -p tcp --dport 5003 -j DNAT \
#        --to :13


iptables -t nat -A PREROUTING -p tcp --dport 6001 -j DNAT \
	--to :80

iptables -t nat -A PREROUTING -p tcp --dport 6000 -j DNAT \
        --to :22


# traffic de smtp engaviat i redirigit al nostre 25 o qualsevol altre 


iptables -t nat -A PREROUTING -s 172.22.0.0/16 -p tcp --dport 25 -j DNAT --to 192.168.2.45:13

iptables -t nat -A PREROUTING -s 172.23.0.0/16 -p tcp --dport 25 -j DNAT \
        --to :80


# regles DMZ 



