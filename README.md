# haystack

A configurable Ansible playbook and ruby script to split a [DPLA data dump](https://dp.la/info/developers/download/) into chunks and then find matches to a set of regular expressions.

## What this thing does

* Launches an EC2 Instance and EBS volume (configurable in haystack.yml)
* Allocates plenty of disk space to hold our data (configurable in haystack.yml)
* Installs the core dependencies (Ruby, gems, etc)
* Downloads a DPLA data dump (configurable in haystack.yml)
* Splits this DPLA JSON file into chunks (chunk size configurable in haystack.yml)
* Runs the ruby script that finds matches on each chunk based on a provided URL to a JSON file regex patterns (see provided example in haystack.yml for formatting)
* Each script writes to a single file of matched records

## EC2 Setup

* Work through the EC2 [Getting Started](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) guide so that you are able to deploy an EC2 instance from your web browser and connect to it via ssh.
* Create a security group with the following rules and name it "haystack"

_Inbound_

| Type | Protocol | Port Range | Source    |
|------|----------|------------|-----------|
| SSH  | TCP      | 22         | 0.0.0.0/0 |

_Outbound_

| Type | Protocol | Port Range | Source    |
|------|----------|------------|-----------|
| HTTP  | TCP      | 80         | 0.0.0.0/0 |
| HTTPS  | TCP      | 443         | 0.0.0.0/0 |
| SSH  | TCP      | 22         | 0.0.0.0/0 |
| Custom TCP Rule  | TCP      | 11371        | 0.0.0.0/0 |

* Create an IAM user and attach the "AmazonEC2FullAccess" security policy to it (you can dial back the permissions as you see fit).
* Install the [AWS CLI tools](https://aws.amazon.com/cli/)
* Install [boto 2.x](http://boto.cloudhackers.com/en/latest/getting_started.html)
* As a convenience, add your AWS IAM user's pem to ssh:

`ssh-add ~/.ssh/my-key.pem`

## Configuration

* Configuration for haystack resides in the haystack ansible file: haystack/ansible/haystack.yml.
Note: You'll probably want to run this script on a fairly large instance with many vCPUs, such as the m4.10xlarge (consult pricing first)
* You will need a list of regular expressions serialized in JSON in the format shown [here]("http://hub-client.lib.umn.edu/lookups/13.json")
** (each expression is later joined with a pipe as boolean OR clauses)
Note: Of special importance are the variables "vars" sections of each ansible play. Adjust these to your own needs.


## Run Haystack

The provision process happens in two phases:

1) provision the machine

```
$ export HAYSTACK_AWS_ACCESS_KEY_ID=youridhere
$ export HAYSTACK_AWS_SECRET_ACCESS_KEY=yourkeyhere
$ cd haystack/ansible
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -i localhost haystack-provision.yml --with-variables HAYSTACK_AWS_ACCESS_KEY_ID=${HAYSTACK_AWS_ACCESS_KEY_ID} HAYSTACK_AWS_SECRET_ACCESS_KEY=${HAYSTACK_AWS_SECRET_ACCESS_KEY}
```

2) Run haystack

a) Find the URI to the EC2 instance that you just launched (available in the AWS EC2 console and via the CLI tool). Place that URI in the `inventory` file under `[ETL_HOSTS]` like:

```
[etl_hosts]
21323423423blah.compute.aws.com
```
b) Run the haystack playbook
```
 ANSIBLE_HOST_KEY_CHECKING=False; private_key_file=~/.ssh/yourkeyhere.pem ansible-playbook -v -i inventory haystack.yml -v -c paramiko
 ```
