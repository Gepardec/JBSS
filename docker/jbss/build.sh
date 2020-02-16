cd `dirname $0`
cp ../../bin/jboss7 .

docker build -t gepardec/jbss:java8 .
