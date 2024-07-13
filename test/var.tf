variable "complex" {
    type = any
    default = {
        "vpc1" = {
            cidr = "10.16.0.0/16"
            tags = {
                envir = "prod"
            }
        }
    }
}

variable "map" {
  type = map(string)
  default = {
    "vpc1" = "10.15.0.0/16"
    "vpc2" = "10.16.0.0/16"
  }
}


variable "is_multi_az" {
  type = bool
  default = false
}