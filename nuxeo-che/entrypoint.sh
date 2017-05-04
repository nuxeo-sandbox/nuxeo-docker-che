#!/bin/bash -e


/docker-entrypoint.sh nuxeoctl configure

exec "$@"
