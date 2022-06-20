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
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-vcn"
}

data "oci_identity_availability_domains" "default" {
  compartment_id = var.compartment_ocid
}

# Public network (public subnet, ig, rt)
resource "oci_core_subnet" "public" {
  availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
  cidr_block          = var.subnet_cidr.public
  compartment_id      = var.compartment_ocid
  defined_tags        = tomap(var.custom_tags)
  display_name        = "${local.cluster_id}-public-subnet"
  route_table_id      = oci_core_route_table.public.id
  security_list_ids   = [oci_core_security_list.default.id]
  vcn_id              = oci_core_vcn.default.id 
}

resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-ig-gateway"
  enabled        = "true"
  vcn_id         = oci_core_vcn.default.id
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-public-route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.default.id
  }
  vcn_id         = oci_core_vcn.default.id
}

# Private network (private subnet, ng, rt)
resource "oci_core_subnet" "private" {
  availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
  cidr_block          = var.subnet_cidr.private
  compartment_id      = var.compartment_ocid
  defined_tags        = tomap(var.custom_tags)
  display_name        = "${local.cluster_id}-private-subnet"
  route_table_id      = oci_core_route_table.private.id
  security_list_ids   = [oci_core_security_list.default.id]
  vcn_id              = oci_core_vcn.default.id
}

resource "oci_core_nat_gateway" "default" {
  block_traffic  = "false"
  compartment_id = var.compartment_ocid
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-nat-gateway"
  vcn_id         = oci_core_vcn.default.id
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_ocid
  defined_tags   = tomap(var.custom_tags)
  display_name   = "${local.cluster_id}-private-route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.default.id
  }
  vcn_id         = oci_core_vcn.default.id
}
