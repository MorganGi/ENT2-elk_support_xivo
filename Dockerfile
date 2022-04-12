FROM sebp/elk

# overwrite existing file
#ADD conf/logstash/beats-input.conf /etc/logstash/conf.d/02-beats-input.conf
ADD conf/logstash/file-input.conf /etc/logstash/conf.d/03-file-input.conf

ADD conf/logstash/emptyFile.conf /etc/logstash/conf.d/02-beats-input.conf

ADD conf/logstash/filters.conf /etc/logstash/conf.d/12-asterisk.conf
ADD conf/logstash/xivo-daemon-filter.conf /etc/logstash/conf.d/13-xivo-daemon.conf
ADD conf/logstash/output.conf /etc/logstash/conf.d/30-output.conf
ADD conf/logstash/asterisk-patterns /opt/logstash/patterns/asterisk
ADD conf/logstash/xivo-daemon-patterns /opt/logstash/patterns/xdaemon
ADD conf/logstash/xuc-patterns2.conf /opt/logstash/patterns/xuc
ADD conf/logstash/nginx-patterns.conf /opt/logstash/patterns/nginx
# Add pre-hook script
#ADD ./bin/elk-pre-hooks.sh /usr/local/bin/elk-pre-hooks.sh

# Add post-hook script
ADD bin/elk-post-hooks.sh /usr/local/bin/elk-post-hooks.sh

# Add mount point for full log ?
VOLUME ./elkforxivo/
#VOLUME /var/tmp/elkforxivo/access/
#VOLUME /var/tmp/elkforxivo/asterisk/

