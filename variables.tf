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
  type = map(object({ arn = string }))
  default = {}
}
