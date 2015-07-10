#!/tools/bin/bash
rm output/*.csv
time perl ../import_attachments.pl --source jira=source/14152.json --source jira=source/21985.json --filter "Project = AVB" $* >output/avb-attachments.csv
