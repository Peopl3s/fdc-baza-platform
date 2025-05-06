# fdc-baza-platform
Платформа для школы уличных танцев  FDC (Powered by PyLounge)

Цикл разработки

1. Создаётся фича-ветка от main, в которой происходит разработка нового функционала
2. Фича-ветка вливается в main
3. Когда необходим релиз, в релизную ветку вливаются изменения с определенного коммита в main.

Деплой в стейдж/прод происходит только из релизной ветки

------------------------------
```
├── README.md
├── alembic.ini
├── pyproject.toml
├── uv.lock
├── src/
│   ├── config.py   # Конфигурация
│   ├── main.py   # Инициализация приложения
│   │  
│   ├── core/     # Общие компоненты
│   │   ├── dependencies.py   # DI
│   │   ├── exceptions.py   # Кастомные исключения
│   │   ├── logging.py   # Логирование
│   │   └── utils.py   # Вспомогательные функции
│   │  
│   ├── application/   # Слой приложения
│   │   └── users/
│   │       ├── dto/   # Data Transfer Objects
│   │       │   └── user_dto.py
│   │       ├── use_cases/   # Юзкейсы
│   │       │   └── user_use_cases.py
│   │       ├── exceptions.py   # Кастомные исключения приложения
│   │       └── validators.py   # Валидаторы
│   │  
│   ├── domain/   # Ядро бизнес-логики
│   │   └── users/
│   │       ├── entities/   # Сущности и VO
│   │       │   └── user.py
│   │       ├── repositories/   # Интерфейсы репозиториев (абстракции)
│   │       │   └── user_repository.py
│   │       └── services/   # Доменные сервисы
│   │           └── user_service.py
│   │  
│   ├── infrastructure/   # Внешние детали (реализации)
│   │   └── db/
│   │       ├── models/   # ORM-модели (SQLAlchemy, Prisma и т.д.)
│   │       │   └── user_model.py
│   │       ├── repositories/   # Реализации репозиториев
│   │       │   └── user_repository_impl.py
│   │       ├── base.py   # Базовый Base, например, от SQLAlchemy
│   │       └── session.py   # Создание и управление сессиями
│   │  
│   ├── presentation/   # Слой представления (API, CLI и т.д.)
│   │   └── api/   # API
│   │       └── v1/
│   │           ├── exeptions.py   # Исключений API
│   │           ├── routers.py     # Роутеры Litestar
│   │           ├── controllers/   # REST-контроллеры
│   │           │   └── user_controller.py
│   │           └── schemas/   # Pydantic схемы (валидация запросов/ответов)
│   │               └── user_schema.py
│   │  
│   └── tests/   # Тесты
│       ├── conftest.py
│       ├── fixtures/
│       ├── integration/
│       │   ├── api/
│       │   └── database/
│       └── unit/
│           ├── domain/
│           └── use_case/

```
