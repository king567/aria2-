#!/bin/bash
until false 
do
echo "(1).安裝aria2"
echo "(2).啟動aria2"
echo "(3).停止aria2"
echo "(4).將aria2加入開機啟動 for Centos7"
echo "(5).將aria2加入開機啟動 for Ubuntu"
echo "(6).編輯aria2設定檔"
echo "(7).離開"
read -p "請輸入選項(1-7):" option
touch="/bin/touch"
wget="/usr/bin/wget"
aria2_path="/root/.aria2"
case ${option} in
	1)
wget https://github.com/q3aql/aria2-static-builds/releases/download/v1.33.1/aria2-1.33.1-linux-gnu-64bit-build1.tar.bz2
wait
tar -jxvf aria2-1.33.1-linux-gnu-64bit-build1.tar.bz2
wait
mv  aria2-1.33.1-linux-gnu-64bit-build1 aria2
wait
cd aria2
wait
make install
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
touch ${aria2_path}/aria2.session || continue
wait
touch ${aria2_path}/aria2.log || continue
wait
touch ${aria2_path}/aria2.conf || continue
wait
fi

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
#rpc-passwd=<PASSWD>' > /root/.aria2/aria2.conf
	echo "安裝成功"
	read -p "Press any key to continue." var
	clear
	;;
	2)
aria2c --conf-path="/root/.aria2/aria2.conf" -D
wait
echo "啟動成功"
	read -p "Press any key to continue." var
	clear
	;;
	3)
if [ -f "/usr/bin/killall" ]; then
continue
else
echo "安裝killall中..."
yum install psmisc -y || apt-get  -y install psmisc 
wait
echo "安裝killall成功"
fi
killall aria2c
wait
echo "已關閉aria2"
	read -p "Press any key to continue." var
	clear
	;;
	4)
if [ -f "/usr/bin/killall" ]; then
continue
else
echo "安裝killall中..."
yum install psmisc -y
wait
echo "安裝killall成功"
fi
touch ${aria2_path}/start.sh
touch /usr/lib/systemd/system/aria2.service
wait
chmod +x ${aria2_path}/start.sh
chmod 754 /usr/lib/systemd/system/aria2.service
wait
echo "aria2c="/usr/bin/aria2c"
ARIA2C_CONF_FILE="${aria2_path}/aria2.conf"
aria2c --conf-path="${aria2_path}/aria2.conf" -D" > ${aria2_path}/start.sh
wait
echo "[Unit]
Description=Aria2 Service
[Service]
User=root
Type=forking
ExecStart=/usr/bin/sh /root/.aria2/start.sh
ExecStop=/usr/bin/killall aria2c
[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/aria2.service
echo "Centos7添加開機自啟成功"
echo "相關指令為systemctl (start|status|stop|enable) aria2.service"
	read -p "Press any key to continue." var
	clear
	;;
	5)
	
touch /etc/init.d/aria2c
chmod 755 /etc/init.d/aria2c

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
 killall aria2c
;;
restart)
 
 killall aria2c
 aria2c --conf-path="/root/.aria2/aria2.conf" -D
 
;;
esac
exit' > /etc/init.d/aria2c
wait
update-rc.d aria2c defaults
echo "Ubuntu添加開機自啟成功"
echo "相關指令為service aria2c (start|stop|restart)"
	read -p "Press any key to continue." var
	clear
	;;
	6)
vim ${aria2_path}/aria2.conf
wait
	;;
	7)
	read -p "Press any key to continue." var
	clear
break
	;;
esac

done