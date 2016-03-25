#!/bin/sh

error=0

if [ -z "$JBossPackage" ]; then
	JBossPackage=$1
fi

if [ ! -f "$JBossPackage" ]; then
    echo "JBoss Package $JBossPackage doesn't exist! Set JBossPackage or use argument" 1>&2
    error=1
fi

if [ -z "$JBOSS_HOME" ]; then
	echo "Error: JBOSS_HOME not set!" 1>&2
	error=1
fi

if [ -e "$JBOSS_HOME" ]; then
    echo "$JBOSS_HOME exists, will not overwrite it. Remove it manually!" 1>&2
    error=1
fi

test $error = 0 || exit $error

TmpInstall=${JBOSS_HOME}_Tmp$$

unzip -d $TmpInstall $JBossPackage
mv $TmpInstall/* $JBOSS_HOME
rm -r $TmpInstall

cat README.txt
