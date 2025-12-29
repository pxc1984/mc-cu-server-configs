#!/bin/bash

echo "📦 Скачивание плагинов..."
echo ""

count=0
skipped=0
downloaded=0

while read -r url; do
    [[ -z "$url" || "$url" =~ ^# ]] && continue
    
    ((count++))
    filename=$(basename "$url")
    
    # Проверяем существование файла
    if [ -f "$filename" ]; then
        echo "[$count] ⏭️  Пропускаю: $filename (уже существует)"
        ((skipped++))
    else
        echo "[$count] 📥 Скачиваю: $filename"
        wget -q --show-progress "$url" -O "$filename"
        
        if [ $? -eq 0 ]; then
            echo "    ✅ Готово"
            ((downloaded++))
        else
            echo "    ❌ Ошибка"
        fi
    fi
    echo ""
done < plugins.txt

echo "================================"
echo "📊 Итого:"
echo "   Пропущено: $skipped"
echo "   Скачано:   $downloaded"
echo "✅ Готово!"