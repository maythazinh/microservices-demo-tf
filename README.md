# microservices-demo-tf

Harbor Registry Integration: Secure image pulling from private registry

Service Accounts: Each microservice has its own identity

Role-Based Access Control: Granular permissions for each service

Image Pull Secrets: Automated credential management

Least Privilege: Services only get permissions they need



----------

1. Shared Infrastructure First

Creates the namespace and common resources
Sets up Harbor registry credentials
Defines RBAC policies

2. Microservices Second

Each service deployed independently
Automatically inherits shared security settings
Can be scaled and managed separately

using harbor container registry
https://bookinfo.may1.click/harbor/projects/2/repositories

![image](https://github.com/user-attachments/assets/b769a8fe-886c-460b-a937-27d73b885e94)
