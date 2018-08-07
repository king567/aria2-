#!/bin/bash

###########################變數
touch="/bin/touch"
wget="/usr/bin/wget"
aria2_path="/root/.aria2"
aria2c="/usr/bin/aria2c"
Default_Path="/root"
New_Aria2_Version=$(wget --no-check-certificate -qO- https://api.github.com/repos/king567/Aria2-static-build-128-thread/releases | grep -o '"tag_name": ".*"' |head -n 1| sed 's/"//g;s/v//g'| sed 's/tag_name: //g' | sed 's/release-//g')
###########################
Conf_File ()
{
echo '## 被註釋的選項填寫的是默認值, 建議在需要修改時再取消註釋 ##
## 文件保存相關 ##
# 文件的保存路徑(可使用絕對路徑或相對路徑), 默認: 當前啟動位置
dir=~/downloads
# 啟用磁盤緩存, 0為禁用緩存, 需1.16以上版本, 默認:16M
disk-cache=32M
# 文件預分配方式, 能有效降低磁盤碎片, 默認:prealloc
# 預分配所需時間: none < falloc ? trunc < prealloc
# falloc和trunc則需要文件系統和內核支持
# NTFS建議使用falloc, EXT3/4建議trunc, MAC 下需要註釋此項
file-allocation=none
# 斷點續傳
continue=true

## 下載連接相關 ##

# 最大同時下載任務數, 運行時可修改, 默認:5
max-concurrent-downloads=10
# 同一服務器連接數, 添加時可指定, 默認:1
max-connection-per-server=5
# 最小文件分片大小, 添加時可指定, 取值範圍1M -1024M, 默認:20M
# 假定size=10M, 文件為20MiB 則使用兩個來源下載; 文件為15MiB 則使用一個來源下載
min-split-size=10M
# 單個任務最大線程數, 添加時可指定, 默認:5
split=32
# 整體下載速度限制, 運行時可修改, 默認:0
#max-overall-download-limit=0
# 單個任務下載速度限制, 默認:0
#max-download-limit=0
# 整體上傳速度限制, 運行時可修改, 默認:0
#max-overall-upload-limit=0
# 單個任務上傳速度限制, 默認:0
#max-upload-limit=0
# 禁用IPv6, 默認:false
#disable-ipv6=true
# 連接超時時間, 默認:60
#timeout=60
# 最大重試次數, 設置為0表示不限制重試次數, 默認:5
#max-tries=5
# 設置重試等待的秒數, 默認:0
#retry-wait=0

## 進度保存相關 ##

# 從會話文件中讀取下載任務
input-file=/root/.aria2/aria2.session
# 在Aria2退出時保存`錯誤/未完成`的下載任務到會話文件
save-session=/root/.aria2/aria2.session
# 定時保存會話, 0為退出時才保存, 需1.16.1以上版本, 默認:0
#save-session-interval=60

## RPC相關設置 ##

# 啟用RPC, 默認:false
enable-rpc=true
# 允許所有來源, 默認:false
rpc-allow-origin-all=true
# 允許非外部訪問, 默認:false
rpc-listen-all=true
# 事件輪詢方式, 取值:[epoll, kqueue, port, poll, select], 不同系統默認值不同
#event-poll=select
# RPC監聽端口, 端口被佔用時可以修改, 默認:6800
rpc-listen-port=6800
# 設置的RPC授權令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 選項
rpc-secret=Happydaygo4
# 設置的RPC訪問用戶名, 此選項新版已廢棄, 建議改用 --rpc-secret 選項
#rpc-user=<USER>
# 設置的RPC訪問密碼, 此選項新版已廢棄, 建議改用 --rpc-secret 選項
#rpc-passwd=<PASSWD>'
}
initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}
initializeANSI

kill_Aria2_Proccess ()
{
kill -9 `pgrep aria2c`
}
Init_Cond ()
{
echo '#!/bin/sh
### BEGIN INIT INFO
# Provides: aria2
# Required-Start: $remote_fs $network
# Required-Stop: $remote_fs $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Aria2 Downloader
### END INIT INFO
 
case "$1" in
start)
 
 echo -n "已開啟Aria2c"
 aria2c --conf-path="/root/.aria2/aria2.conf" -D

;;
stop)
 
 echo -n "已關閉Aria2c"
 kill -9 `pgrep aria2c`
;;
restart)
 
 kill -9 `pgrep aria2c`
 aria2c --conf-path="/root/.aria2/aria2.conf" -D
 
;;
esac
exit'
}

Systemd_Cond ()
{
echo "[Unit]
Description=Aria2 Service
[Service]
User=root
Type=forking
ExecStart=/usr/bin/sh /root/.aria2/start.sh
ExecStop=/bin/kill -9 `pgrep aria2c`
[Install]
WantedBy=multi-user.target"
}
Install_Aria2 ()
{
cd Default_Path
wget https://github.com/king567/Aria2-static-build-128-thread/releases/download/v${New_Aria2_Version}/aria2-v${New_Aria2_Version}-static-build-128-thread.tar.gz
wait
tar -zxvf aria2-v${New_Aria2_Version}-static-build-128-thread.tar.gz
mv aria2-v${New_Aria2_Version}-static-build-128-thread aria2
cd aria2
wait
sh install.sh
wait
if [ -d "${aria2_path}" ]; then
echo 'aria2 path have been exist'
else
mkdir ${aria2_path}
wait
fi
if [ -f "${aria2_path}/aria2.session" ]&&[ -f "${aria2_path}/aria2.log" ]&&[ -f "${aria2_path}/aria2.conf" ]; then
echo "aria2 aria2.session have been exist"
echo "aria2 aria2.aria2.log have been exist"
echo "aria2 aria2.aria2.conf have been exist"
else
touch ${aria2_path}/aria2.session && touch ${aria2_path}/aria2.log && touch ${aria2_path}/aria2.conf
echo "創建基本配置成功"
fi
Conf_File > /root/.aria2/aria2.conf
	echo "安裝成功"
	read -p "Press any key to continue." var
	
}

Start ()
{
aria2c --conf-path="/root/.aria2/aria2.conf" -D
wait
echo -e ${greenf}"\n啟動成功\n"${reset}
	read -p "Press any key to continue." var
}


centos7_add_boost_up ()
{
kill_Aria2_Proccess
touch ${aria2_path}/start.sh
if [ -d "/usr/lib/systemd/system" ];then
touch /usr/lib/systemd/system/aria2.service
else
mkdir /usr/lib/systemd/system && chmod 755 /usr/lib/systemd/system
touch /usr/lib/systemd/system/aria2.service && chmod 644 /usr/lib/systemd/system/aria2.service
fi
chmod +x ${aria2_path}/start.sh
chmod 644 /usr/lib/systemd/system/aria2.service
wait
echo "${aria2c}
ARIA2C_CONF_FILE="${aria2_path}/aria2.conf"
aria2c --conf-path="${aria2_path}/aria2.conf" -D" > ${aria2_path}/start.sh
wait
Systemd_Cond > /usr/lib/systemd/system/aria2.service
echo "Centos7添加開機自啟成功"
echo "相關指令為systemctl (start|status|stop|enable) aria2.service"
	read -p "Press any key to continue." var
}

Ubuntu_add_boost_up ()
{
touch /etc/init.d/aria2c
chmod 755 /etc/init.d/aria2c
Init_Cond > /etc/init.d/aria2c
update-rc.d aria2c defaults
echo "Ubuntu添加開機自啟成功"
echo "相關指令為service aria2c (start|stop|restart)"
read -p "Press any key to continue." var
}

Edit_Conf_file ()
{
vim ${aria2_path}/aria2.conf
wait
}

Uninstall ()
{
kill_Aria2_Proccess
wait
rm -rf ${aria2c}
rm -rf /usr/share/man/man1/aria2c.1/man-aria2c
rm -rf /usr/share/man/man1/aria2c.1
rm -rf /etc/ssl/certs/ca-certificates.crt 
rm -rf ${aria2_path}/aria2.session
rm -rf ${aria2_path}/aria2.log
rm -rf ${aria2_path}/aria2.conf
rm -rf ${aria2_path}/start.sh
rm -rf /usr/lib/systemd/system/aria2.service
rm -rf /etc/init.d/aria2c
rm -rf /root/aria2-1.33.1-linux-gnu-64bit-build1.tar.bz2
rm -rf /root/aria2
systemctl daemon-reload
echo -e ${greenf}"\n解除安裝完成\n"${reset}
read -p "Press any key to continue." var
}

Exit ()
{
read -p "Press any key to continue." var
break
}
Update_script ()
{
wget --no-check-certificate -qO- https://raw.githubusercontent.com/king567/aria2-one-click-byWIJ/master/aria2.sh > $0
echo -e ${greenf}"\n更新成功\n"${reset}
}
echo "(1).安裝aria2"
echo "(2).啟動aria2"
echo "(3).停止aria2"
echo "(4).將aria2加入開機啟動 for Centos7"
echo "(5).將aria2加入開機啟動 for Ubuntu"
echo "(6).編輯aria2設定檔"
echo "(7).解除安裝aria2"
echo "(8).更新腳本"
echo "(9).離開"
read -p "請輸入選項(1-8):" option
    case ${option} in
       1)
			Install_Aria2
         ;;
       2)
			Start
         ;;
       3)
			kill_Aria2_Proccess
         ;;
       4)
			centos7_add_boost_up
         ;;
       5)
			Ubuntu_add_boost_up
         ;;
       6)
			Edit_Conf_file
         ;;
       7)
			Uninstall
         ;;
       8)
			Update_script
         ;;
       9)
			Exit
         ;;
       *)
         echo -e ${redf}"\n輸入錯誤選項\n"${reset}
         ;;
    esac