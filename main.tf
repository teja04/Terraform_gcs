locals {
  prefix       = var.prefix == "" ? "" : join("-", [var.prefix, ""])
  #suffix       = var.randomize_suffix ? "-${random_id.bucket_suffix.hex}" : ""
  bucket_lists = {for bucket_list in var.bucket_lists : bucket_list["name"] => bucket_list}
  folder_list = flatten([
    for bucket, folders in var.folders : [
      for folder in folders : {
        bucket = bucket,
        folder = folder
      }
    ]
  ])
}

resource "google_storage_bucket" "buckets" {
  for_each = local.bucket_lists

  name          = "${local.prefix}${lower(each.value["name"])}"
  project       = var.project_id
  location      = var.location
  storage_class = each.value["storage_class"]
  force_destroy = each.value["force_destroy"]
  uniform_bucket_level_access = each.value["uniform_bucket_level_access"]
  

  dynamic "lifecycle_rule" {
    for_each = [for rule in var.lifecycle_rules : {
      action_type          = rule.action.type
      action_storage_class = lookup(rule.action, "storage_class", null)

      condition_age                   = lookup(rule.condition, "age", null)
      condition_created_before        = lookup(rule.condition, "created_before", null)
      condition_with_state            = lookup(rule.condition, "with_state", null)
      condition_matches_storage_class = lookup(rule.condition, "matches_storage_class", null)
      condition_num_newer_versions    = lookup(rule.condition, "num_newer_versions", null)
    }]
    content {
      action {
        type          = lifecycle_rule.value.action_type
        storage_class = lifecycle_rule.value.action_storage_class
      }
      condition {
        age                   = lifecycle_rule.value.condition_age
        created_before        = lifecycle_rule.value.condition_created_before
        with_state            = lifecycle_rule.value.condition_with_state
        matches_storage_class = lifecycle_rule.value.condition_matches_storage_class
        num_newer_versions    = lifecycle_rule.value.condition_num_newer_versions
      }
    }
  }
}
/*
resource "google_storage_bucket_iam_member" "members" {
  for_each = {
    for m in var.iam_members : "${m.role} ${m.member}" => m
  }
  bucket = google_storage_bucket.buckets[each.key].name
  role   = each.value.role
  member = each.value.member
}
*/
resource "google_storage_bucket_object" "folders" {
  for_each = { for obj in local.folder_list : "${obj.bucket}_${obj.folder}" => obj }
  bucket   = google_storage_bucket.buckets[each.value.bucket].name
  name     = "${each.value.folder}/" # Declaring an object with a trailing '/' creates a directory
  source   =  "${each.value.source}"                 
}

provisioner "files" {
    command = "gsutil cp -r ${var.folder_path} gs://${var.gcs_bucket}/"
}