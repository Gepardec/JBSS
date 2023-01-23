JBoss Setup Scripts
===================

The jbosstools are a collection of scripts and examples how to configure
Wildfly or JBoss EAP. 

Prerequisites
-------------
* The JBoss version must be 7 or higher.
* Unix-style OS. Tested on Linux (Fedora, RHEL, Ubuntu), Solaris

Quickstart
----------

1. Download the JBoss ZIP package (e.g. jboss-eap-6.4.0.zip) to $HOME/Downloads
2. Clone the Git-repository: `git clone https://github.com/Gepardec/JBSS.git`
3. Make sure that $HOME/bin is in the PATH (`export PATH=~/bin:$PATH`)

Run the following commands:

	cd JBSS
	bin/setup.sh -h
	bin/setup.sh -r jboss-eap-6.4.0
	myjboss configure configs/basic_setup
	myjboss configure configs/database_with_m4_template
	myjboss help

Point your browser to http://localhost:8080/seam-booking

How it works
------------

Each JBoss instance has a name (e.g: myjboss). The central script to manage an
instance is _jboss7_. You shouldn't use jboss7 directly. Instead you create 
a link instance -> jboss7. When you call the script, it looks under which name it
was called and reads an environment file $HOME/.instancerc (e.g: .myjbossrc). From this the basic environment
variables like `JBOSS_HOME` and `JBOSS_PORT_OFFSET` are obtained. Then the script can start/stop
JBoss and it can configure JBoss with help of jboss-cli.

The jboss7 Script
-----------------

From "myjboss -h"

    Usage: myjboss <command> [file]
 
    where <command> is one of:
        start       - start JBoss Server myjboss
        stop        - stop JBoss Server myjboss (kill)
        restart     - stoppen und starten
        status      - check wether JBoss Server myjboss is running
        admin       - starten von jboss-cli.sh
        deploy f    - copy file f to /home/esiegl/jboss-myjboss/standalone/deployments/
        configure f - configure server with file or directory f. Use >/home/esiegl/bin/myjboss configure< for more help.
        run f       - same as configure. Intended to run scripts within the specific environment.
        tear-down   - remove the whole installation! (rm -rf /home/esiegl/jboss-myjboss)
        log         - show logfile with tail -f
        out         - show console output with tail -f
        help        - this screen

From "myjboss configure"

    Usage: myjboss configure [ file | dir ]
      where the file-extension is in:
        conf    - file with commands for /home/esiegl/jboss-myjboss/bin/jboss-cli.sh --connect --controller=localhost:9999
        sh      - file with shell commands. JBOSS_HOME is exported.
        module  - Zip-file to be unpacked in /home/esiegl/jboss-myjboss/modules (deprecated, use zip instead)
        zip     - Zip-file to be unpacked in JBOSS_HOME (/home/esiegl/jboss-myjboss)
        restart - call /home/esiegl/bin/myjboss restart

    If the argument is a directory, it will be processed recursively.
    If there is a file 00_BOOTSTRAP in a directory, it will be processed before everything else. Eg. for handling templates.

