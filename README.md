# ELK for XiVO

This project describe how to build a docker image 
- with elk
- and with some configuration to explore asterisk full logs

The docker image is built from sebp/elk.

:warning: 
- This is somehow a work in progress.
- It works but with quite a lot of limitations. 
- And not everything is as good as it may be.
- But if you follow these steps, you should be able to explore asterisk logs


# Installation

Before being able to use it you need to create the image.

## Pre-requisites

- having **docker** installed
- and follow [Prerequisites](https://elk-docker.readthedocs.io/#prerequisites) of elk-docker docker image upon which our image will be built :
  - **mainly** you will have to increase the `vm-max-map-count`, see [Elasticsearch virtual memory guide](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html#vm-max-map-count)

## Create the docker image

This step will create the docker image on your laptop
```bash
docker build -f Dockerfile -t ${USER}/myelkforxivo .
```

It will create an image name USER/myelkforxivo (with USER being the logged in username)

## Create volume on your PC 

You need to create the `/var/tmp/elkforxivo` directory on your PC where Logstash will read your logs from :
```bash
mkdir -p /var/tmp/elkforxivo/
```

Note:
- the path `/var/tmp/elkforxivo/` is mandatory as it is hard coded in the created docker image,


# Configuration

Before launching the container you should **NOT** put your logs in the elkforxivo folder cause nginx IP location will not works.

# Launch ELK

To be able to explore the asterisk full log, run the container.

## Run the container

```bash
docker rm elk
docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -v /var/tmp/elkforxivo/:/var/tmp/elkforxivo/ --name elk ${USER}/myelkforxivo:latest
```

Make sure that kibana is working.
To do this :
1. Log in Kibana: http://localhost:5601

- to use geo ip location make sure the field geoip.coordinates is `"type" :  "geo_point"`.
To make it go to *Management -> Dev Tools -> Console* ant type `Get /xivo/_mapping`. If the field is `"type" : "float"` IP location will *not* work.
REASON : You probably put your logs in the directory `/var/tmp/elkforxivo` before the start of the container.


## Copy logs

**asterisk logs**
Put inside the asterisk log you want to analyze :
```bash
cp /path/to/your/asterisk/log /var/tmp/elkforxivo/asterisk-full
```
Notes:
- inside `/var/tmp/elkforxivo/` directory, the filename must start with `asterisk`
- `asterisk` must be a plain text asterisk full log (it must be gunzipped)

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

**make all log readable**
Make sure logs are readable :
```bash
chmod +r /var/tmp/elkforxivo/*
```
After some startup time, it will start to read the asterisk full log
and analyze it.
It will take some time, depending on the size of it.

## Configure Kibana (mandatory step)

Before using Kiban you must create an *Index Pattern*
To do this :
1. Log in Kibana: http://localhost:5601
1. Go to *Management -> Index Patterns*
1. You should arrive in menu *Create index pattern*
1. Write `xivo*` in the *Index pattern* field: it should display Success
1. Click on *Next step*
1. At step 2 *Configure settings*, select `@timestamp` in the *Time Filter field name*
1. Click *Create index pattern* 


You are now ready to explore your logs.

## Import default Dashboard (optional)

This import dashboars:
- one for asterisk logs
- several for XiVO Daemon logs (authd, confd, ctid...)
- one for nginx logs
- One for xuc logs

You can also import a default *Dashboard* with several *Visualizations* and *Searches* to start with.
To do that, and **after** having created the *Index Pattern* (see step above):
1. Log in Kibana: http://localhost:5601
1. Go to Management -> Saved Objects
1. Click on Import
1. Select file `XAND.ndjson` in this project and click import
1. Select *Yes, overwrite all objects*
1. It will warn you that the index does not exist and ask you to select one: select the `xivo*` one you created (see step above).
1. You're done and can go to Dashboard to see the default Dashboard.


# Help

Verifications:
- verify that it read asterisk full: http://localhost:9200/_search?pretty
- verify that the mapping was created: http://localhost:9200/xivo/_mapping/

## Sources

- Base ELK docker image doc: https://elk-docker.readthedocs.io/

##Improuvement : Analyse new logs or fields

The following steps are key manipulations if you want to analyse new logs but you should search for more detail on the official web site: [Logstash Reference](https://www.elastic.co/guide/en/logstash/current/index.html)

1. Add a new file input in `conf/logstash/file-input.conf` by using the same templates of this file. NOTICE the caractere `  *  ` at the end of the paths. It means all file that begin with this name will be analysed
1. Add filter to the file `conf/logstash/filters.conf`
1. Create a new pattern file related to your filter
1. add to the pattern in the docker file and re-build the image.



# Todo

This is a WIP so here are some todo :
- Describe how one could enhance the project:
 - how to add grok pattern for asterisk,
 - how to enhance default dashboard/visualizations/saved search
- Add automatic index pattern creation 
- Add default dashboard/visualizations/saved search
- Add configuration for syslog or other XiVO log files
- ...

