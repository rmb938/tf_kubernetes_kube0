variable "name" {
  type = string
}

variable "quota" {
  type = map
  default = {
    "limits.cpu"      = 4        # number of cores in a pi4 b
    "limits.memory"   = "3.7Gi"  # amount of memory in a pi4 b
    "requests.cpu"    = 2        # half of a pi4 b
    "requests.memory" = "1.85Gi" # half of a pi4 b
  }
}
