
variable "iamusers" {
    type = list(string)
    description = "iam users to be created on aws"
    default = [ "rahul","ramesh","shiva" ]
  
}


resource "aws_iam_user" "iamusers" {
     count = length(var.iamusers)
     name = var.iamusers[count.index]
}




# Another Approach to create multiple users
# variable 'users' is being assigned in terrafrom.tfvars file. 
# and has been defined in variable.tf
resource "aws_iam_user" "iamuser" {
  for_each = toset(var.users) 
  name = each.value
}


# variable 'users' is being assigned in terrafrom.tfvars file. 
# and defined in variable.tf

# above code there is thre value in in list, which i have converted in set, 
# there will be 3 iteration, in each iteraion one value will be assinged in name,
# name = rahul, name = shiva, name = ramesh, and with this name iam user will be cretated.