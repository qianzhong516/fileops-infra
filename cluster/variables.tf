variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "cluster_name" {
  type    = string
  default = "fileops-cluster"
}

variable "public_subnets" {
  type = map(string)
  default = {
    public-a = "10.0.1.0/24"
    public-b = "10.0.2.0/24"
    public-c = "10.0.3.0/24"
  }
}

variable "private_subnets" {
  type = map(string)
  default = {
    private-a = "10.0.11.0/24"
    private-b = "10.0.12.0/24"
    private-c = "10.0.13.0/24"
  }
}

variable "availability_zones" {
  type = map(string)
  default = {
    public-a  = "ap-southeast-2a"
    public-b  = "ap-southeast-2b"
    public-c  = "ap-southeast-2c"
    private-a = "ap-southeast-2a"
    private-b = "ap-southeast-2b"
    private-c = "ap-southeast-2c"
  }
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "FileOps"
  }
}
