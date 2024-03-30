variable "names" {
  type    = list(string)
  default = ["user1", "user2", "user3"]
}

variable "names_obj" {
  type = map(any)
  default = {
    "user1" = "Jose"
    "user2" = "Juan"
  }
}

variable "instance_type" {
}

variable "environment" {
  type    = string
  default = "development"
}
