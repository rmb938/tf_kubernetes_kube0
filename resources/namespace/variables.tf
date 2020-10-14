variable "name" {
  type = string
}

variable "quota" {
  type = map
  default = {
    "requests.cpu"    = 2     # half of a pi4 b
    "requests.memory" = "1Gi" # half of a pi4 b
  }
}
