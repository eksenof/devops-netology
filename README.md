#Игнорировать:

**/.terraform/*
#все файлы внутри каталогов с названием .terraform, находящиеся на любой вложенности

*.tfstate
#все файлы оканчивающиеся на .tfstate

*.tfstate.*
#все файлы, содержащие в названии .tfstate.

crash.log
#конкретный файл логов с названием crash.log

*.tfvars
#все файлы заканчивающиеся на .tfvars

override.tf
override.tf.json
#два конкретных файла с названиями override.tf  и override.tf.json

*_override.tf
*_override.tf.json
#все файлы заканчивающиеся на _override.tf и _override.tf.json

.terraformrc
terraform.rc
# конкретные два файла с названиями .terraformrc (скрытый) и terraform.rc

#модификация для скрипта
