# ELK for XiVO

This project describe how to run elk with docker compose

The docker image is built from sebp/elk.

:warning:

- This project is still in the early phases and a work in progress.
- It works but with quite a lot of limitations. 
- And not everything is as good as it may be.
- But if you follow these steps, you should be able to explore logs (Asterisk-full, nginx, xuc, ctid, authd, confd...)


## Pre-requisites

- having **docker and docker-compose** installed
- and follow [Prerequisites](https://elk-docker.readthedocs.io/#prerequisites) of elk-docker docker image upon which our image will be built :
  - **mainly** you will have to increase the `vm-max-map-count`, see [Elasticsearch virtual memory guide](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html#vm-max-map-count)
- Download **docker-compose.yml** and **XAND6.ndjson** files

## Create volume on your PC 

You need to create the `/var/tmp/elkforxivo` directory on your PC where Logstash will read your logs from :
```bash
mkdir -p /var/tmp/elkforxivo/
```

Note:
- the path `/var/tmp/elkforxivo/` is mandatory as it is hard coded in the created docker image,

# Launch ELK

To be able to explore logs, run the container using docker-compose.

## Run the application

```bash
docker-compose up -d
```

Make sure that kibana is working.
To do this :
1. Log in Kibana: http://localhost:5601

## Copy logs

This is the list of available logs you can copy.

|Original log path| container log path |
| ------------- |:-------------:| 
| /path/to/your/asterisk/log| elkforxivo/asterisk | 
| /path/to/your/syslog/log| elkforxivo/syslog | 
| /path/to/your/nginx/log | elkforxivo/nginx | 
| /path/to/your/xuc/log | elkforxivo/xuc | 
| /path/to/your/xivo-authd/log | elkforxivo/xivo-authd | 
| /path/to/your/xivo-confd/log | elkforxivo/xivo-confd | 
| /path/to/your/xivo-ctid/log | elkforxivo/xivo-ctid | 


Notes:
- **Asterisk** files must start with `asterisk`
- **Logs** files must be `syslog`
- **Nginx access logs** files must start with `access`
- **Xuc logs** must start with `xuc`
- **Xivo services like authd, confd, ctid** must be `xivo-authd`, `xivo-confd`, `xivo-ctid`
:warning: logs must be a plain text asterisk full log (it must be gunzipped)

:ballot_box_with_check: Here is an example :
```bash
cp /path/to/your/asterisk/logs /elkforxivo/asterisk-name
```

:x: Here is a bad example :
```bash
cp /path/to/your/asterisk/logs /elkforxivo/name-asterisk
```

**make all log readable**
Make sure logs are readable :
```bash
chmod +r /elkforxivo/*
```
After some startup time, it will start to read logs
and analyze it.
It will take some time, depending on the size of it.

## Import default Dashboard (optional)

You can import the file **XAND6.ndjson** to import all dashboards needed (Asterisk, Xuc, Nginx, CTID ...)

To do that :
1. Log in Kibana: http://localhost:5601
1. Go to Management -> Saved Objects
1. Click on Import
1. Select file `XAND6.ndjson` in this project and click import
1. Select *Yes, overwrite all objects*
1. It will warn you that the index does not exist and ask you to select one: select the `xivo*` one you created (see step above).
1. You're done and can go to Dashboard to see the default Dashboard.


# Help

Verifications:
- verify that it read asterisk full: http://localhost:9200/_search?pretty
- verify that the mapping was created: http://localhost:9200/xivo/_mapping/

## Sources

- Base ELK docker image doc: https://elk-docker.readthedocs.io/

## Improuvement : Analyse new logs or fields (optional)

The following steps are key manipulations if you want to analyse new logs, you should search for more detail on the official web site: [Logstash Reference](https://www.elastic.co/guide/en/logstash/current/index.html)

1. Add a new file input in `conf/logstash/file-input.conf` by using the same templates of this file. NOTICE the caractere `  *  ` at the end of the paths. It means all file that begin with this name will be analysed.
1. Add filter to the file `conf/logstash/filters.conf`.
1. Create a new pattern file related to your filter. (You can use Grok debugger in kibana: Management -> Dev Tools -> Grock debugger)
1. add your file in the Dockerfile and re-build the image.


