#!/bin/bash

# service_name=$1
# compose_file=$2
# expected_worker_count=$3
# current_count=$(docker node ls --filter role=worker -q | wc -l)

# echo 

# if [ "$expected_worker_count" == "$current_count" ]; then
#     docker stack deploy -c ${compose_file} ${service_name}
# fi

# start time
echo $(date +"%H:%M:%S")

# sleep for 5 seconds
sleep 5

# end time
echo $(date +"%H:%M:%S")
