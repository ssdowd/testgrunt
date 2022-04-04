# dev/terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:ssdowd/tf-mod-az-vnet-lb-example.git//modules/services/stack?ref=v0.0.2"
}

# Indicate the input values to use for the variables of the module.
inputs = {
  stack_name           = "gruntdev"
  location             = "centralus"
  instance_count       = 1
  admin_ssh_public_key = file("~/.ssh/id_rsa.pub")
  custom_data          = base64encode(templatefile("web.tftpl", { stackname = "gruntdev" }))
  allow_cidr           = "68.206.65.233/32"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
