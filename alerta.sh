#!/bin/bash
# Notify by Alerta

#       Notify by Alerta for Check_MK
#       by Juan Carlos Benayas
#       v1.0 - 24 Feb 2020
#       Initial release.
#       This script sends an alarm notification from Check_MK to Alerta.

# Get data from Check_MK environment variables.
# Reference: http://mathias-kettner.de/checkmk_flexible_notifications.html#H1:Real World Notification Scripts

Token=demo-key
api='http://192.168.35.41:8080/api/alert'

if [ "$NOTIFY_WHAT" = "HOST" ]; then
	event="$NOTIFY_HOSTSTATE"
	service="$NOTIFY_HOSTNAME"
	message="$NOTIFY_HOSTOUTPUT"
	c1="DOWN"
        c2="UP"
	if [ "$NOTIFY_HOSTSTATE" = "DOWN" ]; then
        	severity="critical"
	elif [ "$NOTIFY_HOSTSTATE" = "UP" ]; then
		severity="ok"
	else
		severity="warning"
	fi
else
	event="$NOTIFY_SERVICESTATE"
	service="$NOTIFY_SERVICEDESC"
	message="$NOTIFY_SERVICEOUTPUT"
	if [ "$NOTIFY_SERVICESTATE" = "CRITICAL" ]; then
		c1="CRITICAL"
       		c2="OK"
                severity="critical"
        elif [ "$NOTIFY_SERVICESTATE" = "OK" ]; then
		c1="CRITICAL"
        	c2="OK"
                severity="ok"
        elif [ "$NOTIFY_SERVICESTATE" = "WARNING" ]; then
		c1="WARNING"
        	c2="OK"
                severity="warning"
        else
                c1="UNKNOWN"
                c2="OK"
		severity="unknown"
        fi

fi

echo $correlate

curl -XPOST $api \
-H 'Authorization: Key '$token'' \
-H 'Content-type: application/json' \
-d '{
      "correlate": [
        "'$c1'","'$c2'"
      ],
      "environment": "Development",
      "event": "'$event'",
      "group": "Argos",
      "origin": "'$OMD_SITE'",
      "resource": "'$NOTIFY_HOSTNAME'",
      "service": [
        "'"$service"'"
      ],
      "severity": "'$severity'",
      "text": "'"$message"'",
      "type": "Alert",
      "value": "'"$NOTIFY_NOTIFICATIONTYPE"'"
    }'

exit 0
