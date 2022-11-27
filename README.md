# Deploying a Web Server in Azure

## Introduction
These templates will help you deploy a Web Server in Azure.

## Gettimg Started
Before you deploy a Web Server in Azure, You will need to :
* Have an Azure Account
* Have an Installation of the latest version of Terraform.
* Have an installation of the latest version of packer
* Have an installation of the latest version of the Azure CLI

How the code is used
* the policy.json file is used to enforce a tag policy on all the resources
* The parker template(server.json) is used to deploy the image of the Vms
* Replace the "Client_Id","client_secret" and subscription_id with your own details
* the Terraform template is used to deploy the Web Server in Azure

## Instructions (packer & Terraform template)
* To run the packer template, run the  "packer build server.json" command in your Azure CLi
* To run the Terraform template, do the following:
- Run the "Terraform init" command in your Azure cli
- Next, type in "Terraform validate" to ensure that the configuration is correct
- Type in "terraform plan -out soltion.plan" and run the command
- Type in "terraform apply "solution.plan" and run the command, to deploy the web server
- lastly run the "terraform destroy" command if you want to destroy the web server.

## How to customize the var.tf file
* the var.tf file is used to keep the code in the main.tf file dry
* the variables can be changed by changing the default values in each variable
* an example of the default value in the variable "prefix" represents the name of the already built an already built in resource group in Azure. This should be replaced by the resource group you create in your portal
* the default values can be easily changed to fit your specific web server needs.
*read the variable descriptions when in doubt.

## OUTPUT
for the expected output, please check the screenshots found in the zip file.