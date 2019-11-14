variable "vault_addr" {
  description = "Vault server URL address"
}

variable "bootstrap_version" {
  default = "v2.8.0"
}

variable "package" {
  default = "https://releases.ops.aeternity.com/aeternity-5.0.2-ubuntu-x86_64.tar.gz"
}

variable "dns_zone" {
  default = "ZSEEAAX46MKWZ"
}

variable "lb_fqdn" {
  default = "lb.mainnet.aeternity.io"
}

variable "domain" {
  default = "mainnet.aeternity.io"
}

variable "domain_alias" {
  default = "sdk-mainnet.aepps.com"
}

variable "mdw_fqdn" {
  default = "mdw.aepps.com"
}
