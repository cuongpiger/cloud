* **Course**: [https://www.udemy.com/course/aws-certified-cloud-practitioner-new](https://www.udemy.com/course/aws-certified-cloud-practitioner-new/)
* **Course resources**: [https://courses.datacumulus.com/downloads/certified-cloud-practitioner-zb2](https://courses.datacumulus.com/downloads/certified-cloud-practitioner-zb2/)
![](img/cover.png)

# Section 1. Introduction
* AWS Certification journey.
  ![](img/sec01/01.png)

* AWS Free tier [https://aws.amazon.com/free](https://aws.amazon.com/free)

# Section 4. IAM - Identity and Access Management
## 1. IAM Users & Groups Hands On
* Teach you how to create IAM users and groups.
* Add users to groups.
* Grant permissions to groups.
* Alias for users and then login to AWS console.

## 2. IAM Policies
* IAM policies are JSON documents.
* Learn about the different types of policies.

## 3. IAM Policies Hands On
* Create a policy.
* Attach the policy to a specific user.
* Attach the policy to a group.
* Find out what permissions the user has.
* Find out about the inheritance of permissions.

## 4. IAM MFA Hands On
* Enable MFA for `root` user.
* Customize users' password policy.

## 5. AWS Access Keys, CLI and SDK
* Access keys are used to access AWS services programmatically. It is generated through AWS Console.
* Users manage their own access keys.
* Access keys are not shared, just like passwords.
  * Access Keys ID is like username.
  * Secret Access Key is like password.
* AWS CLI is a command line tool to access AWS services programmatically.
* AWS SDK is a library to access AWS services programmatically.

## 6. AWS CLI Hands On
* Access key + Secret key of account `manhcuong`: `AKIA6A6SC7RBINJWMCOK` / `lPM3bhv6Ce/dqHNl0qtWGsU3H2y9yd/GFi4OV9Y7`
* Set user's configuration: `aws configure` by using access key and secret key.
* Some commands:
  | Command | Description |
  | --- | --- |
  |`aws iam list-users`| List all configured users |

## 7. AWS CloudShell: Region Availability
* Currently, AWS CloudShell is available in the following AWS Regions:
  * US East (Ohio)
  * US East (N. Virginia)
  * US West (Oregon)
  * Asia Pacific (Mumbai)
  * Asia Pacific (Sydney)
  * Asia Pacific (Tokyo)
  * Europe (Frankfurt)
  * Europe (Ireland)

## 8.AWS CloudShell
* **AWS CloudShell** is a browser-based shell for managing your AWS resources. It is just an alternative to AWS CLI.

## 9. IAM Roles for AWS services
* Some AWS services will need to perform actions on your behalf $\Rightarrow$ To do so, we will assign permissions to AWS services with **IAM Roles**.
* **IAM Roles** are similar to **IAM Users**. It is used by AWS services to access AWS resources instead of **IAM Users**.
* For example:
  * **IAM Roles** can be used by **EC2 Instance** _(virtual server)_. To do so, we will create an **IAM Role** and attach a **policy** to it. Then, we will assign the **IAM Role** to the **EC2 Instance**.
  * Common roles:
    * **EC2** instance roles.
    * **Lambda** function roles.
    * Roles for **CloudFormation**.

## 10. IAM Roles Hands On
* Find out how to create an **IAM Role**.

## 11. IAM Security tools
* Find out about IAM Credential Report (account level).
* Find out about IAM Access Advisor (user level).

## 12. IAM Security tools hands on
* Credential reports can be used to generate the `*.csv` file that contains all the information about the users in the account.
* Using **Access Advisor** to find out which users have access to which services, and then you can remove the access to those services if they are not needed.

## 13. IAM Best Practices
* **DO NOT** use the **root** account except for AWS account setup.
* One physical user = One AWS user.
* Assign users to groups and assign permissions to groups.
* Create a **strong password policy**.
* Use and enforce the **use of MFA**.
* Create and use **IAM roles** for giving permissions to AWS services.
* Use Access Keys for programmatic access (CLI/SDK).
* Audit permissions of your account with the IAM Credential Report and IAM Access Advisor.
* Never share IAM users & Access Keys.

## 14. Shared Responsibility Model for IAM
* Look at the slide 55 for more details.

# Section 5. EC2 - Elastic Compute Cloud
## 5.1. AWS Budget setup
* Go to **Account** > **IAM User and Role Access to Billing Infomation** > **Edit** > **Enable Activate IAM Access** > **Save Changes**.

## 5.2. EC2 basics
### 5.2.1. Amazon EC2:
* EC2 is once of the most popular of AWS' offering
* EC2 = Elastic Compute Cloud = Infrastucture as a Service (IaaS)
* It mainly consists in the capability of:
  * Renting virtual machines (EC2)
  * Storing data on virtual drives (EBS)
  * Distributing the load across machines (ELB)
  * Scaling the services using an auto-scaling group (ASG)
* Knowing EC2 is fundamental to understand how the Cloud work.

### 5.2.2. EC2 sizing & configuration options
* Operating System (OS): Linux, Windows, or MacOS.
* How much compute power & cores (CPU)
* How much randam-access memory (RAM)
* How much storage space:
  * Network attached (EBS & EFS)
  * Hardware (EC2 instance store)
* Network card: speed of the card, public IP address.
* Firewall rules: security group.
* Bootstrap script (configure at the first launch): EC2 user data.

### 5.2.3. EC2 user data
* It is possible to bootstrap our instance using an EC2 user data script.
* **Bootstrapping** means launching commands when a machine starts.
* That script is only run **once** at the instance **first start**.
* EC2 user data is used to automate boot tasks such as:
  * Installing updates.
  * Installing software.
  * Downloading common files from the internet.
  * Anything you can think of.
* The EC2 user data scripts runs with the root user.

### 5.2.4. EC2 instance types: example
![](./img/sec05/01.png)


## 5.3. Create an EC2 instance with EC2 user data to have a webiste hands on
### 5.3.1. Hands-On: Launcing an EC2 instance running Linux
* We will launcing our first virtual server using the AWS console.
* We will get a first high-level approach to the various parameters.
* We will see that our web server is launched using EC2 user data.
* We will learn how to start/stop/terminate our instance.