#!/bin/bash -e


sudo -EP /docker-entrypoint.sh nuxeoctl configure

exec "$@"
