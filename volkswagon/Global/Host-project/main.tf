
module "vpc" {
  source       = "../../modules/vpc"
  network_name = var.network_name
}

module "subnet_dev" {
  source       = "../../modules/subnet"
  network      = module.vpc.network_id
  subnet_name  = "dev-subnet"
  region       = var.region
  cidr         = "10.10.0.0/24"
}

module "subnet_sit" {
  source       = "../../modules/subnet"
  network      = module.vpc.network_id
  subnet_name  = "sit-subnet"
  region       = var.region
  cidr         = "10.20.0.0/24"
}

module "subnet_prod" {
  source       = "../../modules/subnet"
  network      = module.vpc.network_id
  subnet_name  = "prod-subnet"
  region       = var.region
  cidr         = "10.30.0.0/24"
}

module "nat" {
  source  = "../../modules/nat"
  network = module.vpc.network_id
  region  = var.region
}

module "firewall" {
  source  = "../../modules/firewall"
  network = module.vpc.network_id
}