provider "digitalocean" {
	token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "do_key" {
    name = "bootstrap ssh key"
    public_key = "${file("${var.do_pub_key_path}")}"
}

resource "digitalocean_droplet" "web" {
	image = "ubuntu-14-04-x64"
	name = "${var.domain_name}"
	region = "nyc2"
	size = "512mb"
	ssh_keys = [
		"${digitalocean_ssh_key.do_key.fingerprint}"
	]

	provisioner "local-exec" {
		command = "export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -i ${digitalocean_droplet.web.ipv4_address}, --extra-vars='target=${digitalocean_droplet.web.ipv4_address}' --private-key='${var.do_priv_key_path}' ansible/bootstrap.yml"
	}	
}

resource "digitalocean_domain" "default" {
	name = "${var.domain_name}"
	ip_address = "${digitalocean_droplet.web.ipv4_address}"
}
