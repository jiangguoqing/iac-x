# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for mysql. The common variables for each environment to
# deploy mysql are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.

#terraform {
#  source = "${local.base_source_url}?ref=v0.7.0"
#}


# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//vpc"
}


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name              = "vpc_${local.env}"
  environment = "example"
  label_order = ["name", "environment"]

  vpc_enabled                               = true
  cidr_block                                = "10.0.0.0/16"
  enable_flow_log                           = false
  additional_cidr_block                     = ["172.3.0.0/16", "172.2.0.0/16"]
  enable_dhcp_options                       = false
  dhcp_options_domain_name                  = "service.consul"
  dhcp_options_domain_name_servers          = ["127.0.0.1", "10.10.0.2"]
  enabled_ipv6_egress_only_internet_gateway = false

  # TODO: To avoid storing your DB password in the code, set it as the environment variable TF_VAR_master_password
}
