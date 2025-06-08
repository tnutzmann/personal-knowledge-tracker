# personal-knowledge-tracker
learning Project

## Data-Flow
```
                                     ┌────────────────────────────┐
                                     │       Keycloak (Auth)      │
                                     │  - User login & JWT token  │
                                     └────────────┬───────────────┘
                                                  │
                                ┌─────────────────▼────────────────┐
                                │     Frontend (Vue.js SPA)        │
                                │ - User input & dashboards        │
                                │ - OAuth2 login via Keycloak      │
                                └────────────┬─────────────────────┘
                                             │
                        ┌────────────────────▼────────────────────┐
                        │         Backend API (Spring Boot)       │
                        │ - Secured REST API                      │
                        │ - Stores/reads from PostgreSQL          │
                        │ - Sends events to RabbitMQ              │
                        └────┬───────────────┬────────────────────┘
                             │               │
               ┌─────────────▼───┐     ┌─────▼────────────┐
               │ PostgreSQL DB   │     │  RabbitMQ (MQ)   │
               │ - Journals      │     │ - journal.enrich │
               │ - Bookmarks     │     │ - activity.log   │
               └─────────────────┘     └───────┬──────────┘
                                               │
                           ┌───────────────────▼────────────────────┐
                           │      Python Enrichment Service         │
                           │ - NLP: sentiment, keyword, summary     │
                           │ - Subscribes to RabbitMQ               │
                           │ - Returns enriched data via API or MQ  │
                           └────────────────▲───────────────────────┘
                                            │
                                ┌───────────┴─────────────┐
                                │        Apache NiFi      │
                                │ - Data ingestion flows  │
                                │ - GitHub / RSS fetchers │
                                │ - Routes to DB or MQ    │
                                └───────────┬─────────────┘
                                            │
                           ┌────────────────▼─────────────┐
                           │ External Sources (APIs, RSS) │
                           │ - GitHub, Pocket, Markdown   │
                           │ - Calendar, Twitter, etc.    │
                           └──────────────────────────────┘

```
1. User logs in → Keycloak issues JWT → used by Frontend & Backend
2. User submits data (e.g. journal entry) → Vue frontend → Spring Boot API
3. Spring Boot writes to PostgreSQL and optionally sends a message to RabbitMQ
4. RabbitMQ queues journal for enrichment
5. Python NLP service consumes the message, analyzes it, sends enriched result back
6. NiFi runs periodic ingestion tasks:
  - RSS feeds, GitHub activity, file drops, etc.
  - It routes and transforms data, pushing to:
    - PostgreSQL (via JDBC or API)
    - RabbitMQ (to trigger enrichment)