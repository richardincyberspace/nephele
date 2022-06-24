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

variable "tenancy_ocid" {
  description = "Tenancy OCID for OCI"
  type        = string
  default     = null
}

variable "user_ocid" {
  description = "User OCID for OCI"
  type        = string
  default     = null
}

variable "fingerprint" {
  description = "Fingerprint for OCI"
  type        = string
  default     = null
}

variable "private_key_path" {
  description = "Private Key Path for OCI"
  type        = string
  default     = null
}

variable "compartment_ocid" {
  description = "Compartment OCID for OCI"
  type        = string
  default     = null
}

variable "region" {
  description = "Region"
  type        = string
  default     = null
}

variable "os_disk_size" {
  description = "Size of OS Disk for each instance"
  type        = string
  default     = "2000"
}

variable "ubuntu_2004" {
  # https://docs.oracle.com/en-us/iaas/images/
  description = "OCID for Ubuntu 2004 image in different regions"
  type        = map(string)
  default     = {
    "us-sanjose-1": "ocid1.image.oc1.us-sanjose-1.aaaaaaaarlhoz4n2z2v6vbml3yausxd3jfp4i642ofr2kmafhkjm6fwmq2dq"
    "eu-frankfurt-1": "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaavcrpbwmm75t6azhxgepxah6vigiwwvruti3gj2frhuxnvhzn3e5a"
    "ap-tokyo-1": "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaiqnzylthf6siyhwrnwu7fzci2clbp4rpdtuok6byikb727nklc5q"
    "ap-osaka-1": "ocid1.image.oc1.ap-osaka-1.aaaaaaaamgf3qgzwv4nen7kv6e345uefzt5j4w22glyhem3epk76b73gfn6a"
  }  
}

variable "vcn_cidr" {
  description = "Address prefix to use for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Address prefix to use for each VPC subnet"
  type        = object({
    public  = string
    private = string
  })
  default     = {
    public  = "10.0.100.0/24"
    private = "10.0.200.0/24"
  }
}

variable "preemptible" {
  description = "Use preemptible (spot) instances"
  type        = bool
  default     = false
}

variable "ssh" {
  description = "SSH configuration"
  type        = object({
    user         = string
    privkey      = string
    pubkey       = string
    privkey_host = string
    pubkey_host  = string
    known_hosts  = string
    config       = string
  })
  default     = null
}

variable "ansible" {
  description = "Ansible configuration"
  type        = object({
    inventory = string
  })
  default     = null
}

variable "replicas" {
  description = "Number of instance replicas"
  type        = object({
    x8v100 = number
    x8a100 = number
  })
  default     = null
}

# Modify with custom tags for your account
variable "custom_tags" {
  default = {
    }
}