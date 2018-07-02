#!/usr/bin/env bash

DB_CONTAINER_NAME='postgres'
DB_USER='postgres'
DB_PASSWORD='postgres'
DB_DATABASE='vg'
DB_VERSION="10.4"

function getContainerId {
    docker container ls --all -q --filter name=$DB_CONTAINER_NAME
}

function isRunning {
    docker container inspect -f {{.State.Running}} $CONTAINER_ID
}

function cdDashy {
   #!/bin/bash
   parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

   echo "$parent_path"
   cd "$parent_path/.."
}

function dbCreate {
    local CONTAINER_ID=$(getContainerId)

    if [ -z "$CONTAINER_ID" ]
    then
        echo "Creating DB container"
        docker create -m 1024000000 --cpus 1 --name ${DB_CONTAINER_NAME} -e POSTGRES_PASSWORD=${DB_PASSWORD} -e POSTGRES_USER=${DB_USER} -e POSTGRES_DB=${DB_DATABASE} -p 5432:5432 postgres:${DB_VERSION} ;
    else
        echo "DB container already exists"
    fi
}

function dbStart {

    if [ -z "$(getContainerId)" ]
    then
        echo "DB container has not yet been created"
        dbCreate
    fi

    local CONTAINER_ID=$(getContainerId)

    if [ $(isRunning) != "false" ]
    then
        echo "DB container already running"
    else
        if [ -n "$CONTAINER_ID" ]
        then
            echo "Starting DB container"
            docker start $CONTAINER_ID
        fi
    fi
}

function dbStatus {
    local CONTAINER_ID=$(getContainerId)

    if [ -n "$CONTAINER_ID" ]
    then
        docker container ls --all --filter name=$DB_CONTAINER_NAME
    else
        echo "DB container has not yet been created"
    fi
}

function dbStop {
  local CONTAINER_ID=$(getContainerId)

  if [ -n "$CONTAINER_ID" ]
  then
    if [ $(isRunning) != "false" ]
    then
        echo "Stopping container $CONTAINER_ID"
        docker stop $CONTAINER_ID
    else
        echo "DB container was not running"
    fi
  else
    echo "DB container not found"
  fi
}

function dbKill {
  local CONTAINER_ID=$(getContainerId)

  if [ -n "$CONTAINER_ID" ]
  then
    if [ $(isRunning) != "false" ]
    then
        echo "Killing container $CONTAINER_ID"
        docker kill $CONTAINER_ID
    else
        echo "DB container was not running"
    fi
  else
    echo "DB container not found"
  fi
}

function dbRm {
  local CONTAINER_ID=$(getContainerId)

  if [ -n "$CONTAINER_ID" ]
  then
    echo "Removing container $CONTAINER_ID"
    docker rm $CONTAINER_ID
  else
    echo "DB container not found"
  fi
}

function dbClear {
  local CONTAINER_ID=$(getContainerId)

  if [ -n "$CONTAINER_ID" ]
  then
    dbKill
    dbRm
  else
    echo "DB container not found"
  fi
}

function help {
   echo "
        Help:

        clear: Truncates tables. (No migrations are run.)
        start: Start Postgres image.  (No migrations are run.)
        reset: Runs clear, then start.
        "
}

case $1 in
    "create")
        dbCreate
        ;;
    "start")
        dbStart
        ;;
    "status")
        dbStatus
        ;;
    "stop")
        dbStop
        ;;
    "kill")
        dbKill
        ;;
    "rm")
        dbRm
        ;;
    "clear")
        dbClear
        ;;
    "reset")
        dbClear
        dbStart
        ;;
    "help")
        help
        exit 0
        ;;
    "")
        help
        exit 0
        ;;
    *)
        echo "Unrecognized command(s)"
        help
        exit 0
        ;;

esac

