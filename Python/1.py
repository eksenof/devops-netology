#!/usr/bin/env python3

import os

bash_command = ["cd ~/devops-netology", "pwd", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

result_path = result_os.split('\n')[0]

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        result_full_path = result_path + "/" + prepare_result
        print(result_full_path)
