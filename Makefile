.PHONY: run
run:
	ansible-playbook deps-installation.yml

.PHONY: debug
debug:
	ansible-playbook -vv deps-installation.yml