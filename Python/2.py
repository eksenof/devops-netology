#!/usr/bin/env python3

import os,time

print('write repository root folder path')
path = input()

bash_command_path = [f"cd {path}", "ls -a"]
list_of_files = os.popen(' && '.join(bash_command_path)).read()

git_repo = False

for result in list_of_files.split('  '):
    if result.find('.git') != -1:
        git_repo = True

if not git_repo:
    print('folder is not a root git repository')
    quit()

bash_command = [f"cd {path}", "pwd", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

result_path = result_os.split('\n')[0]

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        result_full_path = "file was modified:   " + path + "/" + prepare_result
        print(result_full_path)
