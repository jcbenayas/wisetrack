#!/usr/bin/env python3
import sys
from alertaclient.api import Client
import logging
import re

logging.basicConfig(filename='ence2alerta.log', level=logging.DEBUG)
# Alerta client inicialization endpoint and key
client = Client(endpoint='http://localhost:8080/api', key='demo-key')
s = str(sys.argv)
warning = ["214","215","110","109"]
minor = ["118","117","116","115","114","113","213","113","108"]
major = ["015","016","017","018","019","020","021","022","023","024","026","031","032","033","034","035","036","048","111","124","125","199","202","203","206","207","110"]
try:
	mensaje = re.search("message=(.*?), fields",s).group(1)
	mensaje = mensaje.encode('utf-8', 'replace').decode()
	mensaje = mensaje.split('24;01H')[1]
	alarma = re.search("alarma=(.*?), gl2_source_node",s).group(1)
	alarma = alarma.encode('utf-8', 'replace').decode()
	ence = re.search("ence=(.*?), gl2_remote_ip",s).group(1)
	tipo = re.search("tipo=(.*?), gl2_accounted_message_size",s).group(1)[:3]
	codigo = re.search("codigo=(.*?), tipo",s).group(1)[-3:] 
	if codigo == "01H" : 
		codigo = "-"
	if alarma[:2] == "EO" :
		severidad = 'normal'
	elif tipo in warning :
		severidad = 'warning'
	elif tipo in minor :
		severidad = 'minor'
	elif tipo in major :
		severidad = 'major'
	else :
		severidad = 'critical'
except:
	logging.debug(mensaje)
	logging.debug(ence)
	logging.debug(tipo)
	logging.debug(codigo)
	logging.debug(alarma)
	logging.debug(severidad)

# Send notification to Alerta
client.send_alert(environment='Production', resource=tipo, event=alarma, value=codigo, severity=severidad, service=[ence], text=mensaje)
