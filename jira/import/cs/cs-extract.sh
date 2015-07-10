#!/tools/bin/bash
rm source/*.json
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query "project%3DESPSW" --set "Product=Client Security" > source/ESPSW.json
