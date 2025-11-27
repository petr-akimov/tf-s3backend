output "static_access_key_id" {
  value = yandex_iam_service_account_static_access_key.static_key.access_key
}

output "static_access_key_secret" {
  value = yandex_iam_service_account_static_access_key.static_key.secret_key
}


output "bucket" {
  value       = yandex_storage_bucket.tfstate.bucket
  description = "Имя бакета для хранения terraform state"
}