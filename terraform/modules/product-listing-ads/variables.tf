variable "crew" {
  type = string
  default = "buy"
}

variable "env" {
  default = "dev"
}

variable "lambda_functions_bucket_name" {
}
variable "lambda_functions_bucket_key" {
}

variable "log_retention_in_days" {
  default = 14
}