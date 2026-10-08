cat << 'EOF' > README.md
# Antivirus Daemon & Restore 

## Project overview
 This project implements simple antivirus system having the antivirusd.sh which checks every almost 5 sec for a malicious file extension or a file that have a suspicious keyword and the restore.sh file which can restore the file back if there was a mistake in checking it and it is safe or delete it as it was malicious or leave it as it is and we have the make file which controls the whole project
 
To sum up the system can:
-Monitor a directory for newly added files or modified ones
-Detect suspicious files based on extensions & keywords 
-Move detected malicious files to separate quarantine directory
-Have a whitelist for safe & trusted files 
-Provide interactive script to review quarantined files
-Perform scheduled antivirus ascans using cron
## Folder Hierarchy 
.
├── antivirusd.sh        # Antivirus monitoring daemon
├── restore.sh           # Interactive quarantine review script
├── antivirus-cron.sh   # Cron-scheduled scan script
├── Makefile             # Run and build targets
└── README.md            # Lab documentation
