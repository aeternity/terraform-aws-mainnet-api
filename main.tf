############### LEGACY SETUP ################
module "aws_deploy-main-us-west-2" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v1.2.0"
  env               = "api_main"
  bootstrap_version = "${var.bootstrap_version}"
  vault_role        = "ae-node"
  vault_addr        = "${var.vault_addr}"

  static_nodes      = 0
  spot_nodes        = 0
  gateway_nodes_min = 2
  gateway_nodes_max = 30
  dns_zone          = "${var.old_dns_zone}"
  gateway_dns       = "origin-${var.old_domain}"
  spot_price        = "0.15"
  instance_type     = "t3.large"
  ami_name          = "aeternity-ubuntu-16.04-v1549009934"
  root_volume_size  = 40

  additional_storage      = 1
  additional_storage_size = 30

  aeternity = {
    package = "${var.old_package}"
  }

  providers = {
    aws = "aws.us-west-2"
  }
}

module "aws_deploy-main-eu-north-1" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v1.2.0"
  env               = "api_main"
  bootstrap_version = "${var.bootstrap_version}"
  vault_role        = "ae-node"
  vault_addr        = "${var.vault_addr}"

  static_nodes      = 0
  spot_nodes        = 0
  gateway_nodes_min = 2
  gateway_nodes_max = 30
  dns_zone          = "${var.old_dns_zone}"
  gateway_dns       = "origin-${var.old_domain}"

  spot_price       = "0.15"
  instance_type    = "t3.large"
  ami_name         = "aeternity-ubuntu-16.04-v1549009934"
  root_volume_size = 40

  additional_storage      = 1
  additional_storage_size = 30

  aeternity = {
    package = "${var.old_package}"
  }

  providers = {
    aws = "aws.eu-north-1"
  }
}

module "aws_gateway" {
  source    = "github.com/aeternity/terraform-aws-api-gateway?ref=v1.0.0"
  dns_zone  = "${var.old_dns_zone}"
  api_dns   = "${var.old_domain}"
  api_alias = "${var.domain_alias}"

  loadbalancers = [
    "${module.aws_deploy-main-us-west-2.gateway_lb_dns}",
    "${module.aws_deploy-main-eu-north-1.gateway_lb_dns}",
  ]

  loadbalancers_zones = [
    "${module.aws_deploy-main-us-west-2.gateway_lb_zone_id}",
    "${module.aws_deploy-main-eu-north-1.gateway_lb_zone_id}",
  ]

  loadbalancers_regions = [
    "us-west-2",
    "eu-north-1",
  ]
}

############### END OF LEGACY SETUP ################

### Stockholm nodes and load-balancer ###

module "nodes_api_main_stockholm" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v2.1.0"
  env               = "api_main"
  envid             = "api_main"
  bootstrap_version = "${var.bootstrap_version}"
  vault_role        = "ae-node"
  vault_addr        = "${var.vault_addr}"

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  spot_price    = "0.06"
  instance_type = "t3.large"
  ami_name      = "aeternity-ubuntu-16.04-v1549009934"

  additional_storage      = true
  additional_storage_size = 30
  snapshot_filename       = "mnesia_main_v-1_latest.gz"

  asg_target_groups = "${module.lb_main_stockholm.target_groups}"

  aeternity = {
    package = "${var.package}"
  }

  providers = {
    aws = "aws.eu-north-1"
  }
}

module "lb_main_stockholm" {
  source                    = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.0.0"
  fqdn                      = "${var.lb_fqdn}"
  dns_zone                  = "${var.dns_zone}"
  security_group            = "${module.nodes_api_main_stockholm.sg_id}"
  vpc_id                    = "${module.nodes_api_main_stockholm.vpc_id}"
  subnets                   = "${module.nodes_api_main_stockholm.subnets}"

  providers = {
    aws = "aws.eu-north-1"
  }
}

### Oregon nodes and load-balancer ###

module "nodes_api_main_oregon" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v2.1.0"
  env               = "api_main"
  envid             = "api_main"
  bootstrap_version = "${var.bootstrap_version}"
  vault_role        = "ae-node"
  vault_addr        = "${var.vault_addr}"

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  spot_price    = "0.06"
  instance_type = "t3.large"
  ami_name      = "aeternity-ubuntu-16.04-v1549009934"

  additional_storage      = true
  additional_storage_size = 30
  snapshot_filename       = "mnesia_main_v-1_latest.gz"

  asg_target_groups = "${module.lb_main_oregon.target_groups}"

  aeternity = {
    package = "${var.package}"
  }

  providers = {
    aws = "aws.us-west-2"
  }
}

module "lb_main_oregon" {
  source                    = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.0.0"
  fqdn                      = "${var.lb_fqdn}"
  dns_zone                  = "${var.dns_zone}"
  security_group            = "${module.nodes_api_main_oregon.sg_id}"
  vpc_id                    = "${module.nodes_api_main_oregon.vpc_id}"
  subnets                   = "${module.nodes_api_main_oregon.subnets}"

  providers = {
    aws = "aws.us-west-2"
  }
}

## CDN ##

module "gateway_main" {
  source          = "github.com/aeternity/terraform-aws-api-gateway?ref=v3.0.1"
  env             = "api_main"
  dns_zone        = var.dns_zone
  api_domain      = var.domain
  # More than one distribution cannot hold the same CNAME, needs a manual swap
  # api_aliases     = [var.domain_alias]
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
  lb_fqdn         = var.lb_fqdn
}
