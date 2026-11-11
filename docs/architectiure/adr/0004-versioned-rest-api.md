
## 5. `0004-versioned-rest-api.md`

```markdown
# ADR-004: Adopt a Versioned REST API Architecture

**Status:** Proposed  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will initially use Flutter as its mobile client.

Future clients may include web applications, administrative dashboards and external organisational integrations.

We therefore require a consistent backend communication interface independent of any specific client technology.

The API must support authentication, validation, permissions, documentation and controlled evolution.

## 2. Decision

We will implement a RESTful API using Django REST Framework.

API endpoints will use explicit versioning.

Initial base path:

```text
/api/v1/
