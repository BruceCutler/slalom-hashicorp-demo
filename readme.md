# Slalom Hashicorp Meetup Demo

This repository houses terraform code used to build the infrastructure which was created in the Slalom/Hashicorp meetup demo. Before getting started, I'd recommend a quick browse of the Terraform documentation: https://www.terraform.io/docs/index.html

We use the concept of stacks and modules to help us build our infrastructure in a layered approach. Stacks can be thought of as logical building blocks. A single stack can be made up of a number of modules. Modules are a standard Terraform feature, outlined here: https://www.terraform.io/docs/modules/index.html

As an example, consider the "Network" stack, which lives at terraform/stacks/network. The "Network" stack is comprised of 4 modules: VPC, Public Subnet, Private Subnet and Bastion.

<br>

### Setup:

Before you attempt to create infrastructure from your local machine using the Terraform code in this repo, you will need to configure the following on your local machine:

<br>

**1. A version of Terraform**

Terraform is an open source product which evolves very quickly. I'm currently running Terraform version 0.11.1. All release versions can be found here: https://releases.hashicorp.com/terraform/

Simply download the correct file for your operating system and unzip it. This will produce a "terraform" executable. Move this executable to somewhere on your machine that makes sense. For example:

*/Users/bruce.cutler/Terraform0.11.1/terraform*

Make sure that the location of terraform in your filesystem is added to your PATH (we recommend adding an entry to your .bashrc or .bash_profile if on Linux).

Once setup is complete, the easy way to check that terraform is configured correctly is to enter "terraform -version" in your shell/command prompt which should return information about the downloaded version.

<br>

**2. Install and configure AWS Command Line Interface (CLI)**

Follow the steps outlined in this document to install the AWS CLI: http://docs.aws.amazon.com/cli/latest/userguide/installing.html

Next, you need to generate an Access Key/Secret Access Key combination. Follow the section titled "To create, modify, or delete a user's access keys" from this document: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html

Finally, configure the AWS CLI to use the credentials above by following this document: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

<br>

**3. Create S3 bucket(s) for state files**

Follow the steps outlined in this document to create an S3 bucket to hold your state files: https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html

<br>

### Creating Infrastructure with Terraform

Once you have performed the above configuration steps, you can build infrastructure from this repo:

1. Clone the repo locally (git clone https://github.com/BruceCutler/slalom-hashicorp-demo)

2. To configure your newly created S3 bucket with the correct AWS region, you must update/create the appropriate file at **tools/aws/terraform/region/`<region>`/geo_config.sh**.

   For example, notice that in **tools/aws/terraform/region/us-east-1** I have **geo_config.sh** that ensures my bucket name is exported and available to the wrapper deployment script

3. Terraform is called using a wrapper script, found at tools/aws/terraform/tf_deploy inside the cloned repo

4. **tf_deploy** takes 3 arguments: -r, -t, -s
   
   **-r** = region (Example: us-east-1 or eu-west-1)

   **-t** = target (Example: dev/stg)

   **-s** = stack (Example: network)

   In addition to the above arguments, you must also supply a command such as **plan** or **apply**


5. As an example, to see a **plan** of the dev network stack in us-east-1, our command would be:

   ```sh
   $ tools/aws/terraform/tf_deploy -r us-east-1 -t dev -s network plan
   ```

6. If the plan looks good, we can run **apply** to create the dev network stack infrastructure in us-east-1 using:

   ```sh
   $ tools/aws/terraform/tf_deploy -r us-east-1 -t dev -s network apply
   ```

7. Finally, to **destroy** resources that you have created as part of the dev network stack, you should run:

    ```sh
   $ tools/aws/terraform/tf_deploy -r us-east-1 -t dev -s network destroy -force
   ```
   

