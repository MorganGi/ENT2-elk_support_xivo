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
- Download the directory 
- Configure Nginx proxy on support-tools like this :
 ```
   location /elastic/ {
        include proxy_params;
        proxy_pass http://127.0.0.1:9200/;
   }
   location /kibana/ {
        include proxy_params;
        proxy_pass http://127.0.0.1:5601/;
   }

   location ^~ /elksupport/ {
	include proxy_params;
	proxy_ssl_verify off;
	proxy_pass https://127.0.0.1:9443/;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	
   }

 }
```

# Launch ELK

To be able to explore logs, run the container using docker-compose.

## Run the application

```bash
docker-compose up -d
```

## Copy logs

To copy logs go to [support-tools /elksupport/](https://support-tools.avencall.com/elksupport/index.php)

- Select your file.
- :warning: Do not change default path cause it will not be add to kibana.
- The password is Avencall2022
- Select the type of your file.
- Upload your file.


**make all log readable**
Make sure logs are readable :
```bash
chmod +r /elkforxivo/*
```
After some startup time, it will start to read logs
and analyze it.
It will take some time, depending on the size of it.


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


