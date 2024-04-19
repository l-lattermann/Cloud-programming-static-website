## Create string variable for storing AWS credentials profile name 
variable "profile" {
  description = "Profile name in aws credentials file. You can find the the profile name in your credentials file."
  type        = string
}

## Create string variable for storing AWS credentials path
variable "credential_path" {
  description = "Path to aws credential file. Usullay looks like this: /Users/{Username}/.aws/credentials.txt"
  type        = string
}

## Create string variable for storing enviroment name
variable "bucket_tag" {
  description = "Variable used to define environment"
  type        = string
}

## Create a unique identifier for the bucket name
resource "random_uuid" "uuid" {}


## Create string variable for storing AWS region code
variable "aws_region" {
  description = "AWS Region you want to use. For more information go to https://aws.amazon.com/de/about-aws/global-infrastructure/regions_az/"
  type        = string
  
  # Validate that the user input resembles AWS region code
  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.aws_region))
    error_message = "Must be valid AWS Region names. I.e.: eu-north-1"
  }
}


## Create string variable for storing bucket name user input
variable "bucket_name_user_input" {
  description = "The name of the S3 bucket. Only lowercase alphanumeric characters and hyphens are allowed."
  type = string

  # Valitdate that the user input is naming convention confirm
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.bucket_name_user_input))
    error_message = "validating S3 Bucket name: only lowercase alphanumeric characters and hyphens allowed"
  }
}

## Create string variable for storing bucket name coupled with uuid
variable "bucket_name" {
  description = "The name of the S3 bucket. Only lowercase alphanumeric characters and hyphens are allowed."
  type = string
}