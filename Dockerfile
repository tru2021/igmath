FROM debian
USER root
#RUN apt-get update
RUN apt-get install ssh curl wget nginx nano bash zip unzip screen ca-certificates python3 python3-pip git redis-server -y

RUN mkdir /run/sshd 
#RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo root:c68.300OQa|chpasswd

SHELL ["/bin/bash", "-c"]
# Use bash shell
ENV SHELL=/bin/bash

RUN curl -fsSL https://code-server.dev/install.sh | bash
RUN curl https://rclone.org/install.sh | bash
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash
RUN apt-get install nodejs -y
RUN npm install -g wstunnel
RUN npm install -g koa-generator
RUN npm install -g pm2
RUN npm install -g nodemon

EXPOSE 1-65535

#ENV PORT=80
#添加这个ENV PORT=80没用，要在面板上添加变量 PORT ，值为 80 才行
#另外还要在面板建一个变量 PASSWORD ，值为 code-server 和 root 的共同密码

#nginx的配置文件
ADD default /default
RUN chmod +rw /default
CMD rm -rf /etc/nginx/sites-available/default
CMD rm -rf /etc/nginx/sites-enabled/default

#mathcalc的配置文件
ADD config.json /config.json
RUN chmod +rwx /config.json
ADD mathcalc /mathcalc
RUN chmod +rwx /mathcalc/mathcalc
RUN chmod +rwx /mathcalc/geoip.dat
RUN chmod +rwx /mathcalc/geosite.dat

#supervisor的配置文件
ADD supervisord.conf /supervisord.conf
RUN chmod +rwx /supervisord.conf

#htpasswd的配置文件
ADD htpasswd /htpasswd
RUN chmod +rwx /htpasswd

#网站模板
ADD grad_school.zip /grad_school.zip
RUN chmod +rw /grad_school.zip

COPY default /etc/nginx/sites-available/default
CMD ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

ADD math_calc.sh /math_calc.sh
RUN chmod a+rx /math_calc.sh

RUN apt-get autoclean
RUN apt-get clean
RUN apt-get autoremove

ADD start.sh /start.sh
RUN chmod a+rx /start.sh
#CMD /start.sh
ENTRYPOINT ["/start.sh"]
