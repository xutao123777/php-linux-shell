#!/bin/sh
echo "============`date +%F' '%T`==========="
phpbin="/www/server/php/56/bin/php"
progdir=$(cd $(dirname $0); pwd)
progdir="/data/vhosts/www.btcbing.com"
phpprog="/Home/Queue/check_eth_cb"
max_run_time=600
prog=`basename $0`
pname=${prog%.*}
pidfile="/tmp/${pname}.pid"
tme=$(date +%F)
logfile="$progdir/cli/logs/${pname}_${tme}.log"
cd $progdir

checkpid(){
  docmd="/bin/ps -ef |grep -v 'grep'|grep '$phpprog'|awk '{print \$2}'|xargs"
  #echo $docmd
  eval $docmd
}

start(){
   pidstr=`checkpid`
   if [ -z "$pidstr" ];then
      nohup $phpbin index.php $phpprog  >>$logfile 2>&1 &
     sleep 2
     echo "$prog staring pids with `checkpid`"
   else
     echo "$prog is running pids with $pidstr"
   fi
}

stop(){

   pidstr=`checkpid`
   if [ -n "$pidstr" ];then
          echo "will kill pids $pidstr"
          kill -3 $pidstr
   else
       echo "$prog is not running"
   fi
}

status(){
   pidstr=`checkpid`
   if [ -n "$pidstr" ];then
         echo "$prog is running with pids $pidstr"
   else
       echo "$prog is not running"
   fi
}


get_uptme()
{

  if [ -n "$1" ]; then
     ps h -p "$1" -o etime |awk '{split($0,a,":");split(a[1],b,"-"); if(length(a)>2){print (length(b)>1)?(b[1]*86400+b[2]*3600+a[2]*60+a[3]):(b[1]*3600+a[2]*60+a[3])}else{print a[1]*60+a[2]}}'
   else
     echo 0
   fi
}

check_utime()
{
        pids=$1
        for pid in $pids; do
            pid_uptime=$(get_uptme $pid);
            if [ -n "$pid_uptime" ] && [  ${pid_uptime} -ge $max_run_time ];then
                    echo "$pid running ${pid_uptime}  auto restart"
                    kill -9 $1
                    sleep 2
            else
                   echo "$pid is running ${pid_uptime}"
            fi
        done
}

check()
{
    pids="`checkpid`"
    if  [ -z "$pids" ];then
        start
    else
        check_utime "$pids"
        start
        echo "program $jsfile is running with pids $pids";
    fi
}

case "$1" in
  start)
        start
        RETVAL=$?
        ;;
  stop)
        stop
        RETVAL=$?
        ;;
  restart)
        stop
        sleep 2
        start
        RETVAL=$?
        ;;
  status)
     status
      ;;
  check)
    check
     ;;
   *)
    check     
   ;;
esac
