#!/bin/bash


# First, delete index
#echo "Delete all indexes"
#curl -X DELETE 'http://localhost:9200/_all'

#sleep 20

# And create a new asterisk index in Elastic
#echo "Create xivo index and mapping"
#curl -XPUT 'localhost:9200/xivo?pretty' -H 'Content-Type: application/json' -d'
# {
#  "mappings": {
#    "doc": {
#      "properties": {
#        "asterisk_sip_peer_ip":    { "type": "ip" },
#        "asterisk_sip_peer_port":    { "type": "keyword" },
#        "asterisk_manager_host":    { "type": "ip" },
#        "asterisk_thread_id":    { "type": "keyword" },
#        "asterisk_severity":    { "type": "keyword" },
#        "asterisk_src_file":    { "type": "keyword" },
#        "asterisk_callid":    { "type": "keyword" }
#        }
#      }
#    }
#  }

curl -X POST "elk-dockercompose_elk_1:5601/api/data_views/data_view" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "data_view": {
     "title": "xivo*"
  }
}
'

curl -X PUT 'elk-dockercompose_elk_1:9200/xivo?pretty' -H 'Content-Type: application/json' -d'
{
	"mappings": {
		"properties":{
			"geoip.coordinates":{
				"type": "geo_point"
			}
		}
	}
}'

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "http://localhost:5601/api/kibana/dashboards/import" -d @./dashboardJson/nbReqByIp

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "http://localhost:5601/api/kibana/dashboards/import" -d @./dashboardJson/xuc_overview

#curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "http://localhost:5601/api/kibana/dashboards/import" -d @./dashboardJson/nginx_overview

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "http://localhost:5601/api/kibana/dashboards/import" -d @./dashboardJson/asterisk-full

