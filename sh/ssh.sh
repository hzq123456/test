#!/usr/bin/expect
spawn ssh han@192.168.184.133
expect "*password:"
send "123\r"
expect "*#"
interact
