cd `dirname $0`
cp ../../bin/jboss7 .

docker build -t erhardsiegl/jbss:java8 .
