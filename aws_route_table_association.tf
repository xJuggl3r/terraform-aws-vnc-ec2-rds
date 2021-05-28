# Provides a resource to create an association between a route table and a subnet or a route table and an internet gateway.
resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}