# Cloud Custodian Demo

### Install Prerequisites

```
brew install terraform
```

### Install Cloud Custodian

```
python3 -m venv custodian
source custodian/bin/activate
pip install c7n
```

### Create Demo AWS Environment

```
cd terraform
terraform init
terraform apply --auto-approve
```

The terraform apply command will output the ARN of the IAM role to be used by Cloud Custodian lambda functions to manage AWS resources.

### Run Cloud Custodian

```
custodian run -r eu-west-1 -s . -m aws custodian-offhours.yml
```
