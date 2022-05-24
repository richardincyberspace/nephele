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
  source              = "./instance"

  cluster_id          = local.cluster_id
  name                = "${local.cluster_id}-login"
  type                = "BM.HPC2.36"
  replicas            = 1
  public              = true
  preemptible         = false
  ssh                 = var.ssh

  os_image            = var.ubuntu_2004[var.region]
  os_disk_size        = "1000"
  subnet              = oci_core_subnet.public.id
  config              = data.cloudinit_config.ubuntu2004.rendered

  compartment_ocid    = var.compartment_ocid
  custom_tags         = var.custom_tags
  availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
}

module "instances_x8v100" {
  source             = "./instance"

  cluster_id         = local.cluster_id
  name               = "${local.cluster_id}-x8v100"
  type               = "BM.GPU3.8"
  replicas           = var.replicas.x8v100
  public             = false
  preemptible        = var.preemptible
  ssh                = var.ssh

  os_image            = var.ubuntu_2004[var.region]
  os_disk_size        = "2000"
  subnet              = oci_core_subnet.private.id
  config              = data.cloudinit_config.ubuntu2004.rendered

  compartment_ocid    = var.compartment_ocid
  custom_tags         = var.custom_tags
  availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
}

module "instances_x8a100" {
  source              = "./instance"

  cluster_id          = local.cluster_id
  name                = "${local.cluster_id}-x8a100"
  type                = "BM.GPU4.8"
  replicas            = var.replicas.x8a100
  public              = false
  preemptible         = var.preemptible
  ssh                 = var.ssh

  os_image            = var.ubuntu_2004[var.region]
  os_disk_size        = "2000"
  subnet              = oci_core_subnet.private.id
  config              = data.cloudinit_config.ubuntu2004.rendered

  compartment_ocid    = var.compartment_ocid
  custom_tags         = var.custom_tags
  availability_domain = data.oci_identity_availability_domains.default.availability_domains[0].name
}
