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


resource "yandex_storage_bucket_grant" "tfstate_sa_grant" {
  bucket = yandex_storage_bucket.tfstate.bucket

  grant {
    type        = "CanonicalUser"
    id          = yandex_iam_service_account.tf_sa.id
    permissions = ["FULL_CONTROL"]
  }
}

# Добавьте в bootstrap/main.tf
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.tf_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.tf_sa.id}"
}