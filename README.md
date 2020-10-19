#Description
A sample microservices project to represent the usage of AWS X-Ray.

#Usage

##Deploy
To deploy all layers of application use `./deploy.sh profile1 dev`   
where
* `profile1` is your AWS credentials profile
* `dev` is env/stage name

The script would go through `l1`, `l2`, `l3`, install dependencies and deploy API GW + Lambdas using `serverless framework`

##Get info
to get hosts and x-api-keys for all layers run `./get-hosts.sh profile1 dev`   
where
* `profile1` is your AWS credentials profile
* `dev` is env/stage name 

The script would go through `l1`, `l2`, `l3` and gets host and x-api-key data from deployed stacks

##Load testing
[Artillery](https://artillery.io) is used for load testing.   
Run `./load-test.sh profile1 dev`   
where
* `profile1` is your AWS credentials profile
* `dev` is env/stage name 
The script installs artillery locally, gets Layer 1 host and api key and passes it to artillery to run load testing
