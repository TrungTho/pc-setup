.PHONY: run
run:
	ansible-playbook -v deps-installation.yml

.PHONY: debug
debug:
	ansible-playbook -vvv deps-installation.yml

.PHONY: fmt
fmt: 
	tofu fmt --recursive

.PHONY: validate
validate: fmt
	tofu validate

.PHONY: plan
plan: validate
	tofu plan

.PHONY: apply
apply:
	tofu apply -auto-approve;

.PHONY: stop
stop:
	INSTANCE_ID=$$(tofu output -raw instance_id); \
	aws ec2 stop-instances --instance-ids $$INSTANCE_ID

.PHONY: start
start:
	INSTANCE_ID=$$(tofu output -raw instance_id); \
	aws ec2 start-instances --instance-ids $$INSTANCE_ID; \
	aws ec2 wait instance-running --instance-ids $$INSTANCE_ID

.PHONY: ssh
ssh:
	PRIVATE_KEY_NAME=$$(tofu output -raw private_key_file); \
	PUBLIC_IP=$$(tofu output -raw instance_public_ip); \
	ssh -i $$PRIVATE_KEY_NAME ubuntu@$$PUBLIC_IP