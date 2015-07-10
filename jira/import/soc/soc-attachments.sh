#!/tools/bin/bash
time perl ../import_attachments.pl --source jira=source/IPROCSW.json --source jira=source/POS.json --filter "Project = SOC" $* >output/soc-attachments.csv
