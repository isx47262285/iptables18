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


# NO PERMET FER PINGS 

#iptables -A INPUT -p icmp --icmp-type 8 -j DROP
#iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP 

# NO PERMET FER PINGS AL I26


#iptables -A INPUT -p icmp --icmp-type 8  -j DROP
#iptables -A OUTPUT -p icmp --icmp-type 8 -d 192.168.2.56 -j DROP 


#iptables -A OUTPUT -p icmp --icmp-type 0 -j DROP 

iptables -A INPUT -p icmp --icmp-type 0 -j DROP


