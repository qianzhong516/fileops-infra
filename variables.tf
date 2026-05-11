variable "public_subnets" {
  default = {
    public-a = "10.0.1.0/24"
    public-b = "10.0.2.0/24"
    public-c = "10.0.3.0/24"
  }
}

variable "private_subnets" {
  default = {
    private-a = "10.0.11.0/24"
    private-b = "10.0.12.0/24"
    private-c = "10.0.13.0/24"
  }
}

variable "availability_zones" {
  default = {
    public-a  = "ap-southeast-2a"
    public-b  = "ap-southeast-2b"
    public-c  = "ap-southeast-2c"
    private-a = "ap-southeast-2a"
    private-b = "ap-southeast-2b"
    private-c = "ap-southeast-2c"
  }
}

locals {
  tags = {
    Environment = "dev"
    Project     = "FileOps"
  }
}
