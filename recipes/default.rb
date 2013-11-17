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

if physical?
  Chef::Log.debug("Running on a physical host")
  include_recipe "base::physical"
else
  Chef::Log.debug("Running virtualized")
  include_recipe "base::virtualized"
end


#######################
# Virtualization in use (either host or guest)
#######################

if virtualization?
  Chef::Log.debug("Virtualization detected (using #{node[:virtualization][:system]})")
  # automatically include the cookbook for the used virtualization type (e.g. openvz, vmware, vbox)
  include_if_available "#{node[:virtualization][:system]}::default"
end


#######################
# Datacenter
#######################

unless Chef::Config[:solo] || Chef::Config[:local_mode]
  include_recipe "datacenter::default"
end

#######################
# Operating System specific options
#######################

include_recipe "operatingsystem::default"