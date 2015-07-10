#!/tools/bin/bash
rm output/*.csv
time perl ../import_attachments.pl --source cq=source/ctrl_all_nx1.json --filter "Project = Controller" $* >output/ctrl-attachments.csv
