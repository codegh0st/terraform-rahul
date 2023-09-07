
# below   variable is assined for creating ec2 instance. 
amiId ="ami-ubunk3jlski4534l"
ec2count = 2
instanceType = "t2.micro"

#  below this values is assgned in varaible 'users' , this is a list varible, and being acced in 
# list-variables.tf
# paaing value in runtime : terraform apply -var='users=["jhon", "bob"]'
users = ["rahul","ramesh","shiva"]


/*
In terraform.tfvars we are assiging the values to that varaibles which is defined in variable.tf file or defined in variable block in any .tf file
whn we give terraform apply , value will be loaded automaticaly from terraform.tfvars. 
if definition file name is something else, we have to provide path of the declaraion file with option -var-file="path-of-variable-file.ftvars"

Suppose we have create same resouce in defferent different enviormnet but with different values,
then we can create dev.ftvars, qa.tfvars, prod.tfvars file and in each file we can give 
required values as we want. like in prod i want to create ubunu server, with t2.large or wit any
other conif then i will update the prod.tfvars file according to the need and will giev fillowiing cmd
terraform apply -var="path/dev.tfvars"
terraform apply -var="path/qa.tfvars"
*/