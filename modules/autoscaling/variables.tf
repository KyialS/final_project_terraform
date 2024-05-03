variable "name_prefix" {
  default = "kyial-task8"  
}

variable "instance_type" {
    default = "t2.micro"
}

variable "desired_capacity" {
    default = 2
}

variable "max_size" {
    default = 3
}

variable "min_size" {
    default = 1
}

variable "public_subnets" {}

variable "sg" {}

variable "vpc_id" {}

variable "instances" {
  description = "List of instances for the ALB"
  type        = list(string)
  default     = []
}

variable "target_group_arn" {
  type    = string
  default = "your_target_group_arn_here"
}

variable "s3_bucket_endpoint" {
  description = "The endpoint of the S3 bucket"
}

