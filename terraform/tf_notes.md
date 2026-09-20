### Intro
Terraform is for provisioning infrastructure, while tools like Ansible, Chef, Puppet are for installation and configuration of the software.
Terraform works well with software automation tools like Ansible, anyway. Jenkins is used in automating the orchestration of building, testing and deploying software. 

###  General Notes
 - Data sources can be defined and reused in another resource by using the dot`[.]` operation as access pointer. For example, `data.ami_virtual.ubuntu.id` is pointing to a data map defined, named `data` and with `ami_virtual` and `ubuntu` as identifiers.
 - ![Terraform registry](https://registry.terraform.io/) is a resource for samples of this data sources. There is also ![Terrafrom HashiCorp developer note](https://developer.hashicorp.com/terraform/intro) for documentation and learning resources on Terraform. The TF built-in functions like `file`, `join`, etc. are enumerated in this documentation.
 - The provider section of the Terraform's registry, among others, extensively describe the resource templates and the attribute reference. There are resource names, resource types, etc, such as `public_ip` and `public_subnets` that must be written as defined in the Terraform documentation.
 - Error of `Your query returned no results` when `aws_ami` , or any resource name, is used is often caused by (1) no available resource in the definition within the specified region, (2) name filter match with the current naming convention.
 - Terraform state, tracked by the `terraform.tfstate` file, is the kept and consistently updated records of resources managed by Terraform. When `terraform apply` is executed, terraform compares the record in its state with the actual record, that is available service in the actual environment. 
 - Another important and related file is the `terraform.tfstate.backup` which backs up the previous state file before Terraform writes anything new to the state file. It is used for recovery in case of accidental modification.
   It will then plan for creating or modifying the services as defined in the terraform file, if it does not exist in the actual environment.
 - Idempotency - due to the state tracking, it does not matter the number of times the `terraform apply` is run, it will only apply once as the state would indicate that the service is already in place.
 - Drift - when a service is already in the computing environment, but not tracked by Terraform state, it is recommended such service is imported into the terraform state for immediate and subsequent management to avoid duplication because TF would re-create resources that the state has no knowledge of.
 - There are terraform state commands that can be used to manipulate the state without a complete destuction of the existing resource, especially if it is just trivial activiites like file naming, resource migration, etc.
 - Almost every thing you build, especially as resource, has its TF-recognizable resource type name which must conform. This also applies to field name within the resource.
 - The Terraform workflow starts with (i) write - creating and modifying the TF configuration files (this is done by you), (ii) plan - preview changes before applying them (TF does this based on what it sees in the configuration files),
   (iii) apply - TF now implements the configuration written and planned. Best practices for `terraform apply` include (a) before apply - always review plan; ensure in you're in the right directory; test in non-production, (b) during apply - read the plan carefully,
   watch for unexpected changes; be patient with large applies, and (c) after apply - verify changes, commit your configurations and document significant changes.

 ### Basics of HashiCorp Configuration Language (HCL)
 - Code is generally organized into blocks and these are like kind of containers that group related configuration together.
    ```terraform
        block_type "block_label" "block_label"{
            first_argument = expression or value
            second_argument = expression or value
        }
    ```
- Comments can be added when as a single line with # comment or /** block comment **/
- Data blocks are used for retrieving information about existing resources
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
 - Embrace appropriate use of file extensions, formatting, organization, commenting and documentations, and avoid using hard-coded values.

### Resource Referencing
- HCL supports dynamic configurations whereby Terraform uses the properties from one resource as an input in another, avoiding hardcoding.
- Terraform also automatically maps dependencies by determining the order of resource creation based on references.
- Terraform uses resource identifiers where resource is given a unique name that allows it a unique address in the state file. This address can then be referenced by other resource.

### Resource Graph
- After running `terraform plan`, TF automatically builds a dependency graph from the configuration files to determine the order in which the `create`, `update` or `destroy` will be applied.
- The order of the resource declaration in the `.tf` files does not matter.
- Resource graph helps TF to achieve parrallel execution and also serves as the foundation of understanding resource referencing. That is, which resources points to the other to determine the dependencies and which resource needs to be built/created before the other. 
  This also helps in understanding when to use the explicit `depends_on`.
- Dependencies could be implicit or explicit. The implicit dependencies are automatic references to another resource that Terraform already knows about. The explicit is manual, needed to state when TF cannot automatically identify the dependencies. The argument `depends_on` is used for explicit dependency.
- Terraform walks the resource graph through parrallel execution. This means nodes are processed as soon as their dependencies are satisfied and the non-dependent resources are created/modified simultaneously. The default configuration in Terraform allows it to manage 10 operations in parrallel.
This can be modified through the `-parallelism` flag. 

### Terraform Core Components
- Core - this is the CLI tool that provisions and manages the infrastructure resources defined in the TF configuration files.
- Providers - these are the public cloud providers, SaaS offerings, etc., which serve as bridge in bringing into built what the configuration files define.
  Providers give Terraform the neccesary instructions to communicate with the platforms.
- Resources - these are the infrastructure components that are managed by Terraform. These can vary from virtual machines, to databases, to repository, etc.
  The resources have their standard referenced names and attributes in declaring their configuration set up.
- State - this is what helps Terraform maps the desired configuration with the real world resources on the target platform. Can be described as Terraform memory.

### Commands and their uses
Terraform CLI generally provides unified workflow that ensures consistency and repeatability.

`terraform init` - to initialize the terraform backend server based on the defined utility provider. It's the first command to run in a new Terraform project. It produces `.terraform` directory (advisable to be .gitignored, not a source code and should not be committed) which contains the `providers` and `modules` sub-directories. 
The `.terraform/providers` stores cached versions of the configuration's providers - a kinda tooolbox needed by TF to get its work done. The `.terraform/modules` contains downloaded versions of modules referenced in the configurarion files. 
The command is also going to be required anytime the backend settings changed (provider version, provider change), the module is updated with a new one, etc. `init` also produces `.terraform.lock.hcl` in the working directly. This file is expected to be committed, because it ensures everyone working on the project CI/CD uses the same provider version. 
The `.terraform.lock.hcl` file locks dependency versions for consistency across your working environment. `terraform init -upgrade` can be run to upgrade existing providers and modules' versions.

`terraform plan` - Previews changes to be applied. It generates an execution plan that shows the changes TF will make to the real-world resources to match the desired state configuration. The plan shows the resources to be created, giving the opportunity to revise and avoid unintended changes. This is the first time that TF reaches out to the providers' platform through its APIs. 
Though, it is not required since `terraform apply` can be applied directly but it is advisable so that planned changes are reviewed. To output the TF plan for external saving, use `terraform plan -out`.

`terraform plan -out` - helps in situations whereby plans need to be approved before being applied. The output is guaranted to be applied. Saving terraform plan is through `terraform plan -out=myplan_file.tfplan`. The `myplan_file` is a placeholder for any filename. You don't need the extension to be be `.tfplan` either, though it has become a kind of industry convention. 
Applying the saved plan is through `terraform apply myplan_file.tfplan` command.

`terraform apply` - Apply (Plans and provisions) the resources based on the declaration. Needs to be confirmed by a `yes` input in the prompt. When no change made to the declared resource after it is already ran, it does nothing.
The `apply` operation involves (i) state locking - the state file is locked to avoid concurrent modifications, (ii) state file is updated for each resource when it is succesfully created/modified/destroyed (not at the end of all the operations),
(iii) Terraform does not roll back succesful implementation - they remain in place, (iv) the dependency order is preserved in the sequence the apply is effected. 
TF apply can be done in varieties of ways: (i) The `terraform apply` way where you type 'yes' to confirm. It is also the safest way, (ii) `terraform apply plan.tfplan` way when ypu saved the execution plan. This does not do additional plan and does not request for approval.
(iii) `terraform apply -auto-approve` to skip the comfirmation prompt entirely. Therefore, this must be used cautiously, and (iv) for auto CI/CD pipelines - `terraform apply -auto-approve input=False` to skips approval and not ask for any input.

`terraform apply -var instance_type=[INSTANCE_NAME]` for example, can be used to add variable value to the environment. Another way of using the `apply` command. An exampleof this is `t4.micro`

`terraform apply -target [target-module]` - used to target a particular module for terraform apply. The `[target-module]` can be `module.vpc`, for example.

`terraform apply -parallelism=5` - used in modifying the default number (i.e. 10) of the parrallel operations that TF can apply. Parallelism flag can be applied to `plan`, `apply` and `destroy`. Use cases for applying the parallelism flag to reduce the number of operations to be parallelized are (a) managing providers' API rate limit, or 
(b) slowing down the operations during debugging and troubleshooting for visual walkthrough.

`terraform taint [resource-name]` - is used when a partiular resource is needed to be re-created. An example in the `terraform/first-steps` directory is `aws_instance.web`. The `terraform apply` command would then be applied to complete the re-creation.

`terraform output` - used to log into the output variable values to the console.

`terraform fmt -recursive` - to format ALL the `.tf` files in all the directories, while `terraform fmt` just formats the `.tf` files in the working directory.

`terraform validate` - checks syntax and configuration correctness. It helps in ensuring the structure is valid. `validate` is only about syntax and structure and does not guarrantee that the configuration
will be succesfully deployed. The command does not communicate with the providers; it's 100% local. Therefore, it's logical to understand that `validate` does not catch every error such as those that will need 
providers' engagement to be caught. This command can only be run after the initialization through `terraform init`.

`terraform destroy` - to destroy all declared resources. Resources managed by TF in the declared workspace are removed. Different ways to use the `destroy` command.
First, through the general explicit command whereby TF does a destruction plan and prompts for an approval 'yes' before applying them. Second, which is more common in real-world pratice -
remove the individual resources no longer wanted from the configuration `.tf` files, and with `terraform apply`, such resources are deleted from the real world space.

`terraform destroy -target=<resource_name>` can be used to destroy name using its address name. But if such resource is not removed from configuration file, TF will attempt
to create it in its next `terraform apply`. Resources not managed bt TF are not going to be affected by the `destroy` command.

`terraform console` - used to demonstrate TF commands, functions, for example, reading terraform configuration, all through the CLI.

`terraform state` - to manage items in the state file. `terraform state list` lists the resources being managed by the state file at the time.

`terraform show` - to display information about your managed infrastructure.

`terraform import` - to bring existing infrastructure under Terraform's management

`ssh -i webkey ubuntu@54.167.108.53` where ubuntu is the EC2 (Elastic Compute Cloud) AMI, and 54.167.108.53 is the public ip

### Using Environment variables with the CLI
- Environment variables provide a way of passing configuration settings and credentials into TF without hardcoding them.
- They secure sensitive data API and allows TF to pick them up automatically, especially when interacting with API keys, authentication tokens, etc.
- Commonly used env variables are `TF_LOG` (setting the level of comnsole logging for debugging and monitoring); `TF_VAR_svr_name` as an example of variable name to be passed through the environment, requiring it is prefixed by `TF_VAR`; `AWS_ACCESS_KEY_ID` as an example of any cloud provider security credentials.

### Using the CLI for help
- Terraform's CLI provides some learning resources. First, the autocomplete helps in completing a command by pressing the tab key after typing `terraform`. However, the autocomplete installation must be first done through `terraform -install-autocomplete`.
- `terraform --help` is also very handy as it lists all TF commands with accompnaying short descriptions. For specific command, `terraform <command> --help` gives a breakdown what the command does. For example, `terraform apply --help` gives  a breakdown of what the `apply` command does.

### Provisioning
Installing software on provisioned EC2 instance, for example: there are tools, capable of SSHing to the instance, like Ansible to handle this.
TF makes a way to also do this through `user_data` functionality. It will help in making software available on your instance while creating it. When making new updates to the instance, the instance is re-created. More importantly, with `user_data`, TF doesn't need SSH access to have it executed.

The `user_data` can be used to pass templates - mimicking Dockerfile-type of installation instruction statements, to install software into the SSH. This then can be observed when SSHed to the EC2, go sudo, and check the `var/log/cloud-init-output.log`.
Additional data can be synced from storage such as AWs S3 bucket into the EC2 instance - achieveable by passing s3 bucker attributes into the `user_data` bloc in the EC2, and ensure that a S3 sync command is added into the template (like `web.tpl`) that would be installed.

The `user_data` is the recommended approach from the TF documentation. However, there is also `provisioner` (of a last resort)