Этот плейбук скачивает установочные пакеты java, elasticsearch и kibana, проверяет установлены ли они и устанавливает в случае если нет. Java устанавливается на все хосты, elasticsearch и kibana на соответствующие.   
   
целевые хосты для установки elasticsearch и kibana описаны в файле inventory/prod.yml   
   
необходимые версии пакетов указаны в:
- elastic_version в файле /group_vars/elasticsearch/vars.yml,
- kibana_version в файле /group_vars/kibana/vars.yml,
- java_jdk_version в файле /group_vars/all/vars.yml
   
в файле site.yml описаны три плея: установка Java, установка Elasticsearch, установка Kibana   
   
теги:
- java
- elastic
- kibana