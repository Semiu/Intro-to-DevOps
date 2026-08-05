### Intro
Terraform is for provisioning infrastructure, while tools like Ansible, Chef, Puppet are for installation and configuration of the software.
Terraform works well with software automation tool like Ansible, anyway. Jenkins is used in automating building, testing and deploying software. 

### Notes
 - Data sources can be defined and reused in another resource by using the dot`[.]` operation as access pointer. For example, `data.ami_virtual.ubuntu.id` is pointing to a data map defined, named `data` and with `ami_virtual` and `ubuntu` as identifiers.
 - url{https://registry.terraform.io/} is a resource for samples of this data sources.


### Commands and their uses

`terraform init` - to initialize the terraform backend server. It produces `.terraform` (advisable to be .gitignored) which contains downloaded provider plugins. module caches and other local working files. Not a source code and should not be committed. It is also produces `terraform.lock.hcl` which should be committed because it ensures everyone working on the project CI/CD uses the same provider version.

`terraform apply` - Plans and provisions the resources based on the declaration. Needs to be confirmed by a `yes` input in the prompt. When no change made to the declared resource after it is already ran, it does nothing.

`terraform fmt -recursive` - to format the `.tf` files.

`terraform destroy` - to destory all declared resources.