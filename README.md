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

Create a file myfiles/caccount.txt which contains a file formatted as:  
```
username|password|rsakey
```

Each of these SFTP accounts will be created with either a username or key or both for example foo1 will be created with an ssh key and foo2 will be created with a password starting
d12df

```
foo1||ssh-rsa AAAAB3.....continues
foo2|d12df^d£cvik3|
```

```
terraform init
terraform apply
```

When the `apply` command completes, it will output the DNS name of the load balancer. To test the load balancer:

```
sftp foo2@<nlb_dns_name>
```

Clean up when you're done:

```
terraform destroy
```


## Instructions to add new accounts

Find the bucket config name - by default this is config_bucket_name = "bobbins2-sftp-effective-carnival-latest-config".
Download and re-upload the ccaccount.txt file held in this bucket. Accounts will be created by a cron job running on the minute.


## Given enough time

* Move SFTP accounts to Parameter store or  Dynamo DB sorted by stage

## In other news
https://aws.amazon.com/blogs/aws/new-aws-transfer-for-sftp-fully-managed-sftp-service-for-amazon-s3/
https://www.squaremeal.co.uk/restaurants/sanminis_10180
