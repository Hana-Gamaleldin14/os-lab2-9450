DIR ?= ./dir
MALICIOUS_DIR ?= ./malicious_dir
INTERVAL ?= 5

.PHONY: all run restore pre-build clean

all: pre-build run

pre-build:
	@mkdir -p $(DIR)
	@mkdir -p $(MALICIOUS_DIR)

run: pre-build
	chmod +x antivirusd.sh
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: pre-build
	chmod +x restore.sh
	./restore.sh $(DIR) $(MALICIOUS_DIR)

clean:
	rm -f directory-info.last directory-info.new .whitelist
