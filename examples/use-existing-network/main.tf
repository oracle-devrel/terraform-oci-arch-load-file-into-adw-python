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

resource "oci_core_vcn" "my_vcn" {
  cidr_block     = "192.168.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "my_vcn"
  dns_label      = "myvcn"
}

resource "oci_core_internet_gateway" "my_igw" {
  compartment_id = var.compartment_ocid
  display_name   = "my_igw"
  vcn_id         = oci_core_vcn.my_vcn.id
}

resource "oci_core_route_table" "my_rt_via_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "my_rt_via_igw"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.my_igw.id
  }
}

resource "oci_core_subnet" "my_public_subnet" {
  cidr_block                 = "192.168.1.0/24"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.my_vcn.id
  display_name               = "my_public_subnet"
  dns_label                  = "mynet1"
  security_list_ids          = [oci_core_vcn.my_vcn.default_security_list_id]
  route_table_id             = oci_core_route_table.my_rt_via_igw.id
  prohibit_public_ip_on_vnic = false
}

module "oci-arch-load-file-into-adw-python" {
  source                = "github.com/oracle-devrel/terraform-oci-arch-load-file-into-adw-python"
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.fingerprint
  private_key_path      = var.private_key_path
  region                = var.region
  compartment_ocid      = var.compartment_ocid
  ADW_database_password = var.adw_password
  ocir_user_name        = var.ocir_user_name
  ocir_user_password    = var.ocir_user_password
  use_existing_vcn      = true
  vcn_id                = oci_core_vcn.my_vcn.id              # Injected VCN
  fnsubnet_id           = oci_core_subnet.my_public_subnet.id # Injected Public Subnet
}

output "ADW_query_URL_for_JSON_formatted_with_python" {
  value = module.oci-arch-load-file-into-adw-python.ADW_query_URL_for_JSON_formatted_with_python
}

output "ADWdatabase_connection_urls" {
  value = module.oci-arch-load-file-into-adw-python.ADWdatabase_connection_urls
}

