module "network" {
source = "./network"
vpcblock = "192.168.0.0/16"
sub = [ "192.168.3.0/24", "192.168.2.0/24" ]
azone = "us-east-1b"
ami-id = "ami-047a51fa27710816e"
cidrblock = "0.0.0.0/0"
}

