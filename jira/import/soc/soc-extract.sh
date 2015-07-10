#!/tools/bin/bash
rm source/*.json
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query "Project=IPROCSW" --set Product=IPROCSW > source/IPROCSW.json
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query "Project=POS" --set Product=POS > source/POS.json
