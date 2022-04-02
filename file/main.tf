module "gcs_bucket" {
  source = "../"
  project_id  = var.project_id
  prefix = var.prefix
  bucket_lists = var.bucket_lists
  lifecycle_rules = var.lifecycle_rules
  #iam_members = var.iam_members
  location = var.location 
  folders = var.folders
}
