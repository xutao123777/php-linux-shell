# php-linux-shell
运行PHP shell脚本


PHP二进制执行文件
phpbin="/www/server/php/56/bin/php"

网站根目录地址
progdir="/data/vhosts/www.btcbing.com"

PHP执行脚本程序
phpprog="/Home/Queue/check_eth_cb"

日志文件
logfile="$progdir/cli/logs/${pname}_${tme}.log"


Prog即Program, 一般计算机等专业在编写语言代码时经常用到这个简写。
Program：项目, 程序

crontab -e
50 23 * * * /www/wwwroot/button.vcall.io/cli/pairs.sh

查看计划任务
crontab -l
