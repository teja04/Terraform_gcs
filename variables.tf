variable "project_id" {
    type = string
}

variable "prefix" {
    type = string
}

variable "bucket_lists" {
    type = list(object({
        name  = string,
        storage_class = string,
        force_destroy = bool,
        uniform_bucket_level_access = bool
    }))  
}

variable "location" {
  description = "Bucket location."
  type        = string
}



variable "folders" {
  description = "Map of lowercase unprefixed name => list of top level folder objects."
  type        = map(list(string))
  default     = {}
}

variable "lifecycle_rules" {
    default = []
}
/*
variable "iam_members" {
  description = "The list of IAM members to grant permissions on the bucket."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}
*/