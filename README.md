# reforma360
lib/
├── src/
│   ├── core/                  # Elements compartits
│   │   ├── constants/         # Constants globals
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_styles.dart
│   │   │
│   │   ├── errors/            # Gestió d'errors
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart  
│   │   │
│   │   ├── routes/            # Configuració de navegació
│   │   │   ├── app_router.dart  # GoRouter configuration
│   │   │   └── route_names.dart
│   │   │
│   │   ├── utils/             # Funcions auxiliars
│   │   │   ├── validators.dart # Validacions de formularis
│   │   │   └── extensions.dart # Extension methods
│   │   │
│   │   └── providers/         # Providers globals
│   │       ├── theme_provider.dart
│   │       └── auth_state.dart # Estat d'autenticació global
│   │
│   ├── data/                  # Capa de Dades
│   │   ├── datasources/       # Fonts de dades
│   │   │   ├── remote/        # Firebase/API
│   │   │   │   ├── auth_remote_ds.dart
│   │   │   │   └── project_remote_ds.dart
│   │   │   │
│   │   │   └── local/         # SharedPreferences/Hive
│   │   │       └── cache_datasource.dart
│   │   │
│   │   ├── models/            # Models de dades (DTOs)
│   │   │   ├── auth/          # Organitzat per funcionalitat
│   │   │   │   ├── user_model.dart
│   │   │   │   └── login_response.dart
│   │   │   │
│   │   │   └── project/
│   │   │       └── project_model.dart
│   │   │
│   │   ├── repositories/      # Implementacions concretes
│   │   │   ├── auth_repository_impl.dart
│   │   │   └── project_repository_impl.dart
│   │   │
│   │   └── mappers/           # Conversió DTO ↔ Entitat
│   │       ├── auth_mapper.dart
│   │       └── project_mapper.dart
│   │
│   ├── domain/                # Capa de Domini
│   │   ├── entities/          # Entitats de negoci
│   │   │   ├── user_entity.dart
│   │   │   └── project_entity.dart
│   │   │
│   │   ├── repositories/      # Interfícies abstractes
│   │   │   ├── auth_repository.dart
│   │   │   └── project_repository.dart
│   │   │
│   │   ├── usecases/          # Casos d'ús
│   │   │   ├── auth/
│   │   │   │   ├── login_user.dart
│   │   │   │   └── register_user.dart
│   │   │   │
│   │   │   └── project/
│   │   │       ├── create_project.dart
│   │   │       └── get_projects.dart
│   │   │
│   │   └── notifications/     # Lògica de notificacions
│   │       └── notify_changes.dart
│   │
│   └── presentation/          # Capa de Presentació
│       ├── pages/             # Pantalles
│       │   ├── auth/
│       │   │   ├── login_page.dart
│       │   │   └── register_page.dart
│       │   │
│       │   ├── project/
│       │   │   ├── project_list_page.dart
│       │   │   └── project_detail_page.dart
│       │   │
│       │   └── profile/
│       │       └── profile_page.dart
│       │
│       ├── widgets/           # Components reutilitzables
│       │   ├── auth/
│       │   │   └── auth_form.dart
│       │   │
│       │   ├── project/
│       │   │   └── project_card.dart
│       │   │
│       │   └── shared/
│       │       ├── custom_app_bar.dart
│       │       └── loading_indicator.dart
│       │
│       ├── providers/         # Providers d'estat UI
│       │   ├── auth/
│       │   │   └── auth_provider.dart
│       │   │
│       │   └── project/
│       │       └── project_provider.dart
│       │
│       ├── theme/             # Estils i temes
│       │   ├── app_theme.dart
│       │   └── text_styles.dart
│       │
│       └── cubits/            # Alternativa a Riverpod si s'usa
│           └── auth_cubit.dart
│
├── firebase_options.dart      # Configuració de Firebase
└── main.dart                  # Punt d'entrada