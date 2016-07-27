include_recipe 'newrelic::server_monitor_agent'

# Adds the user +newrelic+ to the group +docker+ to enable New Relic Docker Server Monitoring.
# This assumes that the New Relic Server Monitoring recipe +newrelic::default+ has been run before and therefore the
# user +newrelic+ already exists.
#
# Refer to the New Relic cookbook and New Relic guide for further information:
# https://github.com/djoos-cookbooks/newrelic
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

# Fetches Spotify's docker garbage collector script from github.
remote_file "/usr/sbin/docker-gc" do
  source 'https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc'
  mode '0755'
  action :create
end

# Defines cronjob to run Docker GC script daily 8AM UTC.
cron "docker-gc" do
  minute 0
  hour 8
  command '/usr/sbin/docker-gc'
  action :create
end