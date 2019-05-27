variable "vault_addr" {
  description = "Vault server URL address"
}

variable "bootstrap_version" {
  default = "v2.2.0"
}

variable "package" {
  default = "https://releases.ops.aeternity.com/aeternity-3.0.1-ubuntu-x86_64.tar.gz"
}

variable "dns_zone" {
  default = "Z2J3KVPABDNIL1"
}

variable "domain" {
  default = "api.mainnet.ops.aeternity.com"
}

variable "domain_alias" {
  default = "sdk-mainnet.aepps.com"
}
