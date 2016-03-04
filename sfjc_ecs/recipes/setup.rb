# Copies the +ecs.config+ file containing the Docker Hub credentials from an AWS S3 bucket
# and appends its contents to the existing configuration file in +/etc/ecs/ecs.config+.
# The S3 bucket name is configurable via the Chef attribute +["sfjc"]["config"]["s3_bucket_name"]+.
#
# Refer to the AWS guide for further information:
# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html#ecs-config-s3
execute "Install Docker Hub credentials" do
  command "aws s3 cp s3://#{node["sfjc"]["config"]["s3_bucket_name"]}/ecs.config - >> /etc/ecs/ecs.config"
end

# Adds the user +newrelic+ to the group +docker+ to enable New Relic Docker Server Monitoring.
# This assumes that the New Relic Server Monitoring recipe +newrelic::default+ has been run before and therefore the
# user +newrelic+ already exists.
#
# Refer to the New Relic cookbook and New Relic guide for further information:
# https://github.com/escapestudios-cookbooks/newrelic
# https://docs.newrelic.com/docs/servers/new-relic-servers-linux/installation-configuration/enabling-new-relic-servers-docker
group "docker" do
  action :modify
  members "newrelic"
  append true
end

# Adds the +cgroup_root+ configuration to the New Relic Server Monitoring configuration.
#
# Refer to the New Relic cookbook and New Relic guide for further information:
# https://docs.newrelic.com/docs/servers/new-relic-servers-linux/installation-configuration/enabling-new-relic-servers-docker
ruby_block "Add cgroup_root to New Relic Server Monitoring config" do
  block do
    cgroup_root_config = "cgroup_root='/cgroup'"
    file = Chef::Util::FileEdit.new("/etc/newrelic/nrsysmond.cfg")
    file.insert_line_if_no_match(cgroup_root_config, cgroup_root_config)
    file.write_file
  end
end

# Restarts the New Relic Server Monitoring daemon to read the updated configuration.
execute "Restart New Relic Server Monitoring daemon" do
  command 'service newrelic-sysmond restart'
end