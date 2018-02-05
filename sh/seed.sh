#!/usr/bin/env bash

tables=(event_rule attack_type)

artisan_path=/home/vagrant/Code/api_apt/web/artisan

for table in ${tables[@]};
do
#if [ -f /home/vagrant/Code/api_apt/web/database/seeds/TableSeeder ]
#    then
#    file_exit=1
#    else
#    file_exit=0
#fi
#echo $file_exit
/usr/bin/expect <<EOF  ###安装的expect的路径一般为/usr/bin/expect

spawn php $artisan_path  iseed $table
#if { $file_exit == 1} {
    expect "*:"  { send "yes\r"}
#}

expect "Created a seed file from table $table"

expect eof

EOF

done

echo --------------------------seed ok --------------------------------------