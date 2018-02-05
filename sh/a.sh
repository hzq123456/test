#!/usr/bin/expect
#spawn ssh han@192.168.184.133
#expect "*password:"
#send "123\r"
#expect "*$"
#send "cd /tmp\r"
#send "./b.sh\r"
#send "123/r"

file_exit=-d ./a.sh
echo file_exit
#if { test } {
#       echo file exits
#   } else{
#         # do your things
#   }