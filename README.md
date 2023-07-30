[_↩ Back to `main` branch_](https://github.com/cuongpiger/cloud/)

- **Course**: [https://www.udemy.com/course/aws-certified-cloud-practitioner-new](https://www.udemy.com/course/aws-certified-cloud-practitioner-new/)
- **Course resources**: [https://courses.datacumulus.com/downloads/certified-cloud-practitioner-zb2](https://courses.datacumulus.com/downloads/certified-cloud-practitioner-zb2/)
  ![](img/cover.png)

# Section 1. Introduction

- AWS Certification journey.
  ![](img/sec01/01.png)

- AWS Free tier [https://aws.amazon.com/free](https://aws.amazon.com/free)

# Section 4. IAM - Identity and Access Management

## 1. IAM Users & Groups Hands On

- Teach you how to create IAM users and groups.
- Add users to groups.
- Grant permissions to groups.
- Alias for users and then login to AWS console.

## 2. IAM Policies

- IAM policies are JSON documents.
- Learn about the different types of policies.

## 3. IAM Policies Hands On

- Create a policy.
- Attach the policy to a specific user.
- Attach the policy to a group.
- Find out what permissions the user has.
- Find out about the inheritance of permissions.

## 4. IAM MFA Hands On

- Enable MFA for `root` user.
- Customize users' password policy.

## 5. AWS Access Keys, CLI and SDK

- Access keys are used to access AWS services programmatically. It is generated through AWS Console.
- Users manage their own access keys.
- Access keys are not shared, just like passwords.
  - Access Keys ID is like username.
  - Secret Access Key is like password.
- AWS CLI is a command line tool to access AWS services programmatically.
- AWS SDK is a library to access AWS services programmatically.

## 6. AWS CLI Hands On

- Access key + Secret key of account `manhcuong`: `AKIA6A6SC7RBINJWMCOK` / `lPM3bhv6Ce/dqHNl0qtWGsU3H2y9yd/GFi4OV9Y7`
- Set user's configuration: `aws configure` by using access key and secret key.
- Some commands:
  | Command | Description |
  | --- | --- |
  |`aws iam list-users`| List all configured users |

## 7. AWS CloudShell: Region Availability

- Currently, AWS CloudShell is available in the following AWS Regions:
  - US East (Ohio)
  - US East (N. Virginia)
  - US West (Oregon)
  - Asia Pacific (Mumbai)
  - Asia Pacific (Sydney)
  - Asia Pacific (Tokyo)
  - Europe (Frankfurt)
  - Europe (Ireland)

## 8.AWS CloudShell

- **AWS CloudShell** is a browser-based shell for managing your AWS resources. It is just an alternative to AWS CLI.

## 9. IAM Roles for AWS services

- Some AWS services will need to perform actions on your behalf $\Rightarrow$ To do so, we will assign permissions to AWS services with **IAM Roles**.
- **IAM Roles** are similar to **IAM Users**. It is used by AWS services to access AWS resources instead of **IAM Users**.
- For example:
  - **IAM Roles** can be used by **EC2 Instance** _(virtual server)_. To do so, we will create an **IAM Role** and attach a **policy** to it. Then, we will assign the **IAM Role** to the **EC2 Instance**.
  - Common roles:
    - **EC2** instance roles.
    - **Lambda** function roles.
    - Roles for **CloudFormation**.

## 10. IAM Roles Hands On

- Find out how to create an **IAM Role**.

## 11. IAM Security tools

- Find out about IAM Credential Report (account level).
- Find out about IAM Access Advisor (user level).

## 12. IAM Security tools hands on

- Credential reports can be used to generate the `*.csv` file that contains all the information about the users in the account.
- Using **Access Advisor** to find out which users have access to which services, and then you can remove the access to those services if they are not needed.

## 13. IAM Best Practices

- **DO NOT** use the **root** account except for AWS account setup.
- One physical user = One AWS user.
- Assign users to groups and assign permissions to groups.
- Create a **strong password policy**.
- Use and enforce the **use of MFA**.
- Create and use **IAM roles** for giving permissions to AWS services.
- Use Access Keys for programmatic access (CLI/SDK).
- Audit permissions of your account with the IAM Credential Report and IAM Access Advisor.
- Never share IAM users & Access Keys.

## 14. Shared Responsibility Model for IAM

- Look at the slide 55 for more details.

# Section 5. EC2 - Elastic Compute Cloud

## 45. Instance Roles Demo
- `aws` CLI is installed by default inside the **EC2** instances.
- Users can use `aws` CLI to access the AWS services, such as list **IAM** users,...
- However, if we want to access other AWS services, such as **S3**, we need to configure the `aws` CLI with the **Access Key** and **Secret Key**. This is not a good practice because the **Access Key** and **Secret Key** are stored inside the **EC2** instance and can be stolen by people who have access to the **EC2** instance and log in to the instances later.
- To solve the third bullet problem, AWS allows us to create **IAM Roles** and assign them to the **EC2** instances. Then, the **EC2** instances can access the AWS services without using the **Access Key** and **Secret Key**.

## 46. EC2 Instance Purchasing Options
* Depends on the use case, your workload, and your budget, you can choose the most suitable **EC2** instance purchasing option.
* There are several options:
  * **On-Demand**: Pay as you go. No long-term commitment. Short workload, predictable pricing, and pay by second.
  * **Reserved**: Up to 75% discount compared to **On-Demand**. 1 or 3 year terms. If you intend to have a long workload (such as running a Database service inside the EC2 instance for a long time), you can choose this option.
  * **Convertible Reserved**: Similar to **Reserved**, but you can change the instance type if the workload changes. Up to 54% discount.
  * **Saving Plans**: Up to 72% discount. You commit to a specific amount of compute usage (measured in $/hour) for a 1 or 3 year term. You can choose to pay for the usage monthly or all upfront.
  * **Spot**: Up to 90% discount compared to **On-Demand**. Can lose instances if the **spot price** is higher than your **bid price**.
    * **Spot price**: The price of the instance at the current time.
    * **Bid price**: The price that you are willing to pay for the instance.
  * **Dedicated Hosts**: Physical dedicated EC2 server. Control instance placement.
  * **Dedicated Instances**: Instances running on hardware that's dedicated to you. May share hardware with other instances in the same account.
  * **Capacity Reservations**: Reserve capacity for your EC2 instances in a specific Availability Zone for any duration. This option is suitable for predictable workloads that require a specific type of instance all the time.
* Compare prices between different options.

## 47. Shared Responsibility Model for EC2
* AWS:
  * AWS is going to be responsible for **all data centers**, their **infrastructure**, and **physical security** of the hardware.
  * Make sure that you have isolation on the physical host if you are getting, for example, a **dedicated host**.
  * Replacing faulty hardware.
  * Make sure that they are still compliant with the **regulations** that they have agreed to.

* Users
  * Define your own **Security Groups** rules.
  * You own the entire VM inside of your **EC2** instance, so you are responsible for patching the OS, installing the software, and configuring the network, not AWS.
  * **IAM roles** assigned to EC2 instance and **IAM user access management**.
  * **Data security** on your instance.