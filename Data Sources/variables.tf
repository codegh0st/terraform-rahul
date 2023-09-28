
variable "region" {
    type = string
    default = "ap-south-1"
  
}

variable "adminUser" {
    type = string
    description = "Admin username"
    sensitive = true # will hide the password in console, when you give plan or apply command
  
}

variable "adminPwd" {
    type = string
    description = "Admin Password"
    sensitive = true # will hide the password in console, when you give plan or apply command
  
}


/*
NOTE : NEVER CHECK OUT .tfvars FILE ON SCM, AS IT MAY CONTAIN SENSITIVE INFO, I'M STILL DOING
BECAUSE I HAVE TO DOCUMENT ALL THE CONCEPT FOR FUTURE REFERENCE. 

NOTE: adminUser and adminPwd variable has not any default variable, 
we pass its value using prod.tfvars file,

terraform plan -var-file="prod.tfvars"  

OR, we can pass its value in runtime also using 
-var="adminUser=rahul" 
-var="adminPwd=rahul@123"

IF you dont pass any value in runtime or not pass any value using .tfvars? 
then it will ask the value in prompt while running the tf plan or tf apply


Ulternatively you can pass the value, using environment varialble
expport TF_VAR_adminUser=rahul
export TF_VAR_adminPwd=rahul123 # environment var doesnt take special char eg. @!@#$%& etc

then run 
terraform plan
terrafrm apply

your configuration will take value from environment variable you just set. 

thank you. 

*/