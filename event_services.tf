## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_events_rule" "BucketCreateObjectTrigger" {
  actions {
    actions {
      action_type = "FAAS"
      is_enabled  = true
      description = "BucketCreateObjectTriggerLoadFileIntoAdwFn"
      function_id = oci_functions_function.LoadFileIntoAdwFn.id
    }
  }
  compartment_id = var.compartment_ocid
  condition      = "{ \"eventType\": \"com.oraclecloud.objectstorage.createobject\" }"
  display_name   = "BucketCreateObjectTrigger"
  is_enabled     = true
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

