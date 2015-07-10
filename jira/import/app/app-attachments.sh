#!/tools/bin/bash
rm output/*.csv
time perl ../import_attachments.pl --source jira=source/14174.json --filter "Project = APP" $* >output/app-attachments.csv
