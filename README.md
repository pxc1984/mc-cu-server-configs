# MC ЦУ

- Для установки плагинов можно не юзать `download.sh`, достаточно

```bash
wget -nc -q --show-progress -i plugins.txt
```

- Скачивание конфигов с сервака

```bash
# Архив на сервере
ssh mc@144.31.2.224 "cd data/plugins && tar -czf /tmp/plugins-folders.tar.gz */"

# Скачиваем
scp mc@144.31.2.224:/tmp/plugins-folders.tar.gz .\plugins-folders.tar.gz

# Распаковка в папку плагинс
tar -xzf .\plugins-folders.tar.gz -C .\plugins

# Удаление на сервере
ssh mc@144.31.2.224 "rm -f /tmp/plugins-folders.tar.gz"
```