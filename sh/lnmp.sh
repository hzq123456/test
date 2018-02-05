#!/bin/sh
clear
INSTALL_WEB="NULL"
INSTALL_CLOUDFLARE="NULL"
INSTALL_NGINX=0
NGINX_PORT=80
SSH_PORT=22

INSTALL_PHP="NULL"

PHP_VERSION_70=0

INSTALL_MYSQL="NULL"
MYSQL_VERSION_57=0
MYSQL_VERSION_56=6
MYSQL_PASSWORD="root"

INSTALL_RSYNC="NULL"



UPDATE_SYSTEM="NULL"
# 临时关闭 SELinux 宽容模式保证安装过程不受影响
setenforce 0

INPUT_VALUE="NULL"
# SELinux 选型
while [[ $INPUT_VALUE = "NULL" ]]
do
  echo "==========================================="
  echo "= 是否关闭 SELinux 保护                   ="
  echo "=   Y => 关闭                             ="
  echo "=   N => 开启                             ="
  echo "==========================================="
  read -p "请输入（Y/N）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "Y" ]
  then
    sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
  elif [ $INPUT_VALUE = "N" ]
  then
    sed -i "s/SELINUX=disabled/SELINUX=enforcing/g" /etc/selinux/config
  else
    INPUT_VALUE="NULL"
  fi
done

# 更新系统菜单
while [[ $UPDATE_SYSTEM = "NULL" ]]
do
  echo "==========================================="
  echo "= 是否更新系统组件                        ="
  echo "=   Y => 更新                             ="
  echo "=   N => 不更新                           ="
  echo "==========================================="
  read -p "请输入（Y/N）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "Y" ]
  then
    UPDATE_SYSTEM="Y"
  elif [ $INPUT_VALUE = "N" ]
  then
    UPDATE_SYSTEM="N"
  else
    UPDATE_SYSTEM="NULL"
  fi
done

INPUT_VALUE="NULL"
# 修改默认SSH端口
while [[ $INPUT_VALUE = "NULL" ]]
do
  echo "==========================================="
  echo "= 修改默认SSH端口 -> 50001                ="
  echo "=   Y => 修改                             ="
  echo "=   N => 取消                             ="
  echo "==========================================="
  read -p "请输入（Y/N）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "Y" ]
  then
    SSH_PORT=50001
    sed -i "s/#Port 22/Port ${SSH_PORT}/g" /etc/ssh/sshd_config
  elif [ $INPUT_VALUE = "N" ]
  then
    SSH_PORT=22
  else
    INPUT_VALUE="NULL"
  fi
done

INPUT_VALUE="NULL"
# 防火墙菜单
while [[ $INPUT_VALUE = "NULL" ]]
do
  echo "==========================================="
  echo "= 启用防火墙 firwalld                     ="  
  echo "=   Y => 启用                             ="  
  echo "=   N => 停用                             ="
  echo "=   Q => 取消                             ="
  echo "==========================================="
  read -p "请输入（Y/N/Q）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "Y" ]
  then
    systemctl enable firewalld
    systemctl start firewalld

    for white_IP in ${white_list[@]}; do
    firewall-cmd --add-rich-rule="rule family=ipv4 source address=${white_IP} port port=${SSH_PORT} protocol=tcp accept" --permanent
    done

    firewall-cmd --reload
  elif [ $INPUT_VALUE = "N" ]
  then
    systemctl stop firewalld
    systemctl disable firewalld
  elif [ $INPUT_VALUE = "Q" ]
  then
    echo 忽略防火墙设置
  else
    INPUT_VALUE="NULL"
  fi
done


# ========================================================================
# Web 容器安装菜单
while [[ $INSTALL_WEB = "NULL" ]]
do
  echo "==========================================="
  echo "= Web 容器安装选项                        ="
  echo "=   2 => nginx                            ="
  echo "=   N => 不安装                           ="
  echo "==========================================="
  read -p "请输入（1/2/3/N）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "2" ]
  then
    INSTALL_NGINX=1
    INSTALL_WEB="Y"
  else 
    INSTALL_NGINX=0
    INSTALL_WEB="NULL"
  fi
done


# ========================================================================
# 是否安装 CloudFlare 扩展
if [ $INSTALL_WEB = "Y" ]
then
  while [[ $INSTALL_CLOUDFLARE = "NULL" ]]
  do
    echo "==========================================="
    echo "= Web 容器 CloudFlare 扩展                ="
    echo "=-----------------------------------------="
    echo "=     使用 CloudFlare 作为CDN防护时       ="
    echo "=     无法正确获取到客户请求IP            ="
    echo "=     使用此扩展可以解决该问题            ="
    echo "=-----------------------------------------="
    echo "=   Y => 安装                             ="
    echo "=   N => 不安装                           ="
    echo "==========================================="
    read -p "请输入（Y/N）：" INPUT_VALUE

    # 转换大写
    INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
    if [ $INPUT_VALUE = "Y" ]
    then
      INSTALL_CLOUDFLARE="Y"
    elif [ $INPUT_VALUE = "N" ]
    then
      INSTALL_CLOUDFLARE="N"
    else
      INSTALL_CLOUDFLARE="NULL"
    fi
  done
fi

# ========================================================================
# PHP 安装菜单
while [[ $INSTALL_PHP = "NULL" ]]
do
  echo "==========================================="
  echo "= PHP 安装选项                           ="
  echo "=   1 => PHP 7.0                         ="
  echo "=   N => 不安装                          ="
  echo "=========================================="
  read -p "请输入（1/N）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "1" ]
  then
    INSTALL_PHP="Y"
    PHP_VERSION_70=1
  else
    INSTALL_PHP="NULL"
    PHP_VERSION_70=0
  fi
done

# ========================================================================
# mysql 安装菜单
while [[ $INSTALL_MYSQL = "NULL" ]]
do
  echo "==========================================="
  echo "= mysql 安装选项                          ="
  echo "=   1 => 5.7                              ="
  echo "=   2 => 5.6                              ="
  echo "=   N => 不安装                           ="
  echo "==========================================="
  read -p "请输入（1/2/N）：" INPUT_VALUE

  # 转换大写
  INPUT_VALUE=$(echo $INPUT_VALUE | tr '[a-z]' '[A-Z]')
  if [ $INPUT_VALUE = "1" ]
  then
    INSTALL_MYSQL="Y"
    MYSQL_VERSION_56=0
    MYSQL_VERSION_57=1
	INPUT_VALUE = "NULL"
    echo "==========================================="
    echo "=   是否设置msql密码                      ="
    echo "==========================================="
    read -p "请输入（Y/N）：" INPUT_VALUE
    if [ $INPUT_VALUE = "Y" ]
    then
      INPUT_VALUE="NULL"
      read -p "请输入msql密码：" INPUT_VALUE
	  MYSQL_PASSWORD=$INPUT_VALUE
    fi
  elif [ $INPUT_VALUE = "2" ]
  then
    INSTALL_MYSQL="Y"
    MYSQL_VERSION_56=1
    MYSQL_VERSION_57=0
		INPUT_VALUE = "NULL"
    echo "==========================================="
    echo "=   是否设置msql密码                      ="
    echo "==========================================="
    read -p "请输入（Y/N）：" INPUT_VALUE
    if [ $INPUT_VALUE = "Y" ]
    then
      INPUT_VALUE ="NULL"
      read -p "请输入msql密码：" INPUT_VALUE
	  MYSQL_PASSWORD=$INPUT_VALUE
    fi
  elif [ $INPUT_VALUE = "N" ]
  then
    INSTALL_MYSQL="N"
    MYSQL_VERSION_56=0
    MYSQL_VERSION_57=0
  else
    INSTALL_MYSQL="NULL"
    MYSQL_VERSION_56=0
    MYSQL_VERSION_57=0
  fi
done

if [ $UPDATE_SYSTEM = "Y" ]
then
  echo "开始更新系统..."
  yum update -y
fi

# ====================================================================================
# 首先卸载系统预安装的LAMP软件
rpm -qa|grep httpd 
rpm -e httpd httpd-tools
rpm -qa|grep mysql
rpm -e mysql mysql-libs
rpm -qa|grep php
rpm -e php-mysql php-cli php-gd php-common php
yum -y remove httpd*
yum -y remove mysql-server mysql mysql-libs
yum -y remove php*

# ====================================================================================
# 添加预安装包
yum -y install wget net-tools gcc gcc-c++ libxml2 libxml2-devel pcre pcre-devel openssl openssl-devel curl curl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libicu libicu-devel libxslt libxslt-devel autoconf cmake ncurses ncurses-devel libxslt libxslt-devel


# ====================================================================================
# 安装常用工具
if [ $INSTALL_TOOLS = "Y" ]
then
  echo "开始安装 net-tools wget vim zip unzip ..."
  yum install -y net-tools.x86_64 wget vim-enhanced zip unzip
fi



# ====================================================================================
# 安装Web容器
if [ $INSTALL_WEB = "Y" ]
then
  if [ $INSTALL_NGINX -eq 1 ]
  then
    echo "开始安装 nginx 1.10.2 ..."
	groupadd www
    useradd -s /sbin/nologin -g www www
	yum install -y epel-release
    yum clean all
    yum makecache
    yum install -y libmcrypt libmcrypt-devel
	cd /usr/local/src
	wget -c http://nginx.org/download/nginx-1.10.1.tar.gz
    tar zxvf nginx-1.10.1.tar.gz
    cd nginx-1.10.1
    ./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-ipv6 --with-http_sub_module
    make && make install 
	/usr/local/nginx/sbin/nginx
  fi

  if [ $INSTALL_APACHE -eq 1 -a $INSTALL_NGINX -eq 1 ]
  then
    echo "修改 apache 默认端口 -> ${APACHE_PORT}"
    sed -i "s/Listen 80/Listen ${APACHE_PORT}/g" /etc/httpd/conf/httpd.conf
    echo "将nginx的PHP请求转发到apache..."
    sed -i "s/http://127.0.0.1;/http://127.0.0.1:${APACHE_PORT}/g" /etc/nginx/conf.d/default.conf
  fi
fi

# 安装 Web 容器 Cloudflare 扩展
if [ $INSTALL_CLOUDFLARE = "Y" ]
then
  echo "开始安装 mod_cloudflare 扩展 ..."
  rpm -Uvh https://www.cloudflare.com/static/misc/mod_cloudflare/centos/mod_cloudflare-el7-x86_64.latest.rpm
  yum install -y mod_cloudflare
  # 创建apache配置文件
  echo "LoadModule cloudflare_module modules/mod_cloudflare.so" > /etc/httpd/conf.modules.d/00-cloudflare.conf
fi

if [ $INSTALL_PHP = "Y"  ]
then
  if [ $PHP_VERSION_70 -eq 1 ]
  then
    echo "开始安装 PHP 7.0 ..."
	cd /usr/local/src
	wget -c http://cn2.php.net/distributions/php-7.2.0.tar.gz
	tar zxf php-7.2.0.tar.gz
	cd php-7.2.0
    ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir --with-freetype-dir=/usr/local/freetype --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --enable-intl --enable-pcntl --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-gettext --disable-fileinfo --enable-opcache --with-xsl

	make && make install 
	ln -sf /usr/local/php/bin/php /usr/local/bin/php
	cp /usr/local/src/php-7.2.0/php.ini-production /usr/local/php/etc/php.ini
	mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
    mv /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
    cp /usr/local/src/php-7.2.0/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
    chmod +x /etc/init.d/php-fpm
	chkconfig php-fpm on
	service php-fpm start
	rm -rf /usr/local/nginx/conf/nginx.conf
	mkdir -p /home/www/default
    cat > /usr/local/nginx/conf/nginx.conf<<EOF
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
            root           /home/www/default;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /\$document_root\$fastcgi_script_name;
            include        fastcgi_params;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    include /home/vhosts/*;
}
     
EOF
   /usr/local/nginx/sbin/nginx -s reload
   chown www.www /home/www/default -R
  elif [ $PHP_VERSION_56 -eq 1 ]
  then
    echo "开始安装 PHP 5.6 ..."
 fi
  # 安装Composer
  echo "开始安装 Composer ..."
  curl -sS https://getcomposer.org/installer | php
  # 移动composer 到用户目录，这样可以全局使用composer
  mv composer.phar /usr/local/bin/composer
  # 增加 composer 的写入权限
  chmod +x /usr/local/bin/composer
fi

if [ $INSTALL_MYSQL = "Y"  ]
then
  if [ $MYSQL_VERSION_56 -eq 1 ]
  then
    echo "正在安装 mysql 版本：5.6 ..."
	groupadd mysql
    useradd -s /sbin/nologin -g mysql mysql
	cd /usr/local/src
	wget -c https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.38.tar.gz
	tar zxvf mysql-5.6.38.tar.gz
	cd mysql-5.6.38
	cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 -DENABLE_DOWNLOADS=1
	make && make install
	chown -R mysql:mysql /usr/local/mysql
	cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
	/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql
	chkconfig mysql on
	service mysql start
	/usr/local/mysql/bin/mysql -uroot <<EOF 2>/dev/null
   update user set password=password('$MYSQL_PASSWORD') where user='root' and host='localhost';
   flush privileges;
EOF
	    
  elif [ $MYSQL_VERSION_57 -eq 1 ]
  then
    echo "正在安装 mysql 版本：5.7 ..."
	groupadd mysql
    useradd -s /sbin/nologin -g mysql mysql
	cd /usr/local/src
	wget -c http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.16.tar.gz
	tar zxvf mysql-boost-5.7.16.tar.gz
	cd mysql-5.7.16/
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 -DWITH_BOOST=boost -DENABLE_DOWNLOADS=1
	make && make install
	chown -R mysql:mysql /usr/local/mysql
	cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
    /usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql
	cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
	chkconfig mysql on
	service mysql start
	/usr/local/mysql/bin/mysql -uroot <<EOF 2>/dev/null
    set password = password('$MYSQL_PASSWORD');
EOF
  fi
fi


echo "安装完毕！"