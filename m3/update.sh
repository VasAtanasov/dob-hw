#!/bin/bash

FILE=/tmp/worker.nodes

for node in `docker node ls --filter role=worker -q`; do
    if grep -Fxq "${node}" ${FILE}
    then
        echo "This node ${node} already exists"
    else
        echo "This node ${node} joined recently, so rebalance"
        docker service update ${web_service} --force --detach=false
    fi
done

docker node ls --filter role=worker -q > ${FILE}