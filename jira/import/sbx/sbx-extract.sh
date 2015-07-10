#!/tools/bin/bash
rm source/*.json

#Caladan2
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query 18300 --set Product=Caladan2 > source/18300.json
#Caladan3
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query 18234 --set Product=Caladan3 > source/18234.json

