#!/bin/bash

nodenum=

name=itnode$nodenum
workdir=~/nodes/it_node_$nodenum
conf=config.conf

function startNode() {
    status
    if [ $res -eq 0 ]
    then
        echo Node already running, pid $pid
    else
        ulimit -c unlimited
        if [ -d $workdir ]
        then
           cd $workdir

           if [ ! -f $workdir/$conf ]
           then
               echo "No config file $workdir/$conf found, exiting."
                          exit 2
           fi
		   
           echo Starting $name "$workdir/$name $workdir/$conf"
           $workdir/$name $workdir/$conf > /dev/null &
        else
           echo "workdir $workdir doesn't exists"
           exit 2;
        fi
    fi
}


function stopNode() {
    status
    if [ $res -ne 0 ]
	then
		echo Node not running
	else

        echo Stopping node, pid $pid
        kill -INT $pid
        sleep 10
        status

        if [ $res -eq 0 ]
        then
            echo Stop failed. Node still alive, pid $pid. Please check manually
        fi

	fi
}

function status() {

    pid=`pgrep -f $name`
    res=$?
}


case "$1" in
start)
    startNode
    ;;

stop)
    stopNode
    ;;

restart)
    stopNode
    startNode
    ;;

status)
     status

    if [ $res -ne 0 ]
       then
               echo -e "Node \e[31mnot running\e[0m"
       else
               echo -e "Node is \e[32mrunning\e[0m. Pid $pid"
       fi
     ;;

 *)
     echo "Usage: $0 start|stop|status|restart"
     exit 1
    ;;
esac

