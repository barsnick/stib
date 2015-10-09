#!/bin/sh
#
#  Copyright (c) 2013 I2SE GmbH
#

if [ $# -lt 1 ]; then
	cat >&2 <<EOU
Usage: $0 OTPVALUE [OUI]
  OTPVALUE        hex value of /sys/fsl_otp register
  OUI             separated with colons (8 chars)
EOU
	exit 1
fi

val="$1"
val=`printf "%08X" $((val))`
oui="00:00:00"

if [ "${#2}" == "8" ]; then
	oui="$2"
fi

byte2=`echo $val | cut -b 3-4`
byte3=`echo $val | cut -b 5-6`
byte4=`echo $val | cut -b 7-8`

echo "${oui}:${byte2}:${byte3}:${byte4}"

