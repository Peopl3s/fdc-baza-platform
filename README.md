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
│   ├── domain/                # Ядро бизнес-логики (чистый слой)
│   │   ├── models/            # Сущности и Value Objects
│   │   │   └── user.py        # Пример: User entity
│   │   ├── repositories/      # Интерфейсы репозиториев (абстракции)
│   │   │   └── user_repository.py
│   │   └── services/         # Доменные сервисы
│   │       └── user_service.py
│   │
│   ├── application/          # Слой приложения (use cases)
│   │   ├── dto/              # Data Transfer Objects
│   │   │   └── user_dto.py
│   │   ├── use_cases/        # Юзкейсы
│   │   │   └── user_use_cases.py
│   │   └── exceptions.py     # Кастомные исключения приложения
│   │
│   ├── infrastructure/        # Внешние детали (реализации)
│   │   ├── db/               # Работа с БД
│   │   │   ├── models/       # ORM-модели (SQLAlchemy, Prisma и т.д.)
│   │   │   │   └── user_model.py
│   │   │   ├── repositories/ # Реализации репозиториев
│   │   │   │   └── user_repository_impl.py
│   │   │   └── database.py   # Инициализация подключения к БД
│   │   │
│   │   ├── config/           # Конфигурация приложения
│   │   │   └── settings.py
│   │   └── logging/          # Логирование (если нужно)
│   │
│   ├── presentation/          # Слой представления (API, CLI и т.д.)
│   │   ├── api/              # REST/gRPC контроллеры
│   │   │   ├── controllers/
│   │   │   │   └── user_controller.py
│   │   │   ├── routers.py    # Роутеры Litestar
│   │   │   └── exceptions.py # Обработчики исключений API
│   │   └── schemas/          # Pydantic-схемы для запросов/ответов
│   │       └── user_schema.py
│   │
│   └── main.py               # Точка входа (создание приложения Litestar)
│
├── tests/                    # Тесты (можно зеркалить структуру src)
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── pyproject.toml            # Зависимости и настройки проекта
└── README.md
```

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

### Пример кода:
#### `domain/models/user.py`
```python
from dataclasses import dataclass

@dataclass
class User:
    id: int | None
    email: str
    is_active: bool
```

#### `application/use_cases/user_use_cases.py`
```python
from domain.repositories.user_repository import UserRepository
from domain.models.user import User

class UserUseCases:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    async def get_user(self, user_id: int) -> User:
        return await self.user_repo.get_by_id(user_id)
```

#### `presentation/api/controllers/user_controller.py`
```python
from litestar import Controller, get
from application.use_cases.user_use_cases import UserUseCases
from presentation.schemas.user_schema import UserSchema

class UserController(Controller):
    path = "/users"

    @get(path="/{user_id:int}")
    async def get_user(self, user_id: int, use_cases: UserUseCases) -> UserSchema:
        user = await use_cases.get_user(user_id)
        return UserSchema.from_domain(user)
```

#### `main.py`
```python
from litestar import Litestar
from infrastructure.db.database import db_config
from presentation.api.routers import user_router

app = Litestar(
    route_handlers=[user_router],
    dependencies={"db_config": db_config}
)
```

### Ключевые моменты:
- **Инверсия зависимостей**: `domain` не знает о других слоях.
- **Инъекция зависимостей**: Litestar DI внедряет реализации (например, репозитории) в use cases.
- **Тестируемость**: Можно легко мокировать репозитории в тестах.
