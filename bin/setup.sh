#!/bin/bash

###########################
# instead of readlink -f
###########################
full_file_name() {
  mfile=$1
  if readlink --help >/dev/null 2>&1; then
    readlink -f $mfile
    return
  fi
  m_dir=`pwd`
  m_fdir=`dirname $mfile`
  m_file=`basename $mfile`
  cd $m_fdir
  r_file=`pwd`"/$m_file"
  cd $m_dir
  echo $r_file
}

# One-Time setup for a new JBoss instance
MY_PATH=`full_file_name $0`
BIN_DIR=`dirname $MY_PATH`
BASE_DIR=$BIN_DIR/..
CONFIGS_DIR=$BASE_DIR/configs
PRG=`basename $0`

JBOSS7=$BIN_DIR/jboss7

INSTANZ=myjboss
BIN="$HOME/bin"
PORT_OFFSET="0"
JBossPackage="$HOME/Downloads/jboss-eap-6.3.0.zip"
ReleaseName=wildfly-8.1.0.Final
DownloadsDir=$HOME/Downloads

useReleaseName=true

#####################################################################
##                              print_usage
#####################################################################
print_usage(){
cat <<EOF 1>&2

usage: $PRG [-h] [-i name] [-j jboss_home] [-b dir] [-o port_offset] [-z jboss_zip | -r release_name -d dir]

Options:
    i name: Name of jboss instance ($INSTANZ)
    j jboss_home: JBOSS_HOME ($JB_HOME)
    b bin: Directory where the link to jboss7 script will be created. 
           Should be in PATH. ($BIN)
    o port_offset: Port offset for this instance ($PORT_OFFSET)
    z jboss_zip: JBoss package zip-file.  ($JBossPackage) Must exist! (Deprecated, use -r and -d)
    r release_name: Name of Wildfly/EAP release.  ($ReleaseName) 
    d dir: Directory where we find the Wildfly/EAP zip-file. ($DownloadsDir)
    h: this help

Function:
	Sets up the basic environment to use JBoss Tools.
	These files will be created by this script:
	      $JBOSS_SKRIPT $RC_FILE
EOF
}

#####################################################################
##                              link_to_jboss7
#####################################################################
link_to_jboss7() {

	ln -s $JBOSS7 $1
}

######################   Optionen bestimmen ###################

while getopts "hi:j:b:o:z:r:d:" option
do
    case $option in
      h)
        PRINT_HELP="true";;
      i)
        INSTANZ=$OPTARG;;
      j)
        JB_HOME=$OPTARG;;
      b)
        BIN=$OPTARG;;
      o)
        PORT_OFFSET=$OPTARG;;
      z)
        JBossPackage=$OPTARG; useReleaseName=false;;
      r)
        ReleaseName=$OPTARG;;
      d)
        DownloadsDir=$OPTARG;;
      *)
        PRINT_HELP="true";;
    esac
done

shift `expr $OPTIND - 1`


##################### Beginn #########################

JBOSS_SKRIPT=$BIN/$INSTANZ
RC_FILE=$HOME/.${INSTANZ}rc

if [ x$JB_HOME = x ]; then
	JB_HOME='$HOME'/jboss-$INSTANZ
fi

if [ x$PRINT_HELP = xtrue ]; then
	print_usage
	exit 0
fi

if [ "x$useReleaseName" = xtrue ]; then
	JBossPackage="$DownloadsDir/${ReleaseName}.zip"
fi

if [ ! -f "$JBossPackage" ]; then
	echo "JBoss package ($JBossPackage) doesn't exist!" 1>&2
	echo "Download package or use other package with option '-d and -r'" 1>&2
	exit 1
fi

echo "JBOSS_SKRIPT is at $JBOSS_SKRIPT" 
echo "RC_FILE is at $RC_FILE" 
echo
echo Use:
echo 	Instance: $INSTANZ
echo 	JBOSS_HOME: $JB_HOME
echo 	JBossPackage: $JBossPackage
echo 	PORT_OFFSET: $PORT_OFFSET
echo 	ENV_CONFIG: ../environments/example

if [ ! -d "$BIN" ]; then
	mkdir -p $BIN
fi
ln -s $JBOSS7 $JBOSS_SKRIPT

if [ "x$useReleaseName" = xtrue ]; then
cat <<EOF > $RC_FILE
# Configuration for $INSTANZ
JBOSS_HOME=$JB_HOME
JBOSS_RELEASE_NAME=$ReleaseName
export JBossPackage=$DownloadsDir/\${JBOSS_RELEASE_NAME}.zip

PORT_OFFSET=$PORT_OFFSET

export ENV_CONFIG=../environments/example

EOF
else
cat <<EOF > $RC_FILE
# Configuration for $INSTANZ
JBOSS_HOME=$JB_HOME
export JBossPackage=$JBossPackage

PORT_OFFSET=$PORT_OFFSET

export ENV_CONFIG=../environments/example

EOF
fi

echo
echo Uninstall files with:
echo rm $JBOSS_SKRIPT $RC_FILE
echo
echo Install and start JBoss with:
echo $INSTANZ configure $CONFIGS_DIR/basic_setup
echo $INSTANZ configure $CONFIGS_DIR/database_with_template
echo $INSTANZ help
