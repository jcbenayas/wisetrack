# Este script se añade al home del usuario root del router y se crea una línea en el crontab para que se ejecute cada minuto: 
# "* * * * * /bin/sh /root/ttcgw.sh > /dev/null"
# Cambiar "ipdestino" por la IP del SAMTTC remoto
/usr/bin/socat UDP4-RECVFROM:3000,fork UDP4-SENDTO:ipdestino:3000
