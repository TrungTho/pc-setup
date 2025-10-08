#!/bin/bash
set -e;

if ! which jq; then
    echo ======== Installing jq ========;
    apt install -y jq;
else
    echo jq is already installed;
fi

ACCOUNT_ID=$1;
ROLE=$2;

echo ======== Unset env ========;
unset AWS_ACCESS_KEY_ID;
unset AWS_PROFILE;
unset AWS_SECRET_ACCESS_KEY;
unset AWS_SESSION_TOKEN;
unset AWS_DEFAULT_REGION;

echo ======== configuring platform-sandbox credentials... ========;

aws configure --profile platform-sandbox set sso_start_url https://mck-avm2.awsapps.com/start;
aws configure --profile platform-sandbox set sso_region eu-central-1;
aws configure --profile platform-sandbox set region us-east-1;
aws configure --profile platform-sandbox set sso_registration_scopes sso:account:access;
aws configure --profile platform-sandbox set output json;
aws configure --profile platform-sandbox set sso_role_name $ROLE;
aws configure --profile platform-sandbox set sso_account_id $ACCOUNT_ID;

echo ======== logging in ========;
aws sso login --profile platform-sandbox;
