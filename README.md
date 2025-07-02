# triggered-ts
Triggered teamspeak in the cloud

## Initial deployment
1. Login to the AWS account you want to deploy to in your CLI and run 
```tf -chdir=initial-infra init; tf -chdir=initial-infra apply --auto-approve```.
This is to create the S3 bucket and dynamodb table to use shared remote state.