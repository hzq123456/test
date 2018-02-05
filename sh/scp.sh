#!/usr/bin/env bash

echo "helo"

password="123"
#不能在下面的expect脚本段设置成 set password xxxx否则获取不到变量，单独的expect脚本变量可以这样设置

/usr/bin/expect <<EOF  ###安装的expect的路径一般为/usr/bin/expect

spawn scp -rp /home/test/  han@192.168.184.133:/tmp/

expect "*password"  { send "$password\r"}

expect "100%"

expect eof

EOF

echo ------------------------scp ok-----------------------
