# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

### Ответ
чтобы вычислить проблемные запросы используем вызов mongo-shell:
[db.currentOp()](https://www.mongodb.com/docs/v5.0/reference/method/db.currentOp/)
в списке вывода ищем выполняемый запрос, его номер и делаем остановку запроса:
[db.killOp()](https://www.mongodb.com/docs/manual/reference/method/db.killOp/)

Нужно в любом случае искать узкое место - почему долгие запросы.
- железо. возможно не хватает ресурсов, старые жесткие диски, мало оперативки, слабые процы
- система. возможно загружена сама ос. другими процессами, заняты кэши-свопы
- сама бд. структуры таблиц и взаимосвязей. правильное индексирование может сильно помочь. сами запросы посмотреть как написаны.


## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

### Ответ
- рост отношения записанных значений к истекшим означает, что система не успевает обработать заявки
- Redis блокирует операции записи - может означать нехватку физического места на дисках, нехватку оперативной памяти или какого-то кэша/свопа, что коррелируется с предыдущим симптомом (не успевает обработать заявки) 


## Задача 3

Перед выполнением задания познакомьтесь с документацией по [Common Mysql errors](https://dev.mysql.com/doc/refman/8.0/en/common-errors.html).

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?
Какие пути решения данной проблемы вы можете предложить?

### Ответ
- возможны проблемы с сетью (провайдер, сетевая карта, внутреннее корпоративное сетевое оборудование, возможна петля в сети - часть запросов будут проходить, часть нет ) - можно использовать дублирование портов, использовать второго провайдера для балансировки нагрузки   
- на стороне бд возможно нужно проверить/увеличить параметр [net_read_timeout](https://dev.mysql.com/doc/refman/5.7/en/error-lost-connection.html) - не хватает времени на передвачу данных, если запрос большой
- также посмотреть параметры connection_timeout, max_connection


## Задача 4

Перед выполнением задания ознакомтесь со статьей [Common PostgreSQL errors](https://www.percona.com/blog/2020/06/05/10-common-postgresql-errors/) из блога Percona.

Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?
Как бы вы решили данную проблему?

### Ответ
сообщение означает, что не хватает памяти и система убивает занимающий память процесс postgresql. проще всего добавить оперативки или жестко разграничить потребление памяти бд и системой, чтобы бд не занимала всю память у системы и давала ей нормально работать