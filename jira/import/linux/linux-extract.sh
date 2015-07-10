#!/tools/bin/bash
rm source/*.json
perl ../export_jira.pl --server jira-rtp-04.rtp.broadcom.com:8080 --query "project = LINUXDEV AND issuetype not in (Sub-Task, Test)" > source/issues.json
