#!/usr/bin/env python3

import socket

change = False
d = {}
f = open('hosts_ip.txt', 'rt')

for line in f:
    host,value = line.strip().split('   -   ')
    d[host] = value
    host_ip=socket.gethostbyname(host)
    host_line = host + '   -   ' + host_ip
    if (host_line + '\n') != line:
        print('изменение адреса сервера:\n был  ', line, 'стал ', host_line)
        change = True
        d[host] = host_ip
    else:
        print('адрес сервера ', host, ' не изменился и = ', host_ip)

if change:
    with open('hosts_ip.txt', 'wt') as f:
        for host in d:
            print(f'{host}   -   {d[host]}', file=f)

f.close
