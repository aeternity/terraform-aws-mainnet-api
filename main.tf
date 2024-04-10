### Stockholm nodes and load-balancer ###

module "nodes_api_main_stockholm" {
  source = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v3.3.0"
  env    = "api_main"

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  instance_type  = "c6i.xlarge"
  instance_types = ["c6i.xlarge", "c5d.xlarge", "c5.xlarge", "c7i.xlarge"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 24
  additional_storage      = true
  additional_storage_size = 500

  asg_target_groups = module.lb_main_stockholm.target_groups

  tags = {
    role  = "aenode"
    env   = "api_main"
    envid = "api_main"
  }

  config_tags = {
    bootstrap_version = var.bootstrap_version
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_config  = "secret2/aenode/config/api_main"
  }

  providers = {
    aws = aws.eu-north-1
  }
}

module "nodes_api_main_stockholm_channels" {
  source = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v3.3.0"
  env    = "api_main"

  static_nodes   = 1
  spot_nodes_min = 0
  spot_nodes_max = 0

  instance_type  = "t3.large"
  instance_types = ["t3.large", "c5.large", "m5.large"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 40
  additional_storage      = true
  additional_storage_size = 200

  asg_target_groups = module.lb_main_stockholm.target_groups_channels
  subnets           = module.nodes_api_main_stockholm.subnets
  vpc_id            = module.nodes_api_main_stockholm.vpc_id

  enable_state_channels = true

  tags = {
    role  = "aenode"
    kind  = "channel"
    env   = "api_main"
    envid = "api_main"
  }

  config_tags = {
    bootstrap_version = var.bootstrap_version
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_config  = "secret2/aenode/config/api_main_channel"
  }

  providers = {
    aws = aws.eu-north-1
  }
}

module "lb_main_stockholm" {
  source                    = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.4.0"
  env                       = "api_main"
  fqdn                      = var.lb_fqdn
  dns_zone                  = var.dns_zone
  security_group            = module.nodes_api_main_stockholm.sg_id
  vpc_id                    = module.nodes_api_main_stockholm.vpc_id
  subnets                   = module.nodes_api_main_stockholm.subnets
  dry_run_enabled           = true
  state_channel_api_enabled = true

  providers = {
    aws = aws.eu-north-1
  }
}

### Oregon nodes and load-balancer ###

module "nodes_api_main_oregon" {
  source = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v3.3.0"
  env    = "api_main"

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  instance_type  = "c5.xlarge"
  instance_types = ["c5.xlarge", "c5d.xlarge", "c7i.xlarge", "c6i.xlarge"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 24
  additional_storage      = true
  additional_storage_size = 500

  asg_target_groups = module.lb_main_oregon.target_groups

  tags = {
    role  = "aenode"
    env   = "api_main"
    envid = "api_main"
  }

  config_tags = {
    bootstrap_version = var.bootstrap_version
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_config  = "secret2/aenode/config/api_main"
  }

  providers = {
    aws = aws.us-west-2
  }
}

module "lb_main_oregon" {
  source          = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.4.0"
  env             = "api_main"
  fqdn            = var.lb_fqdn
  dns_zone        = var.dns_zone
  security_group  = module.nodes_api_main_oregon.sg_id
  vpc_id          = module.nodes_api_main_oregon.vpc_id
  subnets         = module.nodes_api_main_oregon.subnets
  dry_run_enabled = true

  providers = {
    aws = aws.us-west-2
  }
}

### Singapore nodes and load-balancer ###

module "nodes_api_main_singapore" {
  source = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v3.3.0"
  env    = "api_main"

  static_nodes   = 0
  spot_nodes_min = 2
  spot_nodes_max = 20

  instance_type  = "c6i.xlarge"
  instance_types = ["c6i.xlarge", "c5d.xlarge", "c5.xlarge"]
  ami_name       = "aeternity-ubuntu-22.04-v1709639419"

  root_volume_size        = 24
  additional_storage      = true
  additional_storage_size = 500

  asg_target_groups = module.lb_main_singapore.target_groups

  tags = {
    role  = "aenode"
    env   = "api_main"
    envid = "api_main"
  }

  config_tags = {
    bootstrap_version = var.bootstrap_version
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_config  = "secret2/aenode/config/api_main"
  }

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "lb_main_singapore" {
  source          = "github.com/aeternity/terraform-aws-api-loadbalancer?ref=v1.4.0"
  env             = "api_main"
  fqdn            = var.lb_fqdn
  dns_zone        = var.dns_zone
  security_group  = module.nodes_api_main_singapore.sg_id
  vpc_id          = module.nodes_api_main_singapore.vpc_id
  subnets         = module.nodes_api_main_singapore.subnets
  dry_run_enabled = true

  providers = {
    aws = aws.ap-southeast-1
  }
}

## CDN ##

module "gateway_main" {
  source          = "github.com/aeternity/terraform-aws-api-gateway?ref=v3.2.4"
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
