# !/bin/bash

subscriptionId=
clientId=
secret=
tenant=
# resource group you want to run the test
resourceGroup=

# check whether in root

# install user env
apt-get update && apt-get install -y libssl-dev libffi-dev python-dev python-pip
pip install ansible[azure]

# create credential file
mkdir ~/.azure
touch ~/.azure/credentials
echo "[default]
subscription_id=$subscriptionId
client_id=$clientId
secret=$secret
tenant=$tenant" >> ~/.azure/credentials

# set up dev mode
git clone https://github.com/VSChina/ansible.git
cd ansible
pip install virtualenv
virtualenv venv
. venv/bin/activate
pip install packaging azure azure-cli
pip install -r requirements.txt
pip install -r packaging/requirements/requirements-azure.txt
. hacking/env-setup

# test
touch test/integration/cloud-config-azure.yml
echo "AZURE_CLIENT_ID: $clientId
AZURE_SECRET: $secret
AZURE_SUBSCRIPTION_ID: $subscriptionId
AZURE_TENANT: $tenant

RESOURCE_GROUP: $resourceGroup
RESOURCE_GROUP_SECONDARY: $resourceGroup" >> test/integration/cloud-config-azure.yml
