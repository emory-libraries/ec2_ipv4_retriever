# frozen_string_literal: true

require_relative "ec2_ipv4_retriever/version"
require 'aws-sdk-ec2'

module Ec2Ipv4Retriever
  class Error < StandardError; end

  def find_ip_by_ec2_name(region: 'us-east-1', ec2_name:)
    ec2_resource = ::Aws::EC2::Resource.new(region: region)
    ec2_instance = pull_ec2_instance_by_tag_name(ec2_resource: ec2_resource, ec2_name: ec2_name)

    ec2_instance.nil? ? nil : ec2_instance.private_ip_address
  end

  private

  def pull_ec2_instance_by_tag_name(ec2_resource:, ec2_name:)
    ec2_resource&.instances(filters: [{ name: "tag:Name", values: [ec2_name] }])&.first
  end
end
