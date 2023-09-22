vpccidr = "10.2.0.0/16"
publicssubentscidrs = [ "10.2.0.0/19", "10.2.32.0/19","10.2.64.0/19"]
privatesubentscidrs = ["10.2.96.0/19","10.2.128.0/19","10.2.160.0/19"]
aws_availabilty_zones = ["ap-south-1a","ap-south-1b","ap-south-1c"]
enable_dns_support = true
commantags = {
    "ProjectName" = "Demo-Prod",
    "Environmet"  = "Production"
}