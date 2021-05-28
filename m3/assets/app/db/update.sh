#!/usr/bin/env bash

mvn --no-transfer-progress -f /autodb/db liquibase:update
