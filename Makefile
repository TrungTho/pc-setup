.PHONY: run
run:
	ansible-playbook -v -i inventories/raw.yml deps-installation.yml

.PHONY: debug
debug:
	ansible-playbook -vvv -i inventories/raw.yml deps-installation.yml

.PHONY: fmt
fmt: 
	tofu -chdir=./clouds fmt --recursive

.PHONY: validate
validate: fmt
	tofu -chdir=./clouds validate

.PHONY: plan
plan: login validate
	tofu -chdir=./clouds plan;

.PHONY: apply
apply: login
	tofu -chdir=./clouds apply -auto-approve;

.PHONY: stop-vm
stop-vm: login
	cd ./clouds && INSTANCE_ID=$$(tofu output -raw instance_id); \
	aws ec2 stop-instances --profile platform-sandbox --instance-ids $$INSTANCE_ID

.PHONY: start-vm
start-vm: login
	cd ./clouds && INSTANCE_ID=$$(tofu output -raw instance_id); \
	aws ec2 start-instances --profile platform-sandbox --instance-ids $$INSTANCE_ID; \
	aws ec2 wait instance-running --profile platform-sandbox --instance-ids $$INSTANCE_ID

.PHONY: ssh
ssh:
	PRIVATE_KEY_NAME=$$(tofu -chdir=./clouds output -raw private_key_file); \
	PUBLIC_IP=$$(tofu -chdir=./clouds output -raw instance_public_ip); \
	cd ./clouds && ssh -i $$PRIVATE_KEY_NAME ubuntu@$$PUBLIC_IP

.PHONY: login
login:
	@ # The '|| true' ensures 'make' doesn't stop if the AWS command fails.
	@AWS_CHECK=$$(aws sts get-caller-identity --profile platform-sandbox 2>&1 || true); \
	\
	if echo "$$AWS_CHECK" | grep -q "profile has expired"; then \
		echo "Credentials expired. Running SSO login..."; \
		sh clouds/aws-sso.sh 465836752403 AVM-AdministratorAccess-d97965; \
	else \
		echo "No expiration detected. Skipping login."; \
	fi
