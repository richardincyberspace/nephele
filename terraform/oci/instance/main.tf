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

resource "oci_core_instance" "public" {
  availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = var.type

  agent_config {
    is_management_disabled = "false"
  }

  create_vnic_details {
    assign_public_ip  = var.public
    defined_tags      = tomap(var.custom_tags)
    subnet_id         = var.subnet
    #subnet_id        = oci_core_subnet.public.id
  }

  defined_tags        = tomap(var.custom_tags)
  display_name        = "${var.cluster_id}-login"
  #display_name           = "${local.cluster_id}-login"

  metadata            = {
    ssh_authorized_keys = file(var.ssh.pubkey)
    #ssh_authorized_keys = file(var.ssh_public_key)
  }

  source_details {
    source_id   = var.os_image
    source_type = "image"
  }
}

## Instance Configuration (compute)
resource "oci_core_instance_configuration" "compute" {
  compartment_id = var.compartment_ocid

  defined_tags   = tomap(var.custom_tags)
  display_name   = "${var.cluster_id}-compute-instance-config"
  #display_name   = "${local.cluster_id}-compute-instance-config"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.compartment_ocid

      create_vnic_details {
        assign_public_ip       = "false"
        defined_tags           = tomap(var.custom_tags)
        display_name           = "${var.cluster_id}-instance-config-vnic"
        skip_source_dest_check = "false"
      }

      defined_tags   = tomap(var.custom_tags)

      metadata       = {
        ssh_authorized_keys = file(var.ssh.pubkey)
      }

      shape          = var.type

      source_details {
        source_type = "image"
        image_id    = var.os_image
      }
    }
  }
}

resource "oci_core_instance_pool" "default" {
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.compute.id
  placement_configurations {
    availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
    primary_subnet_id   = var.subnet
  }

  size                      = var.replicas

  defined_tags              = tomap(var.custom_tags)

  display_name              = "${var.cluster_id}-instance-pool"
}