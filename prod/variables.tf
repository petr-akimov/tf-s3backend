variable "project_prefix" {
  type    = string
  default = "tf-s3backend"
}

variable "ssh_public_key" {
  type = string
  description = "Публичный SSH ключ для доступа к VM (TF_VAR_ssh_public_key)"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "access_key" {
  type = string
  description = "Access key id (TF_VAR_access_key) — выдаётся bootstrap'ом"
}

variable "secret_key" {
  type = string
  description = "Secret key (TF_VAR_secret_key) — выдаётся bootstrap'ом"
}

variable "cloud_id" {
  type = string
  description = "YC cloud id"
}

variable "folder_id" {
  type = string
  description = "YC folder id"
}