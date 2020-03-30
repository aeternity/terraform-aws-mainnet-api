variable "vault_addr" {
  description = "Vault server URL address"
}

variable "bootstrap_version" {
  default = "v2.9.2"
}

variable "package" {
  default = "https://releases.aeternity.io/aeternity-5.5.0-ubuntu-x86_64.tar.gz"
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

variable "domain_aliases" {
  type    = "list"
  default = ["sdk-mainnet.aepps.com", "mdw.aepps.com"]
}

variable "mdw_fqdn" {
  default = "mainnet.aeternal.io"
}

variable "certificate_arn" {
  default = "arn:aws:acm:us-east-1:106102538874:certificate/fd311c12-9e1c-4e98-bc7a-d8f2f80c7247"
}

variable "headers" {
  default = ["Accept-Encoding", "Origin"]
}
