#!/usr/bin/expect -d

set MS_IP   [lindex $argv 0 ]
set MS_PORT [lindex $argv 1 ]
set KEY1    [lindex $argv 2 ]
set PASS1   [lindex $argv 3 ]

set MS_LOG "/home/ms_check_config.log"

set timeout 60

spawn ssh -i $KEY1 -p $MS_PORT admin@$MS_IP

expect { 
	"(yes/no)? " { send "yes\r" }
	"Last login:*" { }
	timeout { exit 1 }
       }

set timeout 10

expect "]$ "
send "su -\r"
expect "Password: " 
send "$PASS1\r" 

expect {
	 "incorrect password*" { send "exit\r"; expect eof; exit 1 }
	 "]# " {}
       }

send "ps -ef|grep mediaserver > $MS_LOG\r"
expect "]# "

send "netstat -tlnp >> $MS_LOG\r"
expect "]# "

send "iptables -L -n >> $MS_LOG\r"
expect "]# "

send "cat /proc/`/sbin/pidof mediaserver`/limits|grep \"open files\" >> $MS_LOG\r"
expect "]# "

send "cat /home/mediaserver/etc/ms.conf | grep load_hvod_module >> $MS_LOG\r"
expect "]# "

send "cat /home/mediaserver/etc/ms.conf | grep speed_peer_upload_limit >> $MS_LOG\r"
expect "]# "

send "cat /home/mediaserver/etc/ms.conf | grep -E \"hvod_peer_max_speed|hvod_dld_max_speed|hvod_mp4head_max_speed|hvod_speed_fresh_interval|hvod_max_pending_package|hvod_free_speed_pos\" >> $MS_LOG\r"
expect "]# "

send "cat /home/mediaserver/etc/ms.conf | grep accepter_thread_num >> $MS_LOG\r"
expect "]# "

send "cat /home/mediaserver/etc/ms.conf | grep service_devices | grep -v service_devices_reload_interval  >> $MS_LOG\r"
expect "]# "

send "MEDIA_LIST=\`cat /home/mediaserver/etc/ms.conf | grep service_devices | grep -v service_devices_reload_interval | awk -F\"=\" '{print \$2}' `; for MEDIA in \$MEDIA_LIST; do ls \"\$MEDIA\" | sed \"s:^:\$MEDIA/:\" | head -n 2 >> $MS_LOG; done\r"
expect "]# "
#send "ls /media1 | head -n 5 >> $MS_LOG\r"
#expect "]# "

send "chown admin:admin $MS_LOG\r"
expect "]# "

send "exit\r"
expect "]$ "

send "exit\r"
expect eof

set timeout 60
spawn scp -i $KEY1 -P $MS_PORT admin@$MS_IP:$MS_LOG $MS_IP.log
expect "\r\n"
expect eof

