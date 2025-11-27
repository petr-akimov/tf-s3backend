output "static_access_key_id" {
  value       = yandex_iam_service_account_static_access_key.static_key.id
  description = "Access key id (используется для S3 backend и provider)"
}

output "static_access_key_secret" {
  value       = yandex_iam_service_account_static_access_key.static_key.secret
  description = "Секрет ключа (чувствительный)"
  sensitive   = true
}

output "bucket" {
  value       = yandex_storage_bucket.tfstate.bucket
  description = "Имя бакета для хранения terraform state"
}