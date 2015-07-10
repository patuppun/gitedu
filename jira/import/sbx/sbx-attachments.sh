#!/tools/bin/bash
time perl ../import_attachments.pl --source jira=source/18300.json --source jira=source/18234.json --filter "Project = SBX" $* >output/sbx-attachments.csv
