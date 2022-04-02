variable "project_id" {
    type = string
    default = "sab-dev-midtgds-5959"
}

variable "prefix" {
    type = string
    default = "dev"
}

variable "bucket_lists" {
    type = list(object({
        name  = string,
        storage_class = string,
        force_destroy = bool,
        uniform_bucket_level_access = bool
    }))  
    default = [{
        name = "midt-landing",
        storage_class = "STANDARD",
        force_destroy = true,
        uniform_bucket_level_access = true
    },
    {
        name = "midt-rejected",
        storage_class = "STANDARD",
        force_destroy = true,
        uniform_bucket_level_access = true
    }]
}

variable "location" {
  description = "Bucket location."
  type        = string
  default     = "us-central1"
}


variable "folders" {
  description = "Map of lowercase unprefixed name => list of top level folder objects."
  type        = map(list(string))
  default     = {
      "midt-landing" = ["sample"],
      "midt-rejected" = ["sample1","sample2"]
  }
}

variable "lifecycle_rules" {
    default = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age        = 7
      }
    }   
]
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