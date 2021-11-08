## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "adw_password" {}
variable "ocir_user_name" {}
variable "ocir_user_password" {}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "oci-arch-load-file-into-adw-python" {
  source             = "github.com/oracle-devrel/terraform-oci-arch-load-file-into-adw-python"
  tenancy_ocid       = var.tenancy_ocid
  user_ocid          = var.user_ocid
  fingerprint        = var.fingerprint
  private_key_path   = var.private_key_path
  region             = var.region
  compartment_ocid   = var.compartment_ocid
  dbpwd-cipher       = var.adw_password
  ocir_user_name     = var.ocir_user_name
  ocir_user_password = var.ocir_user_password
  use_existing_vcn   = false
}

output "ADW_query_URL_for_JSON_formatted_with_python" {
  value = module.oci-arch-load-file-into-adw-python.ADW_query_URL_for_JSON_formatted_with_python
}

output "ADWdatabase_connection_urls" {
  value = module.oci-arch-load-file-into-adw-python.ADWdatabase_connection_urls
}
