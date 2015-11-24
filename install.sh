#!/bin/bash

#
#      _____            _                    _     _       _      _____ _                 _
#     /  __ \          | |                  | |   (_)     | |    /  __ \ |               | |
#     | /  \/ ___ _ __ | |_ _   _ _ __ _   _| |    _ _ __ | | __ | /  \/ | ___  _   _  __| |
#     | |    / _ \ '_ \| __| | | | '__| | | | |   | | '_ \| |/ / | |   | |/ _ \| | | |/ _` |
#     | \__/\  __/ | | | |_| |_| | |  | |_| | |___| | | | |   <  | \__/\ | (_) | |_| | (_| |
#      \____/\___|_| |_|\__|\__,_|_|   \__, \_____/_|_| |_|_|\_\  \____/_|\___/ \__,_|\__,_|
#                                        __/ |
#                                       |___/
#
#    Blueprint package install.sh template generated via:
#    http://centurylinkcloud.github.io/blueprint-package-manifest-builder/
#
# Set variables configured in package.manifest
#T3.SERVER.IPADDRESS="${1}"
EMAILREPORTTO="${2}"

################################################################################
# CLC_Blueprint_CentOS6_yum_check-update
# Description:
#    For use with the CenturyLink Cloud Blueprint system
#    Emails a report after applying updates available for CentOS6
# Version 1.0 November 16, 2015 ErnestGWilsonII@gmail.com
#         yum_upgrade_centos6x.zip
################################################################################


################################################################################
# Verify that mailx is installed and if not quickly install it for reporting
/usr/bin/which mailx
if [ $? -eq 1 ]; then /usr/bin/yum -y install mailx > /dev/null 2>&1; fi
################################################################################

################################################################################
# Verify that unix2dos is installed and if not quickly install it for reporting
/usr/bin/which unix2dos
if [ $? -eq 1 ]; then /usr/bin/yum -y install unix2dos > /dev/null 2>&1; fi
################################################################################

################################################################################
# Create a new log file $LOGFILE
################################

# Get the current date and time from the server
REPORTTIME=$(/bin/date)

# Get the hostname from the server
THISHOST=$(/bin/hostname)

# Get the uptime from the server
UPTIME=$(/usr/bin/uptime)

# Setup file naming
FILEPATH="/tmp/"
LOGSUFFIX="_log.txt"
REPORTSUFFIX="_report.txt"
LOGFILE="$FILEPATH$THISHOST$LOGSUFFIX"
REPORTFILE="$FILEPATH$THISHOST$REPORTSUFFIX"

# Clear out any existing log file and start clean
/bin/echo "" > $LOGFILE
/bin/rm -f $LOGFILE
/bin/touch $LOGFILE

# Log the start date and time
/bin/echo "Report: $REPORTTIME" >> $LOGFILE
/bin/echo "################################################################################" >> $LOGFILE
/bin/echo "Hostname: $THISHOST" >> $LOGFILE
/bin/echo "Uptime:$UPTIME" >> $LOGFILE
/bin/echo "" >> $LOGFILE
/bin/echo "Blueprint Variables:" >> $LOGFILE
/bin/echo "T3.SERVER.IPADDRESS=$1" >> $LOGFILE
/bin/echo "EMAILREPORTTO=$EMAILREPORTTO" >> $LOGFILE
/bin/echo "################################################################################" >> $LOGFILE
################################################################################


################################################################################
# Create a new report file $REPORTFILE
######################################

# Clear out any existing report file and start clean
/bin/echo "" > $REPORTFILE
/bin/rm -f $REPORTFILE
/bin/touch $REPORTFILE

# Create the report header
/bin/echo "################################################################################" >> $REPORTFILE
/bin/echo "# REPORT #" >> $REPORTFILE
/bin/echo "##########" >> $REPORTFILE
/bin/echo " Hostname: $THISHOST" >> $REPORTFILE
/bin/echo "       IP: $1" >> $REPORTFILE
/bin/echo "     Date: $REPORTTIME" >> $REPORTFILE
/bin/echo "   Uptime:$UPTIME" >> $REPORTFILE
/bin/echo "################################################################################" >> $REPORTFILE
/bin/echo " " >> $REPORTFILE

# Install all available updates via yum -y upgrade
/bin/echo "################################################################################" >> $REPORTFILE
/bin/echo "# List of applied updates for this OS:" >> $REPORTFILE
/bin/echo "######################################" >> $REPORTFILE
/usr/bin/yum -y upgrade >> $REPORTFILE 2>&1
/bin/echo "################################################################################" >> $REPORTFILE
/bin/echo "" >> $REPORTFILE
/bin/echo "" >> $REPORTFILE

# Get a list of currently installed packages on this OS
/bin/echo "################################################################################" >> $REPORTFILE
/bin/echo "# List of currently installed packages on this OS:" >> $REPORTFILE
/bin/echo "##################################################" >> $REPORTFILE
/bin/rpm -qa | /bin/sort >> $REPORTFILE
/bin/echo "################################################################################" >> $REPORTFILE
/bin/echo "" >> $REPORTFILE
/bin/echo "" >> $REPORTFILE
################################################################################


################################################################################
# Make sure the report is formatted for Windows via unix2dos
/usr/bin/unix2dos $REPORTFILE > /dev/null 2>&1
# Email the blueprint log and report for this server
/bin/cat $LOGFILE | /bin/mailx -s "Blueprint Report: List of applied updates for: $THISHOST at $1" -a $REPORTFILE $EMAILREPORTTO