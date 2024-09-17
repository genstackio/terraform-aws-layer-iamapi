variable "name" {
  type = string
}
variable "dns" {
  type = string
}
variable "dns_zone" {
  type = string
}
variable "clients" {
  type = list(object({
    name = string
    flows = list(string)
  }))
  default = []
}
variable "lambdas" {
  type = map(object({ arn = string, version = optional(string) }))
  default = {}
}
variable "attributes" {
  type = map(object({
    type = string
    mutable = bool
    required = bool
  }))
  default = {}
}
variable "advanced_security_mode" {
  type    = string
  default = "OFF"
}
