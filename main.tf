### Stockholm nodes and load-balancer ###

module "nodes_api_main_stockholm" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v2.3.1"
  env               = "api_main"
  envid             = "api_main"
  bootstrap_version = var.bootstrap_version
  vault_role        = "ae-node"
  vault_addr        = var.vault_addr

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  spot_price    = "0.10"
  instance_type = "c5.xlarge"
  ami_name      = "aeternity-ubuntu-16.04-v1549009934"

  additional_storage      = true
  additional_storage_size = 200
  snapshot_filename       = "mnesia_main_v-1_latest.tgz"

  asg_target_groups = "${module.lb_main_stockholm.target_groups}"

  aeternity = {
    package = "${var.package}"
  }

  providers = {
    aws = "aws.eu-north-1"
  }
}

module "lb_main_stockholm" {
  source          = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.3.1"
  env             = "api_main"
  fqdn            = var.lb_fqdn
  dns_zone        = var.dns_zone
  security_group  = module.nodes_api_main_stockholm.sg_id
  vpc_id          = module.nodes_api_main_stockholm.vpc_id
  subnets         = module.nodes_api_main_stockholm.subnets
  dry_run_enabled = true
  providers = {
    aws = "aws.eu-north-1"
  }
}

### Oregon nodes and load-balancer ###

module "nodes_api_main_oregon" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v2.3.1"
  env               = "api_main"
  envid             = "api_main"
  bootstrap_version = var.bootstrap_version
  vault_role        = "ae-node"
  vault_addr        = var.vault_addr

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  spot_price    = "0.10"
  instance_type = "c5.xlarge"
  ami_name      = "aeternity-ubuntu-16.04-v1549009934"

  additional_storage      = true
  additional_storage_size = 200
  snapshot_filename       = "mnesia_main_v-1_latest.tgz"

  asg_target_groups = module.lb_main_oregon.target_groups

  aeternity = {
    package = var.package
  }

  providers = {
    aws = "aws.us-west-2"
  }
}

module "lb_main_oregon" {
  source          = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.2.0"
  env             = "api_main"
  fqdn            = var.lb_fqdn
  dns_zone        = var.dns_zone
  security_group  = module.nodes_api_main_oregon.sg_id
  vpc_id          = module.nodes_api_main_oregon.vpc_id
  subnets         = module.nodes_api_main_oregon.subnets
  dry_run_enabled = true

  providers = {
    aws = "aws.us-west-2"
  }
}

### Singapore nodes and load-balancer ###

module "nodes_api_main_singapore" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v2.3.1"
  env               = "api_main"
  envid             = "api_main"
  bootstrap_version = var.bootstrap_version
  vault_role        = "ae-node"
  vault_addr        = var.vault_addr

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  spot_price    = "0.10"
  instance_type = "c5.xlarge"
  ami_name      = "aeternity-ubuntu-16.04-v1549009934"

  additional_storage      = true
  additional_storage_size = 200
  snapshot_filename       = "mnesia_main_v-1_latest.tgz"

  asg_target_groups = module.lb_main_singapore.target_groups

  aeternity = {
    package = var.package
  }

  providers = {
    aws = "aws.ap-southeast-1"
  }
}

module "lb_main_singapore" {
  source          = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.2.0"
  env             = "api_main"
  fqdn            = var.lb_fqdn
  dns_zone        = var.dns_zone
  security_group  = module.nodes_api_main_singapore.sg_id
  vpc_id          = module.nodes_api_main_singapore.vpc_id
  subnets         = module.nodes_api_main_singapore.subnets
  dry_run_enabled = true

  providers = {
    aws = "aws.ap-southeast-1"
  }
}

## CDN ##

module "gateway_main" {
  source          = "github.com/aeternity/terraform-aws-api-gateway?ref=v3.2.2"
  env             = "api_main"
  dns_zone        = var.dns_zone
  api_domain      = var.domain
  api_aliases     = var.domain_aliases
  certificate_arn = var.certificate_arn
  lb_fqdn         = var.lb_fqdn
  mdw_fqdn        = var.mdw_fqdn
  ae_mdw_fqdn     = var.ae_mdw_fqdn
  ch_fqdn         = module.lb_main_stockholm.dns_name
  headers         = var.headers

  api_cache_default_ttl = 1
  mdw_cache_default_ttl = 3
}
