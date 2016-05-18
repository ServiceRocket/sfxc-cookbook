name 'sfxc-cookbook'
maintainer 'ServiceRocket'
license 'Apache 2.0'
description 'Cookbook for Salesforce add-on deployments'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

depends 'newrelic'

source_url 'https://github.com/ServiceRocket/sfxc-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/ServiceRocket/sfxc-cookbook/issues' if respond_to?(:issues_url)