#!/bin/bash
#set -x
action=$1
if [ "$action" = "" ]; then
    echo "Usage: $0 <start|restart|stop|status|down|logs|shell>"
    exit 1
fi
shift

curr_dir=`pwd`
cd `dirname $0`; script_dir=`pwd`; cd $curr_dir

cd $script_dir

if [ "$PROJECT_NAME" = "" ]; then
    PROJECT_NAME="privacera"
fi
PROJECT="-p $PROJECT_NAME"

if [ ! -d "$script_dir/opensearch/data" ]; then
    mkdir -p "$script_dir/opensearch/data"
fi

if [ ! -d "$script_dir/jupyter/data/securechat/sales/data" ]; then
    mkdir -p "$script_dir/jupyter/data/securechat/sales/data"
fi

if [ "$action" = "restart" ] || [ "$action" = "start" ]; then
    docker-compose $PROJECT up -d
    HOSTNAME=`hostname -i`
    ./wait-for-it.sh -t 120 $HOSTNAME:8888
    echo "Login using http://${HOSTNAME}:8888/lab/tree/work/opensearch_vectordb_setup.ipynb"
    echo "Token: welcome1"
fi

if [ $action == "stop" ]; then
    docker-compose $PROJECT stop
fi

if [ $action == "down" ]; then
    docker-compose $PROJECT down
fi

if [ $action == "status" ]; then
    docker-compose $PROJECT ps
fi

if [ "$action" = "logs" ]; then
    SERVICE=$1
    if [ "$SERVICE" = "" ]; then
        echo "ERROR: Service not provided"
        echo "Supported services [jupyter|opensearch-dashboards|opensearch-node1|opensearch-node2]"
        exit 1
    fi
    shift #service
    docker-compose $PROJECT logs $* $SERVICE
fi

if [ "$action" = "shell" ]; then
    SERVICE=$1
    if [ "$SERVICE" = "" ]; then
        echo "ERROR: Service not provided"
        echo "Supported services [jupyter|opensearch-dashboards|opensearch-node1|opensearch-node2]"
        exit 1
    fi
    shift #service
    docker-compose $PROJECT exec $* $SERVICE bash
fi
