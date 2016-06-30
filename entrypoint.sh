#!/bin/bash

set -e

DOCKER_MACHINE_IP=$(ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print $2 }') php-fpm --allow-to-run-as-root
