package mog.iam

# Deny wildcard permissions
deny[msg] {
  some perm
  input.iam.permissions[perm] == "*"
  msg := "Wildcard permission detected (*) - blocked by least privilege policy."
}

# Deny admin roles
deny[msg] {
  input.iam.role == "Administrator"  # Azure
  msg := "Administrator role assignment denied. Use scoped RBAC."
}

deny[msg] {
  input.iam.policy == "AdministratorAccess"  # AWS
  msg := "AWS AdministratorAccess policy denied. Use least privilege."
}

# Require mandatory tags for new resources
deny[msg] {
  not input.tags.dono
  msg := "Missing mandatory tag: dono"
}
deny[msg] {
  not input.tags.projeto
  msg := "Missing mandatory tag: projeto"
}
deny[msg] {
  not input.tags.custo_centro
  msg := "Missing mandatory tag: custo_centro"
}
deny[msg] {
  not input.tags.ambiente
  msg := "Missing mandatory tag: ambiente"
}
deny[msg] {
  not input.tags.data_criacao
  msg := "Missing mandatory tag: data_criacao"
}
