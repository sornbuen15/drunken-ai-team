# System Design: Kakeibo Application (Phase 1)

## 1. Architecture Overview
The system follows a Client-Server model using Clean Architecture and Domain-Driven Design (DDD) principles.

### Frontend (Flutter)
- **Framework:** Flutter (Target: iOS, macOS, Web Browser).
- **Architecture:** Clean Architecture (Feature-first approach with Presentation, Domain, Data layers).
- **State Management:** Riverpod (or BLoC - ensure consistency).
- **Deployment:** AWS Amplify (for Flutter Web initial phase).

### Backend (Spring Boot Kotlin)
- **Language/Framework:** Kotlin + Spring Boot 3.x.
- **Architecture:** Clean Architecture / Hexagonal Architecture (Domain, Application, Infrastructure, Presentation).
- **Database:** PostgreSQL.
- **Containerization:** Docker (running via OrbStack).

---

## 2. Code Structure & Boundaries (STRICT)

### 2.1 Backend Structure (Spring Boot Kotlin)
The backend MUST strictly separate the Domain layer from all external frameworks (Spring, JPA, etc.).

```text
src/main/kotlin/com/kakeibo/
├── domain/                  # CORE: NO Spring or JPA dependencies allowed here.
│   ├── model/               # Entities (e.g., Ledger, Transaction), Value Objects, Enums (Category)
│   ├── exception/           # Domain-specific business exceptions
│   ├── event/               # Domain events (EDD)
│   └── repository/          # Interfaces for repositories (to be implemented by Infrastructure)
│
├── application/             # USE CASES: Orchestrates domain objects
│   ├── service/             # Application services implementing use cases
│   ├── port/                # Inbound/Outbound interfaces (if using Hexagonal)
│   └── dto/                 # Data Transfer Objects for Use Case inputs/outputs
│
├── infrastructure/          # IMPLEMENTATION: Database, external APIs, messaging
│   ├── persistence/         # JPA Entities, Spring Data Repositories, Flyway migrations
│   │   ├── entity/          # DB Entities (mapped to Domain Models)
│   │   └── adapter/         # Implementations of domain repository interfaces
│   └── observability/       # OpenTelemetry, Micrometer Tracing configurations
│
├── presentation/            # WEB: REST API Endpoints
│   ├── controller/          # REST Controllers
│   ├── dto/                 # Request/Response objects for APIs
│   └── exception/           # GlobalExceptionHandler (@RestControllerAdvice)
│
└── config/                  # Framework configurations (Security, Beans, CORS, MDC setup)
```

### 2.2 Frontend Structure (Flutter)
The frontend MUST follow a Feature-first Clean Architecture approach. Business logic MUST NOT be placed inside UI Widgets.

```text
lib/
├── core/                    # App-wide shared resources
│   ├── network/             # HTTP Client, Interceptors (MUST inject X-Correlation-ID)
│   ├── error/               # Failure classes, Exception handling
│   ├── theme/               # Muji-style minimalist themes, colors, typography
│   ├── utils/               # Constants, formatters
│   └── di/                  # Dependency Injection setup
│
├── features/                # Grouped by Feature
│   ├── ledger/              # Feature: Monthly Setup & Dashboard
│   │   ├── domain/          # Entities, Repositories (interfaces), Use Cases
│   │   ├── data/            # Models (DTOs), Repository (impl), Data Sources (Remote/Local)
│   │   └── presentation/    # Pages, Widgets, State Management (Providers/Bloc)
│   │
│   └── transaction/         # Feature: Expense Entry (4 Pillars)
│       ├── domain/
│       ├── data/
│       └── presentation/
│
└── main.dart                # Entry point, environment initialization
```

---

## 3. Domain Models (Core)
1. **Ledger:** Aggregate root for a specific month. (`id`, `month`, `year`, `income`, `savings_goal`, `available_budget`).
2. **Transaction:** Entities tied to a Ledger. (`id`, `ledger_id`, `amount`, `note`, `date`, `category`).
3. **Category:** Value Object / Enum (`SURVIVAL`, `OPTIONAL`, `CULTURE`, `EXTRA`).

---

## 4. Application Lifecycle & API Documentation
1. **Graceful Shutdown:** The Spring Boot application MUST be configured for graceful shutdown (server.shutdown=graceful) to ensure ongoing requests are completed before the application terminates.

2. **API Documentation:** Use Springdoc OpenAPI (Swagger UI) to automatically generate interactive API documentation. All endpoints must be properly annotated with descriptions and response codes.

## 5. Observability & Tracing
* Tracing: OpenTelemetry / Micrometer Tracing.

* Log Format: JSON format with injected identifiers.

* Every incoming HTTP request to the backend MUST generate or propagate a Trace-ID and Span-ID.

* Frontend MUST generate a unique X-Correlation-ID per user session/action and send it via HTTP Headers.

* Metrics: Actuator enabled, /actuator/prometheus endpoint exposed.

## 6. Local Development Environment
* OrbStack is used to run PostgreSQL and Backend containers natively on macOS.

* Local testing covers Chrome (Web), iOS Simulator, and macOS native build.


