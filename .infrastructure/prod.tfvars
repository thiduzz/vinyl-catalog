project_name = "vinyl-catalog"
tag_environment = "prod"

#######################################################
###              AWS                                ###
#######################################################

## The range of IPv4s of our VPC
vpc_cidr = "172.33.0.0/16"

## The range of our first subnetwork
public_subnet_range = "172.33.0.0/24"
## The range of our second subnetwork
public_subnet_range_2 = "172.33.1.0/24"
## The range of our third subnetwork
public_subnet_range_3 = "172.33.2.0/24"
## The list of Node IPs of our Kubernetes Cluster in the CIDR format (ie. 51.15.217.96/32)
## Don't forget to add the "/32" at the end of it since this are public IPs
scaleway_ips = [
  "51.15.217.96/32" ##If you spawn more than 1 Kubernetes Node you will need to add its IP to this list
]
#private_subnet_range =  "172.33.3.0/24"