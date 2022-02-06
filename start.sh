#!/bin/bash

prl=`grep PermitRootLogin /etc/ssh/sshd_config`
pa=`grep PasswordAuthentication /etc/ssh/sshd_config`
if [[ -n $prl && -n $pa ]]; then
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo root:c68.300OQa|chpasswd
fi

#需要手动安装一下 go https://go.dev/doc/install ，添加环境变量 PATH /etc/profile，然后 source /etc/profile
#记得在 /etc/nginx/nginx.conf 的 http 域里的最后一行添加 client_max_body_size 1024m; 然后重载一下 nginx 的配置文件 nginx -s reload
#client_max_body_size 0;代表大小不限制

#Ubuntu安装LaTeX，以VS Code为编辑器，支持中文字体简单教程_努力做无毒的Pb的博客-程序员宝宝
#https://www.cxybb.com/article/weixin_44715583/109553033

#解压网站模板
unzip -o /grad_school.zip -d /
chmod -Rf +rw /templatemo_557_grad_school

sed -i "s|iPORT|$PORT|g" /etc/nginx/sites-available/default
#sed -i "s|include /etc/nginx/sites-enabled/*;|include /etc/nginx/sites-enabled/*;client_max_body_size 0;|g" /etc/nginx/nginx.conf
sed -i 's|include[ ][/]etc[/]nginx[/]sites-enabled[/][*];\+|include /etc/nginx/sites-enabled/*;\n    client_max_body_size 0;|g' /etc/nginx/nginx.conf

service redis-server start &
/etc/init.d/redis-server restart >/dev/null 2>&1 &
service nginx start &
/etc/init.d/nginx restart >/dev/null 2>&1 &

rm -rf /usr/bin/python
ln -s /usr/bin/python3 /usr/bin/python

wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /usr/local/bin/ttyd
chmod a+rx /usr/local/bin/ttyd

chmod -Rf 777 /run/screen

#run code-server
screen_name="code-server"
screen -dmS $screen_name
cmd="code-server --host 0.0.0.0 --port 8722";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'

#run ttyd
screen_name="ttyd"
screen -dmS $screen_name
cmd="ttyd login";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'

#curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
#filebrowser -r /
filebrowser config init
filebrowser config set -b '/file'
filebrowser config set -p 60002
filebrowser users add root c68.300OQa --perm.admin

#run filebrowser
screen_name="filebrowser"
screen -dmS $screen_name
cmd="filebrowser -r /";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'
#filebrowser username:admin password:admin

#run rclone
screen_name="rclone"
screen -dmS $screen_name
cmd="rclone rcd --rc-web-gui --rc-addr 127.0.0.1:5572 --rc-user root --rc-pass c68.300OQa";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'

#run math
screen_name="imath"
screen -dmS $screen_name
cmd="/math_calc.sh";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'

#wstunnel -s 0.0.0.0:80 &
/usr/sbin/sshd -D

#supervisord -c /supervisord.conf

while true
do
    sleep 5
done
