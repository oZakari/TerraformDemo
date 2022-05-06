# Terraform Virtual Machine

Terraform template to provision a standalone Azure virtual machine including all prerequisite resources.


## Login to Azure Subscription using Azure CLI

```bash
# Step 1
az login

# Step 2
az account list --output table

# Step 3
az account set --subscription "SubscriptionName"

```

## Create local.tfvars File in Same Directory
Example of File Contents:

```bash
environment_prefix = "poc"
region             = "southcentralus"
vm_size            = "Standard_D2s_v5"
computer_name      = "tfpoc"
admin_username     = "devuser"
admin_password     = "Terr@f0rm!@#"

```

## Terraform Commands for Creating Resources

```bash
# Step 1
terraform init

# Step 2
terraform plan -var-file="local.tfvars" -out tfplan

# Step 3
terraform apply tfplan

```

## Terraform Commands for Deleting Resources

```bash
# Step 1
terraform plan -destroy -var-file="local.tfvars" -out tfplan

# Step 2
terraform apply -destroy tfplan 

```
## License
[MIT](https://choosealicense.com/licenses/mit/)