# Server Template

This repo serves as an example of how to launch a DigitalOcean droplet, setup DNS, and create a deploy user with a single command using Terraform and Ansible.


## Requirements

* [Terraform](http://terraform.io)
* [Ansible](http://ansible.com)
* passlib for Python. Install with
	`sudo pip install passlib`

You will also need:

* A DigitalOcean API key
* A public/private key combo for bootstrapping new droplets
* A public/private key combo for deploying configurations to droplets
* A registered domain with nameservers pointed at ns1.digitalocean.com, ns2.digitalocean.com, ns3.digitalocean.com


### Ansible vars

Currently the Ansible variable file located at `ansible/vars/secrets.yml` requires a hashed password and a path to the deployment SSH public key. To generate the password hash run the genpass.sh script in the project root and copy the generated hash into `ansible/vars/secrets.yml`


### Terraform vars

The Terraform variable file includes four fields. These fields can be filled on the command line:

```
$ terraform apply \
	-var 'do_token=TOKEN' \
	-var 'do_pub_key_path=PATH' \
	-var 'do_priv_key_path=PATH' \
	-var 'domain_name=DOMAIN_NAME'
```

or by specifying default values in the variable file:

```
variable "do_token" {
	default = "TOKEN"
}
```

And execute commands with the -input=False option: `terraform apply -input=False`


## Connecting to the droplet

Once `terraform apply` finishes you can connect to the droplet via SSH with: 
`ssh -i PATH_TO_KEY deploy@DOMAIN_NAME`
