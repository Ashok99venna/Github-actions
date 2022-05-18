provider "aws" {
  profile                 = "default"                                            // Manual Update required for: pass a profile parameter
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}

module "vpc" {
  source                 = "./modules/vpc"
  name                   = "${var.prefix}-vpc"
  cidr                   = var.vpc_cidr
  azs                    = var.azs
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support
  igw_tags = {
    Name = "${var.prefix}_internet"
  }
  nat_gateway_tags = {
    Name = "${var.prefix}_natgateway"
  }
  nat_eip_tags = {
    Name = "${var.prefix}_NAT-IP"
  }

}
module "customer_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-customer_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}



module "customer_service_ec2" {
  depends_on                  = [module.customer_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-customer_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.customer_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.customer_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}
module "order_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-order_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}



module "order_service_ec2" {
  depends_on                  = [module.range_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-order_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.order_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.order_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}
module "catalog_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-catalog_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}

module "catalog_service_ec2" {
  depends_on                  = [module.catalog_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-catalog_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.catalog_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.catalog_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}

module "range_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-range_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}



module "range_service_ec2" {
  depends_on                  = [module.range_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-range_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.range_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.range_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}
module "config_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-config_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}



module "config_service_ec2" {
  depends_on                  = [module.config_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-config_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.config_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.config_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}
module "cart_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-cart_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}



module "cart_service_ec2" {
  depends_on                  = [module.cart_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-cart_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.cart_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.cart_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}
module "user_service_sg" {
  source = "./modules/security_group"
  name   = "${var.prefix}-user_service_sg"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = "10.0.0.0/16"

    }

  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}



module "user_service_ec2" {
  depends_on                  = [module.user_service_sg]
  source                      = "./modules/ec2"
  name                        = "${var.prefix}-user_service"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.user_service_instance_type
  iam_instance_profile        = var.iam_instance_profile                 
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]                
  vpc_security_group_ids      = [module.user_service_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    }
  ]
}
/* module "storage" {
  source                = "./modules/storage"
  environment           = "prod"
  uploads_bucket_prefix = "random_id.random_id_prefix.hex-assets"
} */

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["099720109477"]
}


resource "aws_security_group" "allow_tls" {
  name        = "elb"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
 


 
# Create elastic beanstalk Environment
resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = "app1"
}
 
module "elastic_beanstalk_environment" {
    source                     = "./modules/elastic-stack"
     region                     = var.region
     name                       =       "app1"
  
   
  
    wait_for_ready_timeout             = var.wait_for_ready_timeout
    elastic_beanstalk_application_name = "app1"
    
    loadbalancer_type                  = var.loadbalancer_type
    elb_scheme                         = var.elb_scheme
    tier                               = var.tier
    version_label                      = var.version_label
    force_destroy                      = var.force_destroy
  
    instance_type    = var.instance_type
    root_volume_size = var.root_volume_size
    root_volume_type = var.root_volume_type
  
    autoscale_min             = var.autoscale_min
    autoscale_max             = var.autoscale_max
    autoscale_measure_name    = var.autoscale_measure_name
    autoscale_statistic       = var.autoscale_statistic
    autoscale_unit            = var.autoscale_unit
    autoscale_lower_bound     = var.autoscale_lower_bound
    autoscale_lower_increment = var.autoscale_lower_increment
    autoscale_upper_bound     = var.autoscale_upper_bound
    autoscale_upper_increment = var.autoscale_upper_increment
  
    vpc_id               = module.vpc.vpc_id
    loadbalancer_subnets = module.vpc.public_subnets
    application_subnets  = module.vpc.private_subnets
  
    allow_all_egress = true

    
    rolling_update_enabled  = var.rolling_update_enabled
    rolling_update_type     = var.rolling_update_type
    updating_min_in_service = var.updating_min_in_service
    updating_max_batch      = var.updating_max_batch
  
    healthcheck_url  = var.healthcheck_url
    application_port = var.application_port
  
    solution_stack_name = var.solution_stack_name    
    additional_settings = var.additional_settings
    env_vars            = var.env_vars
   
  
    extended_ec2_policy_document = data.aws_iam_policy_document.minimal_s3_permissions.json
    prefer_legacy_ssm_policy     = false
    prefer_legacy_service_policy = false
    scheduled_actions            = var.scheduled_actions
  
    
  }
    
  data "aws_iam_policy_document" "minimal_s3_permissions" {
    statement {
      sid = "AllowS3OperationsOnElasticBeanstalkBuckets"
      actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }
}

