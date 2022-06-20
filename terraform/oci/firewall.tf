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

resource "oci_core_security_list" "default" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  ingress_security_rules {
    description = " Allow inbound SSH traffic"
    protocol    = "6"
    source      = "0.0.0.0/0"
    tcp_options {
      min = "22"
      max = "22"
    }
  }

  ingress_security_rules {
    description = "Allow inbound traffic within VCN"
    protocol    = "all"
    source      = oci_core_vcn.default.cidr_block
    #source      = "0.0.0.0/0"
  }

  egress_security_rules {
    description = "Allow outbound traffic"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}