# this file contains resource definaiton


# Create multiple iam user Manual Way 
resource "aws_iam_user" "userRahul" {
  name = "rahul" # with this name user will be created in aws
  tags = {
    name = "rahul-user"
  }
}

resource "aws_iam_user" "userSuresh" {
  name = "suresh"
  tags = {
    name = "suresh-user"
  }
}

resource "aws_iam_user" "userRohan" {
  name = "rohan"
  tags = {
    "Name" = "rohan-user"
  }
}

# Create multiple iam user using loop for_each
# No need to write same code multiple time. "toset" is func to convert the data in list.
# we fetch the data using each.key , in every iteration value will be assing in each.key
# for 1st rahul, then, suresh, then rohan will be assinged in each.key 
# hence with those name and tag iam user will be created in aws. 
resource "aws_iam_user" "iamUser" {
  for_each = toset([ "rahul","suresh","rohan" ])
  name = each.key
  tags = {
    "Name" = each.key
  }
}

# Create s3 Bucket using for_each
resource "aws_s3_bucket" "s3bucket" {
#creating list of <key> = <value> , eg. dev, qa, prod 
for_each = {
  dev = "rahulbucket-s3bucket"
  qa = "rahulbucket-s3bucket"
  prod = "rahulbucket-s3bucket"
}

bucket = "${each. key}-${each.value}"
tags = {
Name = "${each.key}-${each.value}"
Environment = "${each.key}"
}
}