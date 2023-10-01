
resource "aws_iam_user" "aws-iam-user" {
    for_each = toset(var.userName)
    name = each.value
    tags = {
      "name" = "iam user ${each.value}"
    }

}

/*
Note: for_each only takes set of string and map as arumet. var.userName was list, 
i have typecated into a 'set' and given to for_each fucnion
for furhter processing. 

*/ 