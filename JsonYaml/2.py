#!/usr/bin/env python3

import socket,json,yaml

change = False

with open('2.json', 'r') as f:
    text = json.load(f)
    for host in text:
        ip = text[host]
        host_ip = socket.gethostbyname(host)
        if host_ip != ip:
            print('изменение адреса сервера', host, ':\n', ' был  ', ip, '\n  стал ', host_ip)
            change = True
            text[host] = host_ip
        else:
            print('адрес сервера ', host, ' не изменился и =', ip)

if change:
    with open('2.json', 'w') as f:
        f.write(json.dumps(text))
    with open('2.yaml', 'w') as f:
        f.write(yaml.dump(text))
