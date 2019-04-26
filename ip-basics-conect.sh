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

################ conections related,  established ##############

# PERMETRE NAVEGAR WEB, dialag de conexio
# regla mal feta
  #iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
  #iptables -A INPUT -p tcp --sport 80 -j ACCEPT
# no saben el port de sortida per tant hem de utilitzar el mateix port 80 com port origen

# FILTRA EL TRAFIC QUE NOMES SIGUI DE RESPOSTA 

#iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
# AIXO VOL DIR QUE LAS RESPOSTES SERAN NOMES DE LA CONEXION QUE HEM INICIAT
#iptables -A INPUT -p tcp --sport 80 \
#       -m state --state RELATED,ESTABLISHED -j ACCEPT



# SOM UN SERVIDOR WEB, SOLO PERMITIMOS RESPUESTAS A LAS CONEXIONS ESTABLERTAS
#iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 80 \
#       -m state --state RELATED,ESTABLISHED -j ACCEPT

# SERVIDOR WEB FUNCIONI (CONSULTAR TOTHOM) EXCEPTO EL I26


iptables -A INPUT -p tcp --dport 80 -s 192.168.2.56 -j REJECT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 \
       -m state --state RELATED,ESTABLISHED -j ACCEPT


