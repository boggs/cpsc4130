# Running instructions
## Setup Docker
Get the hadoop docker image
```sh
docker pull sequenceiq/hadoop-docker:2.7.1
```

Start Hadoop docker
```sh
docker run -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
```

Find docker instance name
```
docker ps
```

Copy files onto docker image
```sh
docker cp map.rb {instance_name}:/usr/local/hadoop/
docker cp reduce.rb {instance_name}:/usr/local/hadoop/
docker cp ruby-2.3.1.tar.gz {instance_name}:/usr/local/hadoop/
```

Connect to docker instance
```sh
docker exec -it {instance_name} /bin/bash
```

Install ruby
```sh
cd /
tar -xvf ruby-2.3.1.tar.gz
cd ruby-2.3.1
./configure
make
sudo make install
```
## Getting the data
run the twitter scraper
```sh
ruby ./twitter.rb
```

stop the scraper when your happy
```
ctrl+c
```

Grab the correct text out of the db
```sh
ruby ./search.rb 'trump'
```

move the data onto the server
```sh
docker cp results.txt {instance_name}:/usr/local/hadoop/
```

connect to the docker image
```sh
docker exec -it {instance_name} /bin/bash
cd /usr/local/hadoop
```

move your data onto the hdfs
```sh
hadoop fs -put results.txt
```
run the map-reduce
```sh
bin/hadoop jar /usr/local/hadoop-2.7.0/share/hadoop/tools/lib/hadoop-streaming-2.7.0.jar -mapper 'ruby map.rb' -reducer 'ruby reduce.rb' -file ./map.rb -file ./reduce.rb -file ./results.txt -file ./sentiment_lexicon.yml -input 'results.txt' -output 'results'
```

Read the results
```sh
bin/hadoop fs -cat results/part-00000
```
