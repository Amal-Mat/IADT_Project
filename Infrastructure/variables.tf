variable "region" {
    default = "us-east-1"
}

variable "vpc-cidr" {
    default = "10.10.0.0/16"
}

variable "public_subnet_1_cidr" {
    description = "CIDR block for public subnet 1"
    default     = "10.10.1.0/24"
}

variable "public_subnet_2_cidr" {
    description = "CIDR block for public subnet 2"
    default     = "10.10.2.0/24"
}

variable "private_subnet_1_cidr" {
    description = "CIDR block for private subnet 1"
    default     = "10.10.3.0/24"
}

variable "private_subnet_2_cidr" {
    description = "CIDR block for private subnet 2"
    default     = "10.10.4.0/24"
}

variable "availability_zones" {
    description = "Availability zones"
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b"]
}

variable "container_port" {
    description = "Port number of the container"
    default = "3000"
}

variable "health_check_path" {
    description = "Health check path for the default target group"
    default = "/ping/"
}

# ecs_service_security_groups
# alb_security_groups
# health_check_path