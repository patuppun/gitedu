#!/tools/bin/bash
rm source/*.json
perl ../export_jira.pl --pretty --server rtpjira.rtp.broadcom.com:8080 --query 14174 --nfeed ../wlan/nfeed_values.csv --set Product=ePTN > source/14174.json
