#!/bin/sh

stochastic(){
	echo `dd if=/dev/urandom bs=1 count=32 2>/dev/null | md5sum | cut -b 0-12 | sed 's/\(..\)/\1:/g; s/.$//'`
}

sto(){ 
	local stom=$("stochastic")
	nvram set wan_hwaddr="$stom"
	nvram commit
	sleep 1
}

network()
{
    #超时时间
    local timeout=1

    #目标网站
    local target=www.baidu.com

    #获取响应状态码
    local ret_code=`curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | tail -n1`

    if [ "x$ret_code" = "x200" ]; then
        #网络畅通
        return 1
    else
        #网络不畅通
        return 0
    fi

    return 0
}



random()
{


	#sto     //修改mac�
	sleep 2
	cp /tmp/ppp/options.wan0 /etc/storage/options.wan0 
	sleep 1 
	killall pppd
	cp /etc/storage/options.wan0 /tmp/ppp/options.wan0 
	/usr/sbin/pppd file /tmp/ppp/options.wan0 >/dev/null 2>&1 &
	
}


finally(){
	network
	while [ $? -eq 0  ]
	do
		random
		sleep 5
		network
	done
	
	#echo 'done'

}

finally
