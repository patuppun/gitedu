#!/tools/bin/bash
rm source/*.json
perl ../export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --query 14152 --nfeed ../wlan/nfeed_values.csv --set Product=AVB > source/14152.json
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query 21985 --set Product=AVB > source/21985.json
