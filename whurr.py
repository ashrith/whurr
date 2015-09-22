#! /usr/bin/env python

#NOTES
#Remember to have a new pem key for uswest-2. Actually remember to have a new key for every place. 
import boto3, os, base64, time, random

subnet_range = '10.0.48.0/24'
vpc_range = '10.0.48.0/24'
my_tag_prefix ='bartha'

def create_my_tag(self):
	return(my_tag_prefix+self)
#VPC Creator

def call_my_vpc(self, vpc_id=None):
	my_vpc_list = list(self.vpcs.filter(Filters=[{'Name':'tag-value','Values':[create_my_tag('vpc')]}]))
	if vpc_id is None and not my_vpc_list:	
		my_new_vpc = self.create_vpc(CidrBlock=vpc_range)
		vpc_id = my_new_vpc.id
		vpc_object = self.Vpc(vpc_id)
		vpc_object.modify_attribute(VpcId=my_new_vpc.id, EnableDnsSupport={'Value':True})
		vpc_object.modify_attribute(VpcId=my_new_vpc.id, EnableDnsHostnames={'Value':True})
		vpc_object.create_tags(Tags=[{'Key':'Name','Value':create_my_tag('vpc')}])
		my_vpc_list = [vpc_object]
		my_vpc_id_list = [vpc_id]
	elif vpc_id is not None:
		vpc_object = self.Vpc(vpc_id)
		my_vpc_list = [vpc_object]
		my_vpc_id_list = [vpc_id]
	else:
		my_vpc_id_list = map(lambda obj: obj.id, my_vpc_list)
	return (my_vpc_list, my_vpc_id_list)


def call_my_subnet(self, subnet_id=None, vpc_id = None):
	if subnet_id is not None:
		subnet_object = self.Subnet(subnet_id)
	else:
		vpc_obj_list, vpc_id_list = call_my_vpc(self, vpc_id)
		my_subnet_list = list(vpc_obj_list[0].subnets.filter(Filters=[{'Name':'tag-value','Values':[create_my_tag('subnet')]}]))
		if not my_subnet_list:
			subnet_object = vpc_obj_list[0].create_subnet(CidrBlock=subnet_range)
                        subnet_object.create_tags(Tags=[{'Key':'Name','Value':create_my_tag('subnet')}])
			subnet_id = subnet_object.subnet_id
		else:
			subnet_object = my_subnet_list[0]
			subnet_id = subnet_object.subnet_id
	return (subnet_object, subnet_id)
		

def call_my_gateway(self, gateway_id=None, vpc_id = None):
	if gateway_id is not None:
		gateway_object = self.InternetGateway(gateway_id)
	else:
		vpc_obj_list, vpc_id_list = call_my_vpc(self, vpc_id)
		my_gateway_list = list(vpc_obj_list[0].internet_gateways.filter(Filters=[{'Name':'tag-value','Values':[create_my_tag('gateway')]}]))
		if not my_gateway_list:
			gateway_object = self.create_internet_gateway()
			gateway_object.create_tags(Tags=[{'Key':'Name', 'Value':create_my_tag('gateway')}])
			gateway_object.attach_to_vpc(VpcId=vpc_id_list[0])
			gateway_id = gateway_object.internet_gateway_id
		else:
			gateway_object = my_gateway_list[0]
			gateway_id = gateway_object.internet_gateway_id
	return (gateway_object, gateway_id)

		
def call_my_route_table(self, route_table_id=None, vpc_id = None):
	if route_table_id is not None:
		route_table_object = self.RouteTable(route_table_id)
		route_table_id = route_table_object.route_table_id
	else:
		vpc_obj_list, vpc_id_list = call_my_vpc(self, vpc_id)
		my_route_table_list = list(vpc_obj_list[0].route_tables.filter(Filters=[{'Name':'tag-value','Values':[create_my_tag('route_table')]}]))
		if not my_route_table_list:
			vpc_obj_list, vpc_id_list = call_my_vpc(self, vpc_id)
			subnet_obj, subnet_id = call_my_subnet(self, vpc_id)
			gateway_object, gateway_id = call_my_gateway(self, vpc_id)
			route_table_object = self.create_route_table(VpcId=vpc_id_list[0])
			route_table_object.associate_with_subnet(SubnetId=subnet_id)
			route_table_object.create_route(GatewayId=gateway_id, DestinationCidrBlock='0.0.0.0/0')
			route_table_object.create_tags(Tags=[{'Key':'Name', 'Value':create_my_tag('route_table')}])
			route_table_id = route_table_object.route_table_id
		else:
			route_table_object = my_route_table_list[0]
			route_table_id = route_table_object.route_table_id
	return (route_table_object, route_table_id)

################################################################
# call the seucrity group object
# now, only calls on SG from the list. 
# If you want to implement an SG for a cluster
# please add all of them to one SG
################################################################


def call_my_security_groups(self, security_groups_id = None, vpc_id=None):
	if security_groups_id is not None:
		security_groups_object = self.SecurityGroup(security_groups_id)
		security_groups_id = security_groups_object.id
	else:
		vpc_obj_list, vpc_id_list = call_my_vpc(self, vpc_id)
		my_security_groups_list = list(vpc_obj_list[0].security_groups.filter(Filters=[{'Name':'tag-value','Values':[create_my_tag('security_group')]}]))
		if not my_security_groups_list:
			vpc_obj_list, vpc_id_list = call_my_vpc(self, vpc_id)
			security_groups_object = self.create_security_group(GroupName=create_my_tag('security_group'),Description='SG for cluster',VpcId=vpc_id_list[0])
			security_groups_object.create_tags(Tags=[{'Key':'Name', 'Value':create_my_tag('security_group')}])
        		IpPermissions=[
            		{
                		'IpProtocol': 'tcp',
               			'FromPort': 0,
                		'ToPort': 65535,
                		'IpRanges': [
                    			{
                        			'CidrIp': '10.0.48.0/16'
                    			},
                		],
            		},
            		{
                		'IpProtocol': 'tcp',
                		'FromPort': 22,
                		'ToPort': 22,
                		'IpRanges': [
                    			{
                        			'CidrIp': '0.0.0.0/0'
                    			},
                		],
            		}
        		]
        		security_groups_object.authorize_egress(IpPermissions=IpPermissions)
        		security_groups_object.authorize_ingress(IpPermissions=IpPermissions)
			security_groups_id = security_groups_object.id
		else:
			security_groups_object = my_security_groups_list[0]
			security_groups_id = security_groups_object.id
	return(security_groups_object, security_groups_id)


def call_my_instance_customizer(file_name=None):
	try:
		shell_code_file=os.path.abspath(file_name)
		shell_file_raw_object = open(shellcodefile,'r').read()
		shell_file_failure_message =  None
	except (IOError, AttributeError):
		shell_file_raw_object = None
		shell_file_failure_message =  'Warning: There is no customizer script'
	return (shell_file_raw_object, shell_file_failure_message)
			
		

def call_my_new_instances(self, customizer_file_name = None, key_file_name = None, subnet_id = None, security_groups_id=None, min_number_of_instances = 1, max_number_of_instances = 1, base_image_id = 'ami-0be2743b', base_instance_type = 'm4.large'):
	subnet_obj, subnet_obj_id  = call_my_subnet(self, subnet_id)
	security_groups_obj, security_groups_obj_id = call_my_security_groups(self, security_groups_id)
	customizer_obj, customizer_error_msg = call_my_instance_customizer(customizer_file_name)
	if customizer_obj is None:
		print(customizer_error_msg)
		user_data_temp_obj = '!# /usr/bin/env bash'
	else:
		user_data_temp_obj = customizer_obj
	instance_object_list = self.create_instances(
				MinCount = min_number_of_instances,
				MaxCount = max_number_of_instances,
				UserData = user_data_temp_obj,
				KeyName = key_file_name,
				ImageId = base_image_id,
				InstanceType = base_instance_type,
				NetworkInterfaces=[{'SubnetId': subnet_obj_id, 'DeviceIndex':0, 'Groups':[security_groups_obj_id], 'AssociatePublicIpAddress':True}]
	)
	time.sleep(100)
	map(lambda obj: obj.create_tags(Tags=[{'Key':'Name', 'Value':create_my_tag('instance')}]), instance_object_list)
	return instance_object_list

################################################################
# This is a terrible way of building Namenode
# Namenodes should be built by the usual system data node
# and a specific machine with a specific IP must be called nn
# Amazon does not provide you the capability to specific 
# private Ip addresses as a list. So Doing this hack
# But this is terrible.
################################################################

def call_me_one_nn(self, customizer_file_name = None, key_file_name = None, subnet_id = None, security_groups_id = None, min_number_of_instances = 1, max_number_of_instances = 1, base_image_id = 'ami-0be2743b', base_instance_type = 'm4.large'):
	subnet_obj, subnet_obj_id  = call_my_subnet(self, subnet_id)
	security_groups_obj, security_groups_obj_id = call_my_security_groups(self, security_groups_id)
	customizer_obj, customizer_error_msg = call_my_instance_customizer(customizer_file_name)
	if customizer_obj is None:
		print(customizer_error_msg)
		user_data_temp_obj = '!# /usr/bin/env bash'
	else:
		user_data_temp_obj = customizer_obj
	instance_object_list = self.create_instances(
				MinCount = min_number_of_instances,
				MaxCount = max_number_of_instances,
				UserData = user_data_temp_obj,
				KeyName = key_file_name,
				ImageId = base_image_id,
				InstanceType = base_instance_type,
				NetworkInterfaces=[{'SubnetId': subnet_obj_id, 'DeviceIndex':0, 'Groups':[security_groups_obj_id], 'PrivateIpAddress':'10.0.48.5','AssociatePublicIpAddress':True}]
	)
	time.sleep(100)
	map(lambda obj: obj.create_tags(Tags=[{'Key':'Name', 'Value':create_my_tag('instance')}]), instance_object_list)
	return instance_object_list

def call_boto_resource(service = 'ec2', region='us-west-2',access_key_id = 'INS_AWS_ACCESS_KEY_ID', secret_access_key_id = 'INS_AWS_SECRET_ACCESS_KEY'):
	ec2_as_resource = boto3.resource(
				service_name = service,
				region_name = region,
				aws_access_key_id=os.environ.get(access_key_id),
				aws_secret_access_key=os.environ.get(secret_access_key_id)
	)
	return ec2_as_resource
				
		
	

__name__=="__main__"


################################################################
# Technically this must different piece of code. The above must
# declared as a Python class. And this code must extend. But for
# now, as always...
# Please, please, please move this code out! 
################################################################
ec2_as_resource = call_boto_resource()
dummy_obj = call_me_one_nn(ec2_as_resource, None, 'ash-key-insight', None, None, 1, 1)
dummy_obj = call_my_new_instances(ec2_as_resource, None, 'ash-key-insight', None, None, 1, 5)

################################################################
# Give enough time for the Instance to create data and all the 
# required stuff.
# Also, make sure that the new instance is booted up after a 
# slight delay.
################################################################
time.sleep(3600)
instance_obj_list = list(ec2_as_resource.instances.filter(Filters=[{'Name':'tag-value','Values':[create_my_tag('instance')]}]))
live_instance_object_list = filter(lambda iol: iol.state['Code'] != 48 and iol.private_ip_address != '10.0.48.5', instance_object_list)

while(True):
	time.sleep(300)
	picked_random_instance = random.choice(live_instance_object_list)
	terminal_status = picked_random_instance.terminate()
	pickced_random_instance.wait_until_terminated()
	dummy_obj = call_my_new_instances(ec2_as_resource, None, 'ash-key-insight', None, None, 1, 1)

