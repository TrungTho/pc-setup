.PHONY: run
run:
	ansible-playbook -v deps-installation.yml

.PHONY: debug
debug:
	ansible-playbook -vvv deps-installation.yml