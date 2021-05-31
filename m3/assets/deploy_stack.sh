#!/bin/bash

stack_name=$1
compose_file=$2
expected_worker_count=$3

echo "==> Compose file configuration"
docker-compose -f $compose_file config

while :
do
  managers_current_count=$(docker node ls --filter role=manager -q | wc -l)
  workers_current_count=$(docker node ls --filter role=worker -q | wc -l)
  current_node_count="$(($workers_current_count + $managers_current_count - 1))"
  if [ "$expected_worker_count" == "$current_node_count" ]; then
    echo "All nodes online boostraping stack [ $stack_name ]"
    docker-compose -f $compose_file build && docker-compose -f $compose_file push
    # The -c <(docker-compose -f docker-compose.yml config) is used to load all envs from the .env file and
    # to join configurations from other compose files.
    docker-compose -f $compose_file pull && docker stack deploy -c <(docker-compose -f $compose_file config) $stack_name
    break
  else
    waiting_for="$(($expected_worker_count - $current_node_count))"
    echo "Waiting for ${waiting_for} nodes to connect"
  fi
  sleep 5
done
