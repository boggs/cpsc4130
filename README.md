# Start Hadoop docker
docker run -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash

# Copy files onto docker image
docker cp map.rb {image_name}:/
docker cp reduce.rb {image_name}/

# run the twitter scraper
ruby ./twitter.rb

#stop the scraper when your happy
ctrl+c

# Grab the correct text out of the db
ruby ./search.rb

# move the data onto the server
docker cp data.txt {image_name}:/

# move your data onto the hdfs
hadoop fs -put /usr/share/dict/words input/

# connect to the docker image
docker exec -it {image_name} /bin/bash

# cd into the correct directory
cd /usr/local/hadoop

# run the map-reduce
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop-2.7.0/share/hadoop/tools/lib/hadoop-streaming-2.7.0.jar
 -mapper 'ruby /usr/local/hadoop/map.rb' -reducer 'ruby /usr/local/hadoop/reduce.rb' - file /usr/local/hadoop/map.rb -file /usr/local/hadoop/reduce.rb -input '/usr/local/data.txt' -output 'results'

