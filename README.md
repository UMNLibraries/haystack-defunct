# haystack

Find DPLA records with regular expressions.

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

```
$ cd haystack/ansible
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -i localhost haystack.yml
```
## TODO

* Copy /data/matched_records.json file down to local machine upon completion of ruby processes
* Add automatic EC2 instance tear-down when all ruby processes have completed
* Notify configurable email address when instance tear-down has completed
