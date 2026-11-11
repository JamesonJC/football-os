# ADR-003: Adopt Shared-Database Multi-Tenancy

**Status:** Proposed  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will serve individual supporters and football organisations.

Multiple organisations may use the platform simultaneously.

Examples include football clubs, academies and other football organisations.

Organisations may manage their own users, operational activities, workflows, reports and internal information.

The system must prevent unauthorised access to one organisation's data by users belonging to another organisation.

At the same time, global football information such as clubs, competitions, players and public match records should be reusable across the platform.

## 2. Decision

We will adopt a shared PostgreSQL database with logical tenant isolation.

Organisation-specific records will be associated with an organisation identifier.

The system will distinguish between:

1. Global platform data.
2. Individual user data.
3. Organisation-owned data.

An organisation membership model will connect users to organisations and define their organisational roles.

Example:

```text
User
  |
  | many-to-many through
  |
OrganisationMembership
  |
  |
Organisation
