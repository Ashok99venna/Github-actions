prefix                              = "coworks-prod"
region                              = "us-east-1"

vpc_cidr                            = "10.0.0.0/16"
azs                                 = ["us-east-1a", "us-east-1b"]
public_subnets                      = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets                     = ["10.0.2.0/24", "10.0.3.0/24"]
enable_nat_gateway                  = true
single_nat_gateway                  = true
one_nat_gateway_per_az              = false
enable_dns_hostnames                = true
enable_dns_support                  = true
customer_service_instance_type      = "t2.micro"
order_service_instance_type         = "t2.micro"
catalog_service_instance_type       =  "t2.micro"
range_service_instance_type         = "t2.micro"
config_service_instance_type         = "t2.micro"
cart_service_instance_type         = "t2.micro"
user_service_instance_type         = "t2.micro"
iam_instance_profile                = "ssm-ec2"
volume_size                         = 30
ingress_with_cidr_blocks_from_port1 = 80
ingress_with_cidr_blocks_to_port1   = 80
ingress_with_cidr_blocks_from_port2 = 443
ingress_with_cidr_blocks_to_port2   = 443
ingress_with_cidr_blocks_from_port3 = 22
ingress_with_cidr_blocks_to_port3   = 22
protocol                            = "tcp"
elastic_beanstalk_application_name  = "test_beanstalk"
Instance_type       = "t2.micro"
minsize             = 1
maxsize             = 2
tier                 = "WebServer"
solution_stack_name= "64bit Amazon Linux 2018.03 v4.17.16 running Node.js"
sg_alb_ingress_rules =  ["http-80-tcp","https-443-tcp"]







