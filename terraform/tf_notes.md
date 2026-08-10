### Intro
Terraform is for provisioning infrastructure, while tools like Ansible, Chef, Puppet are for installation and configuration of the software.
Terraform works well with software automation tool like Ansible, anyway. Jenkins is used in automating building, testing and deploying software. 

### Notes
 - Data sources can be defined and reused in another resource by using the dot`[.]` operation as access pointer. For example, `data.ami_virtual.ubuntu.id` is pointing to a data map defined, named `data` and with `ami_virtual` and `ubuntu` as identifiers.
 - ![Terraform registry](https://registry.terraform.io/) is a resource for samples of this data sources. There is also ![Terrafrom HashiCorp developer note](https://developer.hashicorp.com/terraform/intro) for documentation and learning resources on Terraform.
 - The provider section of the Terraform's registry, among others, extensively describe the resource templates and the attribute reference
 - Error of `Your query returned no results` when `aws_ami` is used is often caused by (1) no available resource in the definition within the specified region, (2) name filter match with the current naming convention.
 - Terraform does not pass variables between the different files of the same module, like we do `import` in `Python`, for example. It loads them together regardless of their filenames
    - What I have in the `first-steps/instance.tf` can become:
     - `variables.tf`
    ```terraform
        variable "aws_region" {
            description = "AWS region to deploy resources"
            type        = string
            }
    ```
     - `provider.tf`
    ```terraform
       provider "aws" {
        region = var.aws_region
        }
    ```
     - `instance.tf`
    ```terraform
        resource "aws_instance" "example" {
            ami           = data.aws_ami.ubuntu.id
            instance_type = "t2.micro"

            tags = {
                Name = "example"
            }
            }
    ```
     - `terraform.tfvars`
    ```terraform
        aws_region = "us-west-2"
    ```
 - Block definition could has three types (i) block type, (ii) resource type and, (3) reference name. In the example of `instance.tf` above, block type is 
 `resource`, resource type is `aws_instance`, and reference name is `bar`.

 - For variables, their block type must be named `variable` as 
    ```terraform
        variable "image_id" = {
            type = string
        }
    ```
 - Variables are usually declared in `variables.tf` file, but assigned values in a `.tfvars` file which could be more than one. For example, you can have `prod.tfvars` and `dev.tfvars` which assign different variable values, based on the environment, to the same variable declared in the `variables.tf` file.
 - There is also `output` as a block name. They are used in writing out resource attributes. For example, an EC2 instance's public IP address can be read out, even as input for another variable value.

### Commands and their uses

`terraform init` - to initialize the terraform backend server. It produces `.terraform` (advisable to be .gitignored) which contains downloaded provider plugins. module caches and other local working files. Not a source code and should not be committed. It is also produces `terraform.lock.hcl` which should be committed because it ensures everyone working on the project CI/CD uses the same provider version.

`terraform plan` - Previews changes to be applied

`terraform apply` - Apply (Plans and provisions) the resources based on the declaration. Needs to be confirmed by a `yes` input in the prompt. When no change made to the declared resource after it is already ran, it does nothing.

`terraform apply -var instance_type=t4g.micro` for example, can be used to add variable value to the environment. Another way of using the `apply` command.

`terraform fmt -recursive` - to format the `.tf` files.

`terraform validate` - check syntax and configuration

`terraform destroy` - to destory all declared resources.

`terraform console` - used to read terraform configuration through the CLI.