# ADR-009: Adopt a Hybrid Global and Organisation-Specific Authorization Model

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will serve individual supporters and multiple football organisations.

Users may have different responsibilities depending on their relationship with the platform and the organisations they belong to.

For example, one user may simultaneously be:

- A regular global platform subscriber.
- An analyst at Manchester United.
- A coach at a separate football academy.

A single global role system cannot adequately represent these different organisational relationships.

Likewise, organisation-specific roles should not determine access to global platform administration capabilities.

We therefore require a hybrid authorization architecture.

## 2. Decision

We will implement a two-layer authorization model, with subscription entitlements handled as a separate third concern.

### Layer 1: Global Authorization

Django Groups and Permissions will manage global platform roles and permissions.

Examples include:

- Super Administrator.
- Global Data Operator.
- Platform Moderator.
- Support Administrator.

Global permissions will govern access to platform-wide administrative capabilities.

### Layer 2: Organisation-Specific Authorization

The OrganisationMembership entity will connect users to organisations.

Each membership will contain an organisation-specific role.

Initial roles will include:

- Owner.
- Administrator.
- Analyst.
- Coach.
- Scout.
- Player.
- Staff.

Organisation roles will determine what a user can do within a particular organisation.

A user's membership in one organisation must not automatically grant access to another organisation.

### Layer 3: Commercial Entitlements

Subscription plans and entitlements will manage access to paid product capabilities.

Examples include:

- Advanced football analytics.
- Enhanced notifications.
- Premium AI functionality.
- Additional organisation features.

Subscription status will not automatically grant organisational authorization.

## 3. Proposed Relationship

    User
     |
     |-----------------------------|
     |                             |
    Global Groups             OrganisationMembership
     |                             |
    Global Permissions        Organisation
                                   |
                              OrganisationRole
                                   |
                              Scoped Permissions

    User
     |
    Subscription
     |
    SubscriptionPlan
     |
    Entitlements

## 4. Authorization Principles

- Authentication establishes user identity.
- Authorization determines what the user may access.
- Global permissions apply at platform level.
- Organisation permissions apply within an organisation.
- Subscription entitlements determine access to commercial features.
- All sensitive operations must be authorized by the backend.

The Flutter application may hide unavailable functionality for usability, but it must never be responsible for enforcing security.

## 5. Alternatives Considered

### Global Roles Only

Rejected because a global role cannot adequately represent a user's different responsibilities across multiple organisations.

### Organisation Roles Only

Rejected because platform-wide administrative responsibilities require separate authorization.

### Subscription-Based Authorization

Rejected because commercial entitlement and security permission are different concepts.

## 6. Consequences

### Positive

- Supports diverse user categories.
- Allows users to belong to multiple organisations.
- Separates platform administration from organisation administration.
- Supports flexible enterprise permissions.
- Supports future commercial subscription tiers.
- Reduces the risk of excessive global privileges.

### Negative

- Requires multiple authorization checks.
- Increases permission-management complexity.
- Requires clear precedence and conflict-resolution rules.
- Requires comprehensive authorization testing.

## 7. Security Considerations

- Apply least-privilege principles.
- Verify active organisation membership.
- Verify the required organisation role and permission.
- Never trust organisation identifiers supplied by the client.
- Prevent cross-organisation privilege escalation.
- Audit sensitive administrative operations.
- Test both allowed and denied access scenarios.

## 8. Future Considerations

A more granular permission registry may be introduced when organisations require configurable role definitions.

## 9. Related Decisions

- ADR-003: Shared-Database Multi-Tenancy.
- ADR-008: Custom Django User Model.
- ADR-014: Organisation Data Isolation.
- ADR-015: Subscription and Entitlement Management.
