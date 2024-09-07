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
  type = list(string)
  default = []
}
