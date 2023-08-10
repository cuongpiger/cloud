###### [_↩ Back to `homepage`_](./../../../README.md)

###### 🌈 Table of contents
- ##### [Section 4. IAM - Identity and Access Management](#section-4-iam---identity-and-access-management-1)
  - ##### [14. IAM Introduction: Users, Groups, Policies](#14-iam-introduction-users-groups-policies-1)
  - ##### [15. IAM Users and Groups Hands on](#15-iam-users-and-groups-hands-on-1)
  - ##### [16. IAM Policies](#16-iam-policies-1)

<hr>

# [Section 4. IAM - Identity and Access Management](#section-4-iam---identity-and-access-management)
## [14. IAM Introduction: Users, Groups, Policies](#14-iam-introduction-user-groups-policies)
- IAM is a **global service**.
- There are 2 main types of **Users** in IAM:
  - **Root user**: created when you first setup your AWS account. Has complete Admin access.
  - **IAM Users**: you create them from **Root user**, they have no permissions by default. They are associated to a **Policies**.
- IAM allow you to create **Groups** to group users and apply **Policies** to them.
- **Groups** only contain **Users**, not other **Groups**.
- You can create **Policies** and apply them to **Users** or **Groups**.
- You also alias your **IAM Users** to easily login to the AWS Console.

## [15. IAM Users and Groups Hands on](#15-iam-users-and-groups-hands-on)
- Demo: create a new **IAM User** and add it to a **Group**.
- Watch this video [https://www.udemy.com/course/aws-certified-cloud-practitioner-new/learn/lecture/20281863#content](https://www.udemy.com/course/aws-certified-cloud-practitioner-new/learn/lecture/20281863#content).

## [16. IAM Policies](#16-iam-policies)
- This section teachs you the structure of **Policy** in IAM.
- A **Policy** is a **JSON** document that defines one (or more) **Permissions**.