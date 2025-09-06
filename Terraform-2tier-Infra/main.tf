module "vpc" {

  #Input Variables
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  tags                = local.common_tags

}

module "bastion" {
  source = "./modules/bastion"

  # Input variables
  tags           = local.common_tags
  ec2type        = var.ec2type
  publicsubnetID = module.vpc.public_subnet
  vpcid          = module.vpc.vpc_id
  keyname        = var.keyname
  devip          = var.dev_ip_cidr
}

module "ec2" {
  source = "./modules/ec2"

  # Input variables
  instances = {
    for name, inst in var.instances : name => merge(inst, {
      user_data = file(inst.user_data_file) # <-- load actual script content here
    })
  }
  tags              = local.common_tags
  vpc_id            = module.vpc.vpc_id
  bastionsg         = module.bastion.bastion_sg
  vpc_cidr          = var.vpc_cidr
  private_subnet_id = module.vpc.private_subnet

}