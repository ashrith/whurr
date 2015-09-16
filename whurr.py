#! /usr/bin/env python
import boto3,os,base64

#runcode=os.system('#! /usr/bin/env bash touch /tmp/test.code;echo ifconfig > /tmp/test.code; chmod +x /tmp/test.code; /tmp/test.code'
shellcodefile=os.path.abspath('shell.spark.sh')
shellfilerawobj = open(shellcodefile,'r').read()
shellfileb64obj = base64.b64encode(shellfilerawobj)
#shellfileb64obj = ''

pemfile =os.path.abspath('/tmp/testash.pem')

client = boto3.client(
	service_name='ec2',
#	region_name="us-east-1",
	region_name="us-west-1",
	aws_access_key_id=os.environ.get('INS_AWS_ACCESS_KEY_ID'),
	aws_secret_access_key=os.environ.get('INS_AWS_SECRET_ACCESS_KEY')
)


responseone = client.run_instances(
#	SpotPrice='0.40',
	MinCount=1,
	MaxCount=1,
#	Type='one-time',
			UserData=shellfileb64obj,
			KeyName=pemfile,
			ImageId='ami-0c5b5f49',
			InstanceType='t2.large',
#		LaunchSpecification={
#			'InstanceType':'t2.large',
##			'ImageId':'ami-06ade96e',
#			'ImageId':'ami-0c5b5f49',
#			'KeyName':pemfile,
#			'UserData':shellfileb64obj,
			NetworkInterfaces=[
			{
#				'AssociatePublicIpAddress':True,
				'DeviceIndex':0,
#				'SubnetId':'subnet-dad046bf',
				'SubnetId':'subnet-77705831',
#				'Groups':['sg-8cf3c1eb'],
#				'PrivateIpAddress':'10.0.1.5',
			
			}
		]
		#}
	)

#for n in range(0,4):
##	assignipaddress='10.0.1.'+str(n+6)
#	response = client.request_spot_instances(
#		SpotPrice='0.40',
#		InstanceCount=1,
#		Type='one-time',
#			LaunchSpecification={
#				'InstanceType':'t2.large',
#				'ImageId':'ami-06ade96e',
##			'ImageId':'ami-00615068',
#				'KeyName':pemfile,
#				'UserData':shellfileb64obj,
#				'NetworkInterfaces':[
#				{
##					'AssociatePublicIpAddress':True,
#					'DeviceIndex':0,
#					'SubnetId':'subnet-fbd285d0',
##					'Groups':['sg-8cf3c1eb'],
##					'PrivateIpAddress':assignipaddress,
#					
#				}
#			]
#			}
#		)
