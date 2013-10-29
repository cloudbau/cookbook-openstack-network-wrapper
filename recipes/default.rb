#
# Cookbook Name:: stackforge-havana
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'openstack-common'
include_recipe 'openstack-common::logging'

chef_gem 'chef-rewind'

require 'chef/rewind'
