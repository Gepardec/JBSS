CONFIG=`pwd`/../../configs/basic_setup/
JBOSS_RELEASE_NAME=jboss-eap-7.2.0
JBOSS_HOME=`pwd`/jboss/
DOWNLOADS=$HOME/Downloads

docker run \
    -v $JBOSS_HOME:/install/jboss/ \
    -v $CONFIG:/install/config/ \
    -v $DOWNLOADS:/install/Downloads \
    -e JBOSS_RELEASE_NAME=$JBOSS_RELEASE_NAME \
    -it erhardsiegl/jbss:java8 jbss configure /install/config

