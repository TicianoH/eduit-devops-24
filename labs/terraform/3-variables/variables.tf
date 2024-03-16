variable "allow_ip" {
  type = string
  default = "16.16.16.16/32"
}

variable "allow_ips" {
  type = list(string)
  default = ["16.16.16.16/32","15.15.15.15/32"]
}

