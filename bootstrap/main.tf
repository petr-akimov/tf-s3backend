terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "yandex" {
  token     = var.oauth_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "tf_sa" {
  name        = "${var.project_prefix}-tf-sa"
  description = "Service account for Terraform (tfstate & infra)"
}

# Bind storage.admin to the service account at cloud level (member - safer)
resource "yandex_resourcemanager_cloud_iam_member" "sa_storage" {
  cloud_id = var.cloud_id
  role     = "roles/storage.admin"
  member   = "serviceAccount:${yandex_iam_service_account.tf_sa.id}"
}


# Create static access key for Object Storage
resource "yandex_iam_service_account_static_access_key" "static_key" {
  service_account_id = yandex_iam_service_account.tf_sa.id
  description        = "static key for object storage (tfstate)"
}

# Random suffix for bucket uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create bucket for tfstate
resource "yandex_storage_bucket" "tfstate" {
  bucket    = "${var.project_prefix}-tfstate-${random_id.bucket_suffix.hex}"
  folder_id = var.folder_id
}

resource "yandex_storage_bucket_grant" "tfstate_owner" {
  bucket = yandex_storage_bucket.tfstate.bucket

  grant {
    id          = yandex_iam_service_account.tf_sa.id
    type        = "serviceAccount"
    permissions = ["FULL_CONTROL"]
  }
}