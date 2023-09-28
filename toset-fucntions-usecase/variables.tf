variable "userName" {
    type = list(string)
    default = [ 
        "rahul",
        "ramesh",
        "shiva",
        "rahul" # giving duplicate value 'rahul', 
     ]
  
}






/*

NOTE: 
we are creating iam user using this list, iam user should be unique, But
we delibertely given duplicate value in a list, List can take duplicate value. 

so we keep the list unique we have to typecast this 'list' into a 'set', this
will remove the duplicate value. and unique value will be there in a set. 

hence, while creating iam user, aws will not through any error. 

*/