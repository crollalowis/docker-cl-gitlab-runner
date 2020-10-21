#!/bin/bash
service docker start
echo "DOCKER_HOST:     $(env | grep DOCKER_HOST)\n"