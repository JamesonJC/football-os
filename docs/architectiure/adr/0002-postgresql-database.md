
## 3. `0002-postgresql-database.md`

```markdown
# ADR-002: Use PostgreSQL as the Primary Database

**Status:** Proposed  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS requires a reliable relational database capable of managing complex relationships between users, organisations, clubs, players, competitions, seasons, matches and other business entities.

The system will also support reporting, analytics, transactional operations and organisation-specific data.

Data integrity and consistency are essential because multiple modules will depend on shared football and organisational records.

## 2. Decision

We will use PostgreSQL as the primary relational database.

Django ORM will provide the initial database abstraction and migration management.

Database design will follow established relational modelling principles, including:

- Primary keys.
- Foreign keys.
- Unique constraints.
- Check constraints.
- Appropriate indexes.
- Referential integrity.
- Transaction management.
- Normalization where appropriate.

We will use UUID primary keys where appropriate for externally exposed or distributed identifiers, while considering indexing and operational trade-offs.

## 3. Alternatives Considered

### MySQL

A capable relational database, but PostgreSQL is selected as our preferred platform for this project.

### SQLite

Suitable for lightweight local development and testing, but not selected as the primary production database.

### MongoDB

Not selected as the primary database because our core domain contains strongly relational entities and transactional requirements.

Document-oriented storage may be considered for specific future use cases.

## 4. Consequences

### Positive

- Strong relational integrity.
- Transactional consistency.
- Advanced indexing capabilities.
- JSONB support for appropriate semi-structured data.
- Full-text search capabilities.
- Strong Django integration.
- Suitable foundations for reporting and analytics.

### Negative

- Requires database administration and maintenance.
- Poor indexing and query design can affect performance.
- Schema changes require controlled migrations.
- Connection management becomes important as concurrency grows.

## 5. Security and Operational Considerations

- Use environment-based database credentials.
- Restrict database access.
- Use encrypted connections in production.
- Configure regular backups.
- Test database restoration procedures.
- Monitor slow queries.
- Apply database migrations through controlled deployment processes.
- Avoid storing unnecessary personal information.

## 6. Related Decisions

- ADR-001: Modular Monolith Architecture.
- ADR-003: Multi-Tenancy Strategy.
