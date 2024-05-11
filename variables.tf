# Name of the Azure Resource Group
variable "rgname" {
  type        = string                # Type of the variable
  description = "resource group name" # Description of the variable
}

# Location where Azure resources will be deployed
variable "location" {
  type    = string    # Type of the variable
  default = "westus3" # Default value for the variable
}


variable "acr" {
  type = string
  description = "cluster name" # Description of the variable

}


variable "aks-cluster" {
    type = string
    description = "azure kubernetes cluster"
}
