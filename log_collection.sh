#This script collects system information
drawProgressBar() {
  local progress=$(( $1 * 100 / $2 ))
  local width=$(( $2 / 2 ))
  printf "["
  printf "%-${width}s" "$(printf "#%.0s" $(seq 1 $progress))"
  printf "%-$((width+1))s" "]"
  printf " %d%%" "$progress"
  printf "\r"
}

# Example usage
total=100

clear
echo -e "===================================="
echo "Surfly On-premise Log Collection Script."
echo
echo "Please inform Surfly Support Team (support@surfly.com) if you encounter an issue while running this script."
echo
echo "Logs collection started......"

CARRIAGE=`echo "\0015"`
SURVEY_MESSAGE="Starting..."; 
SURVEY_FILESIZE=0
SURVEY_GENERAL_PRODUCT=0
SURVEY_GETLOGS=0 
PRODUCT_IS_INSTALLED=1
SURVEY_OS_PACKAGELIST=""
SURVEY_NAV_PACKAGELIST=""
VER="1.0"
MYUID=`id|awk '{print $1}'|awk -F\( '{print $1}'|awk -F\= '{print $2}'`
SURVEY_MESSAGE="Collecting UserID Info";

if [ "$(id -u)" != "0" ]; then
   echo "Script version $VER"
   echo "Please run this script as the client user"
   exit
fi


SURVEY_MEMORY_INSTALLED=0
SURVEY_CENTOS_CHECK=0
SURVEY_FILESIZE=0

#declare -i SURVEY_MEMORY_INSTALLED
#declare -i SURVEY_CENTOS_CHECK
#declare -i SURVEY_FILESIZE
drawProgressBar 1 "$total"

UNAME=`uname -s`
SURVEY_MESSAGE="Determining OS"; 
case $UNAME in
        Linux)
                OS=linux
                HOSTNAME=`hostname -s`
				SURVEY_UID=$(id -u)
				SURVEY_UNAME=`id -un`
				SURVEY_PGID=`id -g`
				SURVEY_PGNAME=`id -gn`
				tmptest=`mount|grep /tmp|grep noexec | wc -l`
				tmptestout=`mount|grep /tmp|grep noexec`

                SURVEY_MESSAGE="Determining Hostname"; 

                SURVEY_CPU_COUNT=`cat /proc/cpuinfo |grep "model name"|wc -l`
                SURVEY_MESSAGE="Determining CPU Count"; 

                SURVEY_CPU_INFO=`cat /proc/cpuinfo |grep "model name"|awk -F: '{print $2}'|sed s/^\ //g|sort -u`
                SURVEY_MESSAGE="Determining CPU Type"; 

                SURVEY_MEMORY_INSTALLED=`grep MemTotal /proc/meminfo|awk '{print $2}'`
                #SURVEY_MEMORY_INSTALLED=`expr $SURVEY_MEMORY_INSTALLED \* 1`
                SURVEY_MESSAGE="Determining System Memory"; 
                SURVEY_MEMORY_INSTALLED=`expr $SURVEY_MEMORY_INSTALLED / 1021000`

                SURVEY_SYSTEM_UPTIME=`/usr/bin/uptime`
                SURVEY_MESSAGE="Determining System Uptime"; 

                SURVEY_FILESURVEY_SYSTEM_DF=`/bin/df -Ph | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting File System Consumption"; 

                SURVEY_FILESURVEY_SYSTEM_MOUNTS=`/bin/mount | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting File System Mount Points"; 

                SURVEY_NETWORKING_NETSTAT=`/bin/netstat -anpee 2>/dev/null | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting Network Activity (netstat -anpee)"; 
                   
                SURVEY_NETWORKING_NSLOOKUP=`nslookup $HOSTNAME`
                SURVEY_MESSAGE="Collecting nslookup information (nslookup `hostname`)"; 

                SURVEY_NETWORKING_STATS=`/bin/netstat -s 2>/dev/null | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting Networking Statistics (netstat -s)"; 

                SURVEY_NETWORKING_CONFIG=`/sbin/ifconfig -a 2>/dev/null | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting Network Config (ifconfig -a)"; 

                SURVEY_DETAILS_USERNAME=`id -un`
                
               
               drawProgressBar 5 "$total"


                SURVEY_MESSAGE="Collecting the list of running processes for this user"; 
                SURVEY_DETAILS_RUNNING_PROCESSES=`ps -ef | grep $USER | awk 'sub("$", "\r")'`

                SURVEY_OS_PACKAGELIST=`rpm -qa | sort | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting the packages installed to this system (rpm -qa)"; 

                SURVEY_CENTOS_CHECK=`/bin/rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH};%{DISTRIBUTION}\n'|grep -i centos|wc -l`
                #SURVEY_CENTOS_CHECK=`expr $SURVEY_CENTOS_CHECK \* 1`
                #SURVEY_CENTOS_CHECK=`/bin/rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH};%{DISTRIBUTION}\n'|grep -i "Red Hat"|wc -l`


		         HOSTNAME=`hostname|awk -F\. '{print $1}'`
                SURVEY_MESSAGE="Determining Hostname"; 

                SURVEY_SYSTEM_UPTIME=`/usr/bin/uptime`
                SURVEY_MESSAGE="Determining System Uptime"; 

                SURVEY_FILESURVEY_SYSTEM_DF=`df -h | sed s/$/${CARRIAGE}/`
                #SURVEY_FILESURVEY_SYSTEM_DF=`/usr/bin/df -h | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting File System Consumption"; 

                SURVEY_FILESURVEY_SYSTEM_MOUNTS=`mount |sed s/$/${CARRIAGE}/`
                #SURVEY_FILESURVEY_SYSTEM_MOUNTS=`/usr/sbin/mount | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting File System Mount Points"; 

                SURVEY_NETWORKING_NETSTAT=`netstat -an 2>/dev/null | sed s/$/${CARRIAGE}/`
                #SURVEY_NETWORKING_NETSTAT=`/usr/bin/netstat -an 2>/dev/null | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting Network Activity (netstat -anpee)"; 

                SURVEY_NETWORKING_STATS=`netstat -i 2>/dev/null | sed s/$/${CARRIAGE}/`
                #SURVEY_NETWORKING_STATS=`/usr/bin/netstat -i 2>/dev/null | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting Networking Statistics (netstat -s)"; 

                SURVEY_NETWORKING_CONFIG=`ifconfig -a 2>/dev/null | sed s/$/${CARRIAGE}/`
                #SURVEY_NETWORKING_CONFIG=`/usr/sbin/ifconfig -a 2>/dev/null | awk 'sub("$", "\r")'`
                SURVEY_MESSAGE="Collecting Network Config (ifconfig -a)"; 

                SURVEY_DETAILS_USERNAME=$USER

                SURVEY_MESSAGE="Counting the number of running processes for this user"; 
                SURVEY_DETAILS_RUNNING_PROCESSES_COUNT=`ps | wc -l`

                SURVEY_MESSAGE="Collecting the list of running processes for this user"; 
                SURVEY_DETAILS_RUNNING_PROCESSES=`ps -u $SURVEY_DETAILS_USERNAME -f | sed s/$/${CARRIAGE}/`
                #SURVEY_DETAILS_RUNNING_PROCESSES=`ps -u $SURVEY_DETAILS_USERNAME -f |awk 'sub("$", "\r")'`

                SURVEY_MESSAGE="Checking ansible version"; 
                SURVEY_DETAILS_ANSIBLE_VERSION_DETAILS=`ansible --version`

                SURVEY_MESSAGE="Checking ansible galaxy version"; 
                SURVEY_DETAILS_ANSIBLE_GALAXY_VERSION_DETAILS=`ansible-galaxy --version`

                ;;
esac

drawProgressBar 10 "$total"
sleep 0.1


### Post collection calculations
### End Post collection calculations

SURVEY_OUTDIR=`date '+log_collection-%m%d%y_%H%M%S'`"-"$HOSTNAME"-"$UNAME

SURVEY_STYLE="<style>table { font-size: 14px; } </style>"

SURVEY_LOGSFOUND=0
mkdir $SURVEY_OUTDIR
mkdir $SURVEY_OUTDIR/content
mkdir -p $SURVEY_OUTDIR/files

drawProgressBar 20 "$total"
sleep 0.1

drawProgressBar 30 "$total"
sleep 0.1


SURVEY_SOURCE="/opt/nginx/logs/error.log"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL="Nginx Logs"
   SURVEY_TARGETFILE=nginx.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_PROFILE="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
  
fi



SURVEY_SOURCE="$HOME/.profile"
if [ -s $SURVEY_SOURCE ]; then
##echo "Collecting $SURVEY_SOURCE"
   SURVEY_TARGETLABEL="~/.profile"
   SURVEY_TARGETFILE=Profile.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
fi

SURVEY_SOURCE="/opt/trafficserver/logs/ats_surfly.log"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL="ATS Surfly Logs"
   SURVEY_TARGETFILE=ats_surfly.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
   
fi

SURVEY_SOURCE="/opt/trafficserver/logs/diags.log"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL="ATS Diags Logs"
   SURVEY_TARGETFILE=ats_diags.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
   
fi

SURVEY_SOURCE="/opt/trafficserver/logs/error*"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL="ATS ERROR Logs"
   SURVEY_TARGETFILE=ats_error.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
   
fi

SURVEY_SOURCE="/opt/trafficserver/logs/manager.log"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL="ATS Manager Logs"
   SURVEY_TARGETFILE=ats_manager.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
   
fi


service_name="ss-surfly.target"

# Get dependent services
dependencies=$(systemctl list-dependencies $service_name --plain | awk '{print $1}')

# Iterate over dependent services and display their journal logs
for dependency in $dependencies; do
    sudo journalctl -u $dependency > $SURVEY_TARGET
   SURVEY_TARGETLABEL=$dependency
   SURVEY_TARGETFILE=$dependency+".txt"
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
done

drawProgressBar 35 "$total"
sleep 0.1

unset SURVEY_TARGET
output=$(curl -s -x http://127.0.0.1:8080 https://google.com/ -v -m 55 2>&1)
SURVEY_TARGETLABEL="CURL TEST"
SURVEY_TARGETFILE=curl.txt
SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
echo $output > $SURVEY_TARGET
SURVEY_NAV_PROFILE=$SURVEY_NAV_PROFILE+"<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"



SURVEY_SOURCE="$HOME/.bash_profile"
if [ -s $SURVEY_SOURCE ]; then
##echo "Collecting $SURVEY_SOURCE"
   SURVEY_TARGETLABEL="~/.bash_profile"
   SURVEY_TARGETFILE=BASH_Profile.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_BASH_PROFILE="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
fi

#/etc/resolv.conf
SURVEY_SOURCE="/etc/resolv.conf"
##echo "Collecting $SURVEY_SOURCE"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL=/etc/resolv.conf
   SURVEY_TARGETFILE=resolv.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   echo "" >> $SURVEY_TARGET
   cat $SURVEY_SOURCE >> $SURVEY_TARGET
   SURVEY_NAV_RESOLVFILE="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
fi

#/etc/hosts
SURVEY_SOURCE="/etc/hosts"
##echo "Collecting $SURVEY_SOURCE"
if [ -s $SURVEY_SOURCE ]; then
   SURVEY_TARGETLABEL=/etc/hosts
   SURVEY_TARGETFILE=hosts.txt
   SURVEY_TARGET=$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
   echo "It is critical that any given hostname resovle to one and only 1 ip address, hosts file is below:" >> $SURVEY_TARGET
   echo "" >> $SURVEY_TARGET
   cat $SURVEY_SOURCE >> $SURVEY_TARGET
   SURVEY_NAV_HOSTSFILE="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
fi

drawProgressBar 40 "$total"
sleep 0.1


SURVEY_SOURCE="/etc/redhat-release"
if [ -s $SURVEY_SOURCE ]; then
##echo "Collecting $SURVEY_SOURCE"
   LINUXFLAVOR=`cat $SURVEY_SOURCE`
fi

SURVEY_SOURCE="/proc/meminfo"
if [ -s $SURVEY_SOURCE ]; then
##echo "Collecting $SURVEY_SOURCE"
   SURVEY_TARGETLABEL="Memory Info"
   SURVEY_TARGETFILE="meminfo.txt"
   SURVEY_TARGET="$SURVEY_OUTDIR/files/$SURVEY_TARGETFILE"
   cp $SURVEY_SOURCE $SURVEY_TARGET
   SURVEY_NAV_MEMINFO="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
fi

drawProgressBar 50 "$total"
sleep 0.1

drawProgressBar 60 "$total"
sleep 0.1


SURVEY_TARGETLABEL="Network - ifconfig"
##echo "Collecting $SURVEY_TARGETLABEL"
SURVEY_TARGETFILE=ifconfig.txt
echo $SURVEY_NETWORKING_CONFIG > $SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
SURVEY_NAV_NETWORKCONFIG="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
SURVEY_NETWORKING_CONFIG=""

## End Networking details
############################

drawProgressBar 70 "$total"
sleep 0.1


SURVEY_TARGETLABEL="Packages Installed"
SURVEY_TARGETFILE=rpmlist.txt
##echo "Collecting $SURVEY_TARGETLABEL"
echo $SURVEY_OS_PACKAGELIST > $SURVEY_OUTDIR/files/$SURVEY_TARGETFILE
SURVEY_NAV_PACKAGELIST="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"
SURVEY_OS_PACKAGELIST=""


#########################
## BEGIN File System Details ##

echo "##########################" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "## output of df command ##" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "##########################" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "" >> $SURVEY_OUTDIR/files/filesystem.txt
echo $SURVEY_FILESURVEY_SYSTEM_DF >> $SURVEY_OUTDIR/files/filesystem.txt
echo "" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "#############################" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "## output of mount command ##" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "#############################" >> $SURVEY_OUTDIR/files/filesystem.txt
echo "" >> $SURVEY_OUTDIR/files/filesystem.txt
echo $SURVEY_FILESURVEY_SYSTEM_MOUNTS >> $SURVEY_OUTDIR/files/filesystem.txt
SURVEY_NAV_SURVEY_FILESYSTEM="<li><a href=../files/filesystem.txt target=main>File system details</a>"

SURVEY_FILESURVEY_SYSTEM_DF=""
SURVEY_FILESURVEY_SYSTEM_MOUNTS=""

## END File System Details ##
#########################

########################
## Begin Environment Info

drawProgressBar 80 "$total"
sleep 0.1


#SURVEY_TARGETLABEL="History"
#SURVEY_TARGETFILE=history.txt
##echo "Collecting command history"
#history > $SURVEY_OUTDIR/files/$SURVEY_TARGETFILE 2>&1
#SURVEY_NAV_HISTORY="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"

SURVEY_TARGETLABEL="Current Locales"
SURVEY_TARGETFILE=locale.txt
##echo "Collecting $SURVEY_TARGETLABEL"
/usr/bin/locale >> $SURVEY_OUTDIR/files/$SURVEY_TARGETFILE 2>&1
SURVEY_NAV_LOCALE="<li><a href=../files/$SURVEY_TARGETFILE target=main>$SURVEY_TARGETLABEL</a>"



drawProgressBar 90 "$total"
sleep 0.1


## End Environment Info
########################

drawProgressBar 95 "$total"
sleep 0.1

###################################################
###### Final steps, create the html elements ######
echo "<html>" > $SURVEY_OUTDIR/index.html
echo "<head>" >> $SURVEY_OUTDIR/index.html
echo "<title>$HOSTNAME details</title>" >> $SURVEY_OUTDIR/index.html
echo "</head>" >> $SURVEY_OUTDIR/index.html
echo "<frameset rows=\"100,*\" frameborder=\"1\" border=\"0\" framespacing=\"0\">" >> $SURVEY_OUTDIR/index.html
echo "  <frame name=\"top\" src=\"content/survey.html\">" >> $SURVEY_OUTDIR/index.html
echo "<frameset cols=\"200,*\" frameborder=\"1\" border=\"0\" framespacing=\"0\">" >> $SURVEY_OUTDIR/index.html
echo "	<frame name=\"left\" src=\"content/nav.html\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"auto\" >" >> $SURVEY_OUTDIR/index.html
echo "	<frame name=\"main\" src=\"content/main.html\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"auto\" >" >> $SURVEY_OUTDIR/index.html
echo "</frameset>" >> $SURVEY_OUTDIR/index.html
echo "</frameset>" >> $SURVEY_OUTDIR/index.html
echo "</html>" >> $SURVEY_OUTDIR/index.html

echo "<html>" > $SURVEY_OUTDIR/content/main.html
echo "<head>" >> $SURVEY_OUTDIR/content/main.html
echo "</head>" >> $SURVEY_OUTDIR/content/main.html
echo "<body>" >> $SURVEY_OUTDIR/content/main.html
#fill this area in with general system info, like OS brand and version, cpu details, memory amount, hostname, fqdn, and so on.  A quick overview of the host.
echo "<table align=center width=100%>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td colspan=2 align=center>General Environment Information</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td width=150>Hostname:</td><td>"`hostname`"</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td >System Uptime</td><td>$SURVEY_SYSTEM_UPTIME</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td >Operating System</td><td>$UNAME</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td>CPU Details</td><td>$SURVEY_CPU_COUNT x $SURVEY_CPU_INFO</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td >Ansible Details</td><td>$SURVEY_DETAILS_ANSIBLE_VERSION_DETAILS</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td >Ansible Galaxy Details</td><td>$SURVEY_DETAILS_ANSIBLE_GALAXY_VERSION_DETAILS</td></tr>" >> $SURVEY_OUTDIR/content/main.html
echo "<tr><td>Installed RAM</td><td>$SURVEY_MEMORY_INSTALLED</td></tr>" >> $SURVEY_OUTDIR/content/main.html
if [ $OS = 'linux' ]; then 
   echo "<tr><td>Linux Release</td><td>$LINUXFLAVOR</td></tr>" >> $SURVEY_OUTDIR/content/main.html
   if [ -s $SURVEY_OUTDIR/files/CENTOS.txt ]; then
      echo $SURVEY_CENTOS_ALERT >> $SURVEY_OUTDIR/content/main.html
   fi
fi

echo "</table>" >> $SURVEY_OUTDIR/content/main.html
echo "</body>" >> $SURVEY_OUTDIR/content/main.html
echo "</html>" >> $SURVEY_OUTDIR/content/main.html

echo "<html>" > $SURVEY_OUTDIR/content/survey.html
echo "<head>$SURVEY_STYLE</head>" >> $SURVEY_OUTDIR/content/survey.html
echo "<body>" >> $SURVEY_OUTDIR/content/survey.html
echo "<table align=center width=100% >" >> $SURVEY_OUTDIR/content/survey.html
echo "<tr><td align=left>Survey Script Details<br>Version: $VER<br></td><td valign=top>" >> $SURVEY_OUTDIR/content/survey.html
echo "   <table>" >> $SURVEY_OUTDIR/content/survey.html
echo "      <tr><td align=right><b>Run Date</b></td><td align=center>"`date`"</td></tr>" >> $SURVEY_OUTDIR/content/survey.html
echo "      <tr><td align=right><b>Run From</b></td><td align=center>"`ls -ld $PWD`"</td></tr>" >> $SURVEY_OUTDIR/content/survey.html
echo "      <tr><td align=right><b>Run by user</b></td><td align=center>"`id`"</td></tr>" >> $SURVEY_OUTDIR/content/survey.html
echo "   </table>" >> $SURVEY_OUTDIR/content/survey.html
echo "</td></tr>" >> $SURVEY_OUTDIR/content/survey.html
echo "</table>" >> $SURVEY_OUTDIR/content/survey.html
echo "</body>" >> $SURVEY_OUTDIR/content/survey.html
echo "</html>" >> $SURVEY_OUTDIR/content/survey.html


SURVEY_NAV=$SURVEY_OUTDIR/content/nav.html

SURVEY_NAV_GROUP_HOSTINFO="<hr>Host Information<br>"`hostname`"<hr>"
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO"<li><a href=main.html target=main>Host Specs</a>"
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_NETWORKCONFIG
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_NETWORKSTATS
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_HOSTSFILE
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_RESOLVFILE
if [ $OS = 'linux' ]; then SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_NSSWITCHFILE; fi
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_MEMINFO
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_SURVEY_FILESYSTEM
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_PROCESSLIST
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_LOCALE
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_LOCALES
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_PACKAGELIST

SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_PROFILE
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_BASH_PROFILE
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_MISC
SURVEY_NAV_GROUP_HOSTINFO=$SURVEY_NAV_GROUP_HOSTINFO$SURVEY_NAV_PRESOURCE_ENV

echo "<html>" > $SURVEY_NAV
echo "<head>" >> $SURVEY_NAV
echo "</head>" >> $SURVEY_NAV
echo "<body>" >> $SURVEY_NAV
echo $SURVEY_NAV_GROUP_HOSTINFO >> $SURVEY_NAV
echo $SURVEY_NAV_GROUP_PRODUCTINFO >> $SURVEY_NAV
echo "</body>" >> $SURVEY_NAV
echo "</html>" >> $SURVEY_NAV

drawProgressBar 100 "$total"
sleep 0.1


######################################
# if done with editing the script, 
# remark this next line out
#exit
######################################

SURVEY_FINAL_OUTPUT=${SURVEY_OUTDIR}.tar
tar -cf $SURVEY_FINAL_OUTPUT $SURVEY_OUTDIR
gzip $SURVEY_FINAL_OUTPUT
SURVEY_FINAL_OUTPUT=${SURVEY_FINAL_OUTPUT}.gz
rm -rf $SURVEY_OUTDIR
#


SURVEY_FILESIZE=`ls -s ${SURVEY_FINAL_OUTPUT}|awk '{print $1}'`
echo "################################"
echo
echo -e "Thank you for running this script.  Required logs have been collected into file ${SURVEY_FINAL_OUTPUT}"
echo
echo -e "Please get this file from your server and share with the Surfly Support team"
