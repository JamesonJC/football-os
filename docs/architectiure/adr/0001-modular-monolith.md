# ADR-001: Adopt a Modular Monolith Architecture

**Status:** Proposed  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS is intended to become a comprehensive football intelligence platform serving individual supporters and football organisations.

The platform will contain multiple business domains, including:

- Identity and access management.
- Organisation management.
- Football data management.
- Competitions and matches.
- Community management.
- Workflows and events.
- Notifications.
- Analytics.
- AI intelligence.
- External integrations.

These domains have different responsibilities but must interact to deliver integrated product functionality.

The project has an initial development deadline of 14 days. Introducing distributed microservices immediately would increase deployment complexity, infrastructure requirements, network communication overhead and operational responsibilities.

However, implementing everything as one tightly coupled application would create long-term maintainability problems.

We therefore require an architecture that balances delivery speed with modularity and future extensibility.

## 2. Decision

We will adopt a **Modular Monolith Architecture** using Django and Django REST Framework.

The backend will initially operate as one deployable application while maintaining clearly separated domain modules.

Each module will have:

- Defined responsibilities.
- Explicit business rules.
- Controlled access to its data.
- Application services for business operations.
- Defined interfaces for communication with other modules.
- Independent unit and integration tests.

Cross-module communication should occur through defined service interfaces or application-level contracts rather than unrestricted access to internal implementation details.

## 3. Proposed Structure

```text
backend/
├── config/
├── apps/
│   ├── identity/
│   ├── organisations/
│   ├── football/
│   ├── competitions/
│   ├── matches/
│   ├── community/
│   ├── workflows/
│   ├── notifications/
│   ├── analytics/
│   ├── integrations/
│   └── ai_intelligence/
├── shared/
├── tests/
└── manage.py
