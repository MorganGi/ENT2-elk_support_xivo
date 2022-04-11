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

## Create volume on your PC 

You need to create the `/var/tmp/elkforxivo` directory on your PC where Logstash will read your logs from :
```bash
mkdir -p /var/tmp/elkforxivo/
```

Note:
- the path `/var/tmp/elkforxivo/` is mandatory as it is hard coded in the created docker image,

# Launch ELK

To be able to explore logs, run the container using docker-compose.

## Run the container

```bash
docker-compose up -d
```

Make sure that kibana is working.
To do this :
1. Log in Kibana: http://localhost:5601

## Copy logs

**asterisk logs**
Put inside the asterisk log you want to analyze :
```bash
cp /path/to/your/asterisk/log /var/tmp/elkforxivo/asterisk-full
```
Notes:
- inside `/var/tmp/elkforxivo/` directory, the filename must start with `asterisk`
- `asterisk` must be a plain text asterisk full log (it must be gunzipped)


**syslog logs**
Put inside the syslog log you want to analyze :
```bash
cp /path/to/your/syslog/log /var/tmp/elkforxivo/syslog
```
Notes:
- inside `/var/tmp/elkforxivo/` directory, the filename must be `syslog`
- `syslog` must be a plain text syslog log (it must be gunzipped)

**Nginx logs**
Put inside the syslog log you want to analyze :
```bash
cp /path/to/your/nginx/log /var/tmp/elkforxivo/nginx
```
Notes:
- inside `/var/tmp/elkforxivo/` directory, the filename must start with `access`
- `syslog` must be a plain text syslog log (it must be gunzipped)

**Xuc logs**
Put inside the syslog log you want to analyze :
```bash
cp /path/to/your/xuc/log /var/tmp/elkforxivo/xuc
```
Notes:
- inside `/var/tmp/elkforxivo/` directory, filenames must start with `xuc`
- `xuc` must be a plain text syslog log (it must be gunzipped)

**xivo daemon logs**: authd, confd, ctid
Put inside the xivo-{authd,confd,ctid} daemon log you want to analyze :
```bash
cp /path/to/your/xivo-authd/log /var/tmp/elkforxivo/xivo-authd
cp /path/to/your/xivo-confd/log /var/tmp/elkforxivo/xivo-confd
cp /path/to/your/xivo-ctid/log /var/tmp/elkforxivo/xivo-ctid
```
Notes:
- inside `/var/tmp/elkforxivo/` directory, the filename must be `xivo-authd` or `xivo-confd` or `xivo-ctid`
- these files must be a plain text syslog log (it must be gunzipped)

**make all log readable**
Make sure logs are readable :
```bash
chmod +r /var/tmp/elkforxivo/*
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


# Todo

This is a WIP so here are some todo :
- Describe how one could enhance the project:
 - how to add grok pattern for asterisk,
 - how to enhance default dashboard/visualizations/saved search
- Add automatic index pattern creation 
- Add default dashboard/visualizations/saved search
- Add configuration for syslog or other XiVO log files
- ...

