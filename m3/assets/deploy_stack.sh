#!/bin/bash

stack_name=$1
app_dir=$2
expected_worker_count=$3

compose_file="$app_dir/docker-compose.yml"

# The location of docker-compose.yml configuration(s) 
echo "==> Changing location to $app_dir"
cd $app_dir

echo "==> Compose file configuration"
docker-compose config
docker-compose build && docker-compose push

_pid=$!
echo $_pid

while :
do
  managers_current_count=$(docker node ls --filter role=manager -q | wc -l)
  workers_current_count=$(docker node ls --filter role=worker -q | wc -l)
  current_node_count="$(($workers_current_count + $managers_current_count - 1))"
  if [ "$expected_worker_count" == "$current_node_count" ]; then
    echo "All nodes online boostraping stack [ $stack_name ]"
    # The -c <(docker-compose config) is used to load all envs from the .env file and
    # to join configurations from other compose files.
    docker-compose pull && docker stack deploy -c <(docker-compose config) $stack_name
    break
  else
    waiting_for="$(($expected_worker_count - $current_node_count))"
    echo "Waiting for ${waiting_for} nodes to connect"
    sleep 5
  fi
done

echo "==> Stack is deployed"