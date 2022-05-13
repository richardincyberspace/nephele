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

data "oci_core_instance_pool_instances" "instance_pool_instances" {
  compartment_id = var.compartment_ocid
  instance_pool_id = oci_core_instance_pool.default.id

  depends_on = [
    oci_core_instance_pool.default,
  ]
}

data "oci_core_instance" "instance_pool_ips" {
  count = var.replicas
  instance_id = data.oci_core_instance_pool_instances.instance_pool_instances.instances[count.index].id
}

output "public_ips" {
  depends_on = [
    data.oci_core_instance_pool_instances.instance_pool_instances,
  ]
  value = var.replicas > 0 ? join(",", data.oci_core_instance.instance_pool_ips.*.public_ip): ""
}

output "private_ips" {
  depends_on = [
    data.oci_core_instance_pool_instances.instance_pool_instances,
  ]
  value = var.replicas > 0 ? join(",", data.oci_core_instance.instance_pool_ips.*.private_ip): ""
}
