variable "vault_addr" {
  description = "Vault server URL address"
}

variable "bootstrap_version" {
  default = "v2.6.4"
}

variable "package" {
  default = "https://releases.ops.aeternity.com/aeternity-4.0.0-ubuntu-x86_64.tar.gz"
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

variable "old_dns_zone" {
  default = "Z2J3KVPABDNIL1"
}

variable "old_domain" {
  default = "api.mainnet.ops.aeternity.com"
}

variable "old_package" {
  default = "https://releases.ops.aeternity.com/aeternity-3.0.1-ubuntu-x86_64.tar.gz"
}
