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

# Подключение к БД (mysql)

Креды:
```.env
IP=mysql:3306
USERNAME=mccu
DATABASE=mccu
PASSWORD=см. docker-compose.yml
```

Плагины юзают:
- AuthMe
- BedWars
- CoreProtect
- LuckPerms
- SCore
- SkinsRestorer

# Миры и бедварс

Не выгодно держать все миры в корне - поэтому создаём симлинки:
- `create_links.sh` запущенный в `data` с `worlds.txt` создаст симлинки перечисленных папок в `data`
- `delete_links.sh` запущенный в `data` с `worlds.txt` удалит симлинки перечисленных папок в `data`

Usage (находясь в `data/`, по умолчанию папка с мирами - `bedwars_worlds`):
```bash
create_links.sh worlds.txt

# Или так
create_links.sh worlds.txt ./bedwars_worlds # <- типо передаём откуда брать папки с мирами
```

**ВАЖНО:** после создания арен / дополнительных миров, их нужно перенести в гитхаб:
- `plugins/BedWars/arenas/*`
- `plugins/Multiverse-Core/worlds.yml` 


## Плагины (не в `plugins.txt`)
- Vault
- OldCombatMechanics