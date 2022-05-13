#!/usr/bin/env python3

import os

servers = ['drive.google.com', 'mail.google.com', 'google.com']
i = 0

for host in servers:
    bash_command = f"ping -a -c 1 {host}"
    ping_host = os.popen(bash_command).read()
    ping_line = ping_host.split('\n')[1]
    host_ip = ping_line.split(' ')[4]
    host_line = host + '   -   ' + host_ip
    line = open('hosts_ip.txt').read().split('\n')[i]
    if host_line != line:
        print('изменение адреса сервера:\nбыл  ', line, '\nстал ', host_line)
        with open('hosts_ip.txt', 'rt') as f:
            x = f.read()
        with open('hosts_ip.txt', 'wt') as f:
            x = x.replace(line, host_line)
            f.write(x)
    else:
        print('адрес сервера ', host, ' не изменился и = ', host_ip)
    i = i + 1
