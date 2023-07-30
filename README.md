###### [_↩ Back to `main` branch_](https://github.com/cuongpiger/cloud/)

###### 🌈 References
- **Course**: [https://www.udemy.com/course/aws-certified-cloud-practitioner-new](https://www.udemy.com/course/aws-certified-cloud-practitioner-new/)
- **Course resources**: [https://courses.datacumulus.com/downloads/certified-cloud-practitioner-zb2](https://courses.datacumulus.com/downloads/certified-cloud-practitioner-zb2/)
- **Slides**: [AWS Certified Cloud Practitioner Slides v5.pdf](./docs/slides/AWS%20Certified%20Cloud%20Practitioner%20Slides%20v5.pdf)


###### 🌈 Table of contents
- ##### [Section 5. EC2 - Elastic Compute Cloud](./docs/notes/section05/README.md)
  - ##### [45. Instance Roles Demo](./docs/notes/section05/README.md#45-instance-roles-demo-1)
  - ##### [46. EC2 Instance Purchasing Options](./docs/notes/section05/README.md#46-ec2-instance-purchasing-options-1)
  - ##### [47. Shared Responsibility Model for EC2](./docs/notes/section05/README.md#47-shared-responsibility-model-for-ec2-1)
  - ##### [48. EC2 Summary](./docs/notes/section05/README.md#48-ec2-summary-1)

<hr>

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

