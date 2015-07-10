#!/tools/bin/bash
rm output/*.csv
time perl ../import_attachments.pl --source jira=source/ESPSW.json --filter "Project = CS" $* >output/cs-attachments.csv
