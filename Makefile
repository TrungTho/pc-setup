.PHONY: run
run:
	ansible-playbook -v -i inventories/raw.yml deps-installation.yml

.PHONY: debug
debug:
	ansible-playbook -vvv -i inventories/raw.yml deps-installation.yml

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

.PHONY: stop-vm
stop-vm: login
	INSTANCE_ID=$$(tofu output -raw instance_id); \
	aws ec2 stop-instances --profile platform-sandbox --instance-ids $$INSTANCE_ID

.PHONY: start-vm
start-vm: login
	INSTANCE_ID=$$(tofu output -raw instance_id); \
	aws ec2 start-instances --profile platform-sandbox --instance-ids $$INSTANCE_ID; \
	aws ec2 wait instance-running --profile platform-sandbox --instance-ids $$INSTANCE_ID

.PHONY: ssh
ssh:
	PRIVATE_KEY_NAME=$$(tofu output -raw private_key_file); \
	PUBLIC_IP=$$(tofu output -raw instance_public_ip); \
	ssh -i $$PRIVATE_KEY_NAME ubuntu@$$PUBLIC_IP
	ssh -i $(PRIVATE_KEY_NAME) ubuntu@$(PUBLIC_IP)

.PHONY: login
login:
	@ # The '|| true' ensures 'make' doesn't stop if the AWS command fails.
	@AWS_CHECK=$$(aws sts get-caller-identity --profile platform-sandbox 2>&1 || true); \
	\
	if echo "$$AWS_CHECK" | grep -q "profile has expired"; then \
		echo "Credentials expired. Running SSO login..."; \
		sh aws-sso.sh 465836752403 AVM-AdministratorAccess-d97965; \
	else \
		echo "No expiration detected. Skipping login."; \
	fi
