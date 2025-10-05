data "azuread_domains" "aad" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.aad.domains.0.domain_name
  users = csvdecode(file("${path.module}/users.csv"))
}

resource "azuread_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  user_principal_name = format(
    "%s%s@%s",
    lower(substr(each.value.first_name, 0, 1)),
    lower(each.value.last_name),
    local.domain_name,
  )

  mail_nickname = lower(format("%s.%s", each.value.first_name, each.value.last_name))

  password = format(
    "%s%s%s!",
    lower(each.value.last_name),
    lower(substr(each.value.first_name, 0, 1)),
    length(each.value.first_name),
  )

  display_name = format("%s %s", each.value.first_name, each.value.last_name)

  force_password_change = true
  department = each.value.department
  job_title = each.value.job_title
}
 


output "domain_name" {
    value = local.domain_name
}

output "users" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}"]
}

