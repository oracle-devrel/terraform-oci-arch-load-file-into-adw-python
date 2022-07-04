## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "ADW_query_URL_for_JSON_formatted_with_python" {
  value = "curl -X POST -u 'ADMIN:${var.ADW_database_password}' -H \"Content-Type: application/json\"  --data '{}' https://${substr(module.oci-adb.adb_database.connection_urls[0].apex_url, 8, 22)}.adb.${var.region}.oraclecloudapps.com/ords/admin/soda/latest/regionsnumbers?action=query | python -m json.tool"
}

output "ADWdatabase_connection_urls" {
  value = module.oci-adb.adb_database.connection_urls
}

