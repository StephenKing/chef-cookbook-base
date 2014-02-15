#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2013, TYPO3 Association
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
#

::Chef::Recipe.send(:include, Typo3::Base::Node)
::Chef::Recipe.send(:include, Typo3::Base::Recipe)

#######################
# Physical and Virtualized host
#######################

include_recipe "base::physical"
include_recipe "base::virtualized"


#######################
# Virtualization in use (either host or guest)
#######################

if virtualization?
  Chef::Log.debug("Virtualization detected (using #{node[:virtualization][:system]})")
  # automatically include the cookbook for the used virtualization type (e.g. openvz, vmware, vbox)
  include_if_available "#{node[:virtualization][:system]}::default"
end

#######################
# Base software
#######################

include_recipe "base::software"

#######################
# Datacenter
#######################

include_recipe "datacenter::default"

#######################
# Operating System specific options
#######################

include_recipe "operatingsystem::default"