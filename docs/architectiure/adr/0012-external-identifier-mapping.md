# ADR-012: Introduce a Centralized External Identifier Mapping Layer

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS aims to provide global football coverage through external football data providers.

Potential providers may include:

- Opta.
- Sportradar.
- API-Football.
- Other licensed football information services.

Each provider may maintain its own identifiers, naming conventions, data structures and entity relationships.

The same football entity may be represented differently across providers.

For example, a player may have different names or identifiers depending on the source.

Directly using external identifiers as Football OS primary keys would create unnecessary dependency on third-party systems.

We therefore require a centralized mapping layer.

## 2. Decision

We will introduce a centralized ExternalIdentifier entity.

The model will associate provider-specific identifiers with canonical Football OS entities.

The internal Football OS entity will remain the authoritative identifier within our domain.

The mapping layer will support different entity types, including:

- Clubs.
- Players.
- Competitions.
- Seasons.
- Matches.
- Stadiums.
- Other approved football entities.

## 3. Proposed Data Structure

### DataProvider

Represents an external data provider.

Attributes:

- ID.
- Name.
- Provider code.
- Status.
- Configuration.
- Created date.

### ExternalIdentifier

Represents the relationship between an external provider identifier and an internal Football OS entity.

Attributes:

- ID.
- Provider.
- Entity type.
- External identifier.
- Internal entity reference.
- Created date.
- Updated date.

## 4. Uniqueness Requirements

We will enforce a composite unique constraint on:

    (provider_id, entity_type, external_id)

This prevents the same provider identifier from being assigned more than once for the same entity type.

The entity type is included because providers may reuse identifiers across different resource categories.

## 5. Canonical Entity Strategy

Football OS will maintain its own internal canonical records.

For example:

    Football OS Player
           |
           |-----------------------|
           |                       |
        Opta ID                Sportradar ID
        12345                  98765

External provider names and identifiers will not dictate internal entity names or primary keys.

The integration layer will normalize incoming records before passing them to domain services.

## 6. Alternatives Considered

### Use Provider IDs as Primary Keys

Rejected because provider replacement would become difficult and internal records would depend on external systems.

### Store Provider IDs Directly on Every Domain Model

Rejected because it creates repeated provider-specific fields and limits support for multiple providers.

### Separate Mapping Models for Every Entity Type

Not selected as the initial approach because a centralized mapping abstraction provides more consistent integration management.

However, referential integrity must be considered carefully.

A generic polymorphic mapping must not sacrifice database integrity without justification.

## 7. Consequences

### Positive

- Provider independence.
- Support for multiple integrations.
- Improved entity reconciliation.
- Reduced duplicate records.
- Easier provider migration.
- Better data provenance.

### Negative

- Additional mapping records.
- Entity reconciliation complexity.
- Potential mapping conflicts.
- Requires clear internal entity ownership.
- Generic relationships require careful integrity management.

## 8. Data Governance and Security

- Protect provider API credentials.
- Respect data licensing agreements.
- Record source provenance.
- Validate incoming identifiers.
- Monitor synchronization failures.
- Avoid distributing restricted provider information.
- Establish conflict-resolution rules for inconsistent provider records.

## 9. Future Considerations

A provider-priority strategy may be introduced to determine which source is authoritative for specific information.

The system may also support confidence scoring and manual reconciliation workflows.

## 10. Related Decisions

- ADR-005: Provider-Independent Football Data Integration.
- ADR-002: PostgreSQL Database.
- ADR-006: Background Processing.
- ADR-011: Database-Level Integrity Constraints.
