#############################
## Define module variables ##
#############################

# Notice how Terraform will request to input this variable on plan creation
variable "tag_project" {
  description = "The resources Project tag"
  type        = string
}

# Notice how we have defined a default value
variable "tag_environment" {
  description = "The resources Environment tag"
  type        = string
  default     = "development"
}
