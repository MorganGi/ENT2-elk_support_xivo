#!/bin/bash


# First, delete index
#echo "Delete all indexes"
#curl -X DELETE 'http://localhost:9200/_all'

#sleep 20

# And create a new asterisk index in Elastic
#echo "Create xivo index and mapping"
#curl -XPUT 'localhost:9200/xivo?pretty' -H 'Content-Type: application/json' -d'
#{
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

curl -XPUT 'localhost:9200/xivo?pretty' -H 'Content-Type: application/json' -d'
{
	"mappings": {
		"properties":{
			"geoip.coordinates":{
				"type": "geo_point"
			}
		}
	}
}'











