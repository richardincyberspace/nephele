# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "oci_core_vcn" "default" {
  compartment_id = var.compartment_ocid

  cidr_block     = var.vcn_cidr
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-vcn"
}

resource "oci_core_subnet" "public" {
  cidr_block          = var.subnet_cidr.public
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.default.id

  availability_domain = lookup(data.oci_identity_availability_domains.default.availability_domains[0], "name")
  defined_tags        = tomap(var.custom_tags)
  display_name        = "${local.cluster_id}-public-subnet"
  route_table_id      = oci_core_route_table.public.id
  security_list_ids   = [oci_core_security_list.public_security_list_id.id]
}

resource "oci_core_subnet" "private" {
  cidr_block          = var.subnet_cidr.private
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.default.id

  availability_domain = lookup(data.oci_identity_availability_domains.default.availability_domains[0], "name")
  defined_tags        = tomap(var.custom_tags)
  display_name        = "${local.cluster_id}-private-subnet"
  route_table_id      = oci_core_route_table.private.id
  security_list_ids   = [oci_core_security_list.private_security_list_id.id]
}

resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-gateway"
  enabled        = "true"
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-public-route"
  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id

    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_nat_gateway" "default" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  block_traffic  = "false"
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-nat"
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-private-route"
  route_rules {
    network_entity_id = oci_core_nat_gateway.default.id

    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}
