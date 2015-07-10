#!/tools/bin/bash
rm source/*.json

#UWS/UAP
perl ../export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --query 14158 --nfeed ../wlan/nfeed_values.csv --set Product=UWS/UAP > source/14158.json

#UWS/UAP Linked issues
#perl ../query_json.pl --source source/14158.json --query "Linked Issues.inwardIssue.key" > source/14158_links.ids
#perl ../export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --nfeed ../wlan/nfeed_values.csv --set Product=UWS/UAP > source/14158_links.json

#ESDK
perl ../export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --query 14155 --nfeed ../wlan/nfeed_values.csv --set Product=ESDK > source/14155.json
