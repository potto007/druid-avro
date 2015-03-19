#!/bin/bash

#  Use DRUID_CLUSTER_NAME for all these "cluster name" type parameters if they aren't expliciltly set.
: ${ZK_BASE_PATH:=$DRUID_CLUSTER_NAME}
: ${METADATA_TABLE_BASE:=$DRUID_CLUSTER_NAME}
# This one will give an error like "-bash: /cluster_name_value: No such file or directory.  But it still sets the variable.
# TODO:  Figure out how to avoid the warning/execution
: ${SOURCE_PROCESS_CLUSTER:=/$DRUID_CLUSTER_NAME}

#  If not set, default to druid's normal default of overlord.
#  Only matters if running peons in remote mode (PEON_MODE=remote) instead of local.
: ${INDEXING_SERVICEMANAGER_NAME:=overlord}
#  Not sure if we want it prefixed by the ZK_BASE_PATH in the name? 
#  I think not?
# INDEXING_SERVICEMANAGER_NAME=${ZK_BASE_PATH}:${INDEXING_SERVICEMANAGER_NAME}

CP=/opt/druid/config/_common:/opt/druid/lib/*:/opt/druid/lib/logger/*
COMMON_JAVA_PROPS="-server -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Ddruid.host=${HOST}:${PORT} -Ddruid.port=${PORT} -Djava.io.tmpdir=/tmp -Ddruid.zk.service.host=${ZK_CONNECT} -Ddruid.zk.paths.base=${ZK_BASE_PATH} -Ddruid.discovery.curator.path=${ZK_BASE_PATH}/discovery -Ddruid.extensions.remoteRepository=[] -Ddruid.extensions.localRepository=/opt/druid/deps -Ddruid.extensions.coordinates=${EXTENSION_COORDINATES}"

if [ $1 = "historical" ]; then
	source $(dirname $0)/start-historical.sh
elif [ $1 = "broker" ]; then
	source $(dirname $0)/start-broker.sh
elif [ $1  = "coordinator" ]; then
	source $(dirname $0)/start-coordinator.sh
elif [ $1 = "realtime" ]; then
	source $(dirname $0)/start-realtime.sh
else echo "Usage:   ./start-service.sh <sevice_name>     where service_name in {historical, broker, coordinator, realtime} "
fi
