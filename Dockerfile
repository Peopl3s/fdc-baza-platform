# Этап сборки зависимостей
FROM python:3.13.3-bookworm as builder

WORKDIR /app

# Копируем только файлы, необходимые для установки зависимостей
COPY pyproject.toml uv.lock ./

# Устанавливаем uv и зависимости
RUN pip install --no-cache-dir uv && \
    uv pip install --system --no-cache -r pyproject.toml


# Финальный этап
FROM python:3.13.3-bookworm

WORKDIR /app

# Копируем зависимости из builder-этапа
COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin/granian /usr/local/bin/granian

# Копируем конфигурационные файлы отдельно для лучшего кеширования
COPY ../alembic.ini ./src/

# Копируем исходный код (шаблоны копируем отдельно для лучшего кеширования)
COPY src/templates/ ./templates/
COPY src/ ./src/

# Указываем рабочую директорию для приложения
WORKDIR /app/src
