
output "tags" {
  value = module.label.tags
}

output "name" {
  value = module.label.name
}

output "vpc_id" {
  value = data.aws_vpc.this.id
}

output "public_subnets" {
  value = values(zipmap(data.aws_subnet.public.*.availability_zone, data.aws_subnet.public.*.id))
}

output "public_subnets_cidr_blocks" {
  value = values(zipmap(data.aws_subnet.public.*.availability_zone, data.aws_subnet.public.*.cidr_block))
}

output "private_subnets" {
  value = values(zipmap(data.aws_subnet.private.*.availability_zone, data.aws_subnet.private.*.id))
}

output "private_subnets_cidr_blocks" {
  value = values(zipmap(data.aws_subnet.private.*.availability_zone, data.aws_subnet.private.*.cidr_block))
}

output "vpc_cidr_block" {
  value = data.aws_vpc.this.cidr_block
}

output "vpc_security_group_ids" {
  value = [data.aws_security_group.this.id]
}
