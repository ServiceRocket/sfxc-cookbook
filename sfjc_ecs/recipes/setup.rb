# Copies the +ecs.config+ file containing the Docker Hub credentials from an AWS S3 bucket
# and appends its contents to the existing configuration file in +/etc/ecs/ecs.config+.
# The S3 bucket name is configurable via the Chef attribute +["sfjc"]["config"]["s3_bucket_name"]+.
#
# Refer to the AWS guide for further information:
# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-config.html#ecs-config-s3
execute "Install Docker Hub credentials" do
  command "aws s3 cp s3://#{node["sfjc"]["config"]["s3_bucket_name"]}/ecs.config - >> /etc/ecs/ecs.config"
end