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

module "instances_login" {
  source      = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-login"
  type        = "BM.HPC2.36"
  replicas    = 1
  public      = true
  preemptible = false

  os_image    = var.ubuntu_2004[var.region]
  subnet      = oci_core_subnet.public.id
}

module "instance_x8v100" {
  source      = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-x8v100"
  type        = "BM.GPU3.8"
  replicas    = var.replicas.x8v100
  public      = false
  preemptible = var.preemptible

  os_image    = var.ubuntu_2004[var.region]
  subnet      = oci_core_subnet.private.id
}

module "instance_x8a100" {
  source      = "./instance"

  cluster_id  = local.cluster_id
  name        = "${local.cluster_id}-x8a100"
  type        = "BM.GPU4.8"
  replicas    = var.replicas.x8a100
  public      = false
  preemptible = var.preemptible

  os_image    = var.ubuntu_2004[var.region]
  subnet      = oci_core_subnet.private.id
}