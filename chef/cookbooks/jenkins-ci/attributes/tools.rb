#
# Cookbook:: jenkins
# Attributes:: tools
#

default['jenkins']['tools'].tap do |tools|
  tools['maven'] = true
  tools['maven_version'] = "3.5.0"
end
