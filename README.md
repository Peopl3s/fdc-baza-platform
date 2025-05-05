# fdc-baza-platform
Платформа для школы уличных танцев  FDC (Powered by PyLounge)

Цикл разработки

1. Создаётся фича-ветка от main, в которой происходит разработка нового функционала
2. Фича-ветка вливается в main
3. Когда необходим релиз, в релизную ветку вливаются изменения с определенного коммита в main.

Деплой в стейдж/прод происходит только из релизной ветки

------------------------------
```
project/
├── src/
│   ├── core/                  # Общие компоненты ядра
│   │   ├── exceptions.py
│   │   ├── dependencies.py
│   │   ├── middlewares.py
│   │   └── logging.py
│   │
│   ├── users/                 # Модуль Users
│   │   ├── domain/            # Ядро бизнес-логики Users (чистый слой)
│   │   │   ├── entities/      # Сущности и VO
│   │   │   │   └── user.py
│   │   │   ├── repositories/  # Интерфейсы репозиториев (абстракции)
│   │   │   │   └── user_repository.py
│   │   │   └── services/     # Доменные сервисы
│   │   │       └── user_service.py
│   │   │
│   │   ├── application/       # Слой приложения
│   │   │     ├── dto/              # Data Transfer Objects
│   │   │     │   └── user_dto.py
│   │   │     ├── use_cases/        # Юзкейсы
│   │   │     │   └── user_use_cases.py
│   │   │     └── exceptions.py     # Кастомные исключения приложения
│   │   │
│   │   ├── infrastructure/     # Внешние детали (реализации) Users
│   │   │   ├── models/       # ORM-модели (SQLAlchemy, Prisma и т.д.)
│   │   │   │   └── user_model.py
│   │   │   ├── repositories/ # Реализации репозиториев
│   │   │       └── user_repository_impl.py
│   │   │
│   │   └── presentation/             # Слой представления (API, CLI и т.д.) Users
│   │       ├── api/                  # REST/gRPC контроллеры
│   │       │   ├── controllers/
│   │       │   │   ├── user_controller.py
│   │       │   └── routers.py        # Роутеры Litestar
│   │       │   └── exceptions.py     # Обработчики исключений API
│   │       ├── schemas/              # Pydantic-схемы для запросов/ответов
│   │          └── user_schema.py
│   │
│   ├── companies/             # Аналогичная структура для Companies
│   ├── items/                 # Аналогичная структура для Items
│   │
│   ├── infrastructure/        # Общая инфраструктура
│   │   ├── db/
│   │   └──  config/
│   │
│   └── main.py               # Инициализация приложения
│   └── settings.py           # Настройки
│
├── tests/
│   ├── users/                # Тесты для модуля Users
│   ├── companies/            # Тесты для Companies
│   └── ...
│
├── pyproject.toml
└── README.md
```

Ключевые изменения:

1. **Доменно-ориентированная организация**:
   - Каждый бизнес-домен (users, companies, items) имеет свою собственную структуру с полным циклом зависимостей (от domain до presentation)

2. **Четкие границы модулей**:
   - Модули зависят только от core и infrastructure
   - Зависимости между модулями только через интерфейсы

3. **Общая инфраструктура**:
   - Общие технические компоненты (БД, конфиг, аутентификация) вынесены в общий infrastructure

4. **Тестирование**:
   - Тесты зеркалят структуру модулей

Пример зависимостей для модуля Users:
```
presentation → application → domain
application ← infrastructure (реализации репозиториев)
```

Для добавления нового модуля (например, `products`):
1. Создаете папку `products` с той же структурой
2. Регистрируете его роутеры в main.py
3. Добавляете тесты в `tests/products/`****

### Пояснения:
1. **Domain**:
   - Содержит **сущности** (User), **интерфейсы репозиториев** (UserRepository) и **доменные сервисы**.
   - Не зависит от других слоёв.

2. **Application**:
   - **Use Cases** — бизнес-правила уровня приложения.
   - **DTO** — объекты для передачи данных между слоями.
   - Зависит только от `domain`.

3. **Infrastructure**:
   - Реализации репозиториев (например, `UserRepositoryImpl` для PostgreSQL).
   - ORM-модели, настройки БД, внешние API.
   - Зависит от `domain` и `application`.

4. **Presentation**:
   - Контроллеры Litestar, роутеры, Pydantic-схемы.
   - Зависит от `application`, но не от `infrastructure`.
