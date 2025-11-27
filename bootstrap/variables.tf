variable "project_prefix" {
  type    = string
  default = "tf-s3backend"
}

variable "oauth_token" {
  type    = string
  description = "OAuth token (передаётся через TF_VAR_oauth_token)"
  default = ""
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud id (передаётся через TF_VAR_cloud_id)"
}

variable "folder_id" {
  type        = string
  description = "Yandex Folder id (передаётся через TF_VAR_folder_id)"
}