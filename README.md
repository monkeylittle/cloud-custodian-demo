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

### Run Cloud Custodian

```
custodian run --region eu-west-1 --output-dir=. custodian.yml
```
