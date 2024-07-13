resource "aws_vpc" "vpc" {
  for_each = keys(var.complex)
  cidr_block = var.complex[each.key].cidr
}


resource "aws_subnet" "subnet" {
  for_each = var.map
  vpc_id = aws_vpc.vpc[each.key].vpc_id
}

resource "aws_subnet" "subnet1" {
  for_each = var.is_multi_az == true ? 3 : 1 // Si vrai 3 et si faux 1(après les 2 points) 
  vpc_id = aws_vpc.vpc[each.key].vpc_id
}