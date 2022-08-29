resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "nle" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/nle/nle.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}


resource "null_resource" "mySQL" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/mySQL/mySQL.yml"
  }

 depends_on = [
    null_resource.nle
  ]
}

resource "null_resource" "wordpress" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/wordpress/wordpress.yml"
  }

 depends_on = [
    null_resource.mySQL
  ]
}


resource "null_resource" "gitlab" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/gitlab/gitlab.yml"
  }

 depends_on = [
    null_resource.wordpress
  ]
}

resource "null_resource" "monitoring" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/monitoring/monitoring.yml"
  }

 depends_on = [
    null_resource.gitlab
  ]
}

resource "null_resource" "node_ex" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml ../ansible/node_ex/node_ex.yml"
  }

 depends_on = [
    null_resource.monitoring
  ]
}
