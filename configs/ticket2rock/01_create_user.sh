RoleFile=$JBOSS_HOME/standalone/configuration/application-roles.properties

$JBOSS_HOME/bin/add-user.sh -u admin -p jboss@123 -r ManagementRealm
$JBOSS_HOME/bin/add-user.sh -a -u guest -p guest -r ApplicationRealm -g guest

#sed -i 's/^.*guest=.*/guest=guest/' $RoleFile
#sed -i 's/^.*guest=/#&/' $RoleFile
#echo  >> $RoleFile
#echo guest=guest >> $RoleFile
