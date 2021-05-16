# sFTP HA Example

Deploy backends in ASG, NLB, NAT GW, Private or Public subnets.


## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Deploy the code:

```
terraform init
terraform apply
```

When the `apply` command completes, it will output the DNS name of the load balancer. To test the load balancer:

```
ssh http://<nlb_dns_name>/
```

Clean up when you're done:

```
terraform destroy
```


## Still to do

* Instructions to populate caccount.txt
* Tags need to be outputted as per spec.

## Given enough time

* Move SFTP accounts to Parameter store or  Dynamo DB sorted by stage

## In other news
https://aws.amazon.com/blogs/aws/new-aws-transfer-for-sftp-fully-managed-sftp-service-for-amazon-s3/
https://www.squaremeal.co.uk/restaurants/sanminis_10180
