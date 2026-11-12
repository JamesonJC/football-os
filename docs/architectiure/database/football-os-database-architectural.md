
# Football OS — Database Architecture Blueprint

**Document ID:** FO-DB-001  
**Version:** 1.0.0-draft  
**Status:** In Progress  
**Project:** Football OS  
**Architecture Style:** Modular Monolith  
**Database:** PostgreSQL  
**ORM:** Django ORM  
**Primary Key Strategy:** UUID  
**Last Updated:** 2026-11-11

---

# 1. Document Purpose

This document defines the logical and physical database
architecture for Football OS.

It establishes the entities, attributes, relationships,
constraints, ownership boundaries and data integrity
requirements across the platform.

The document serves as the authoritative database
design reference for backend implementation.

# 2. Database Architecture Principles

1. PostgreSQL is the primary relational database.
2. UUIDs are the default primary keys for custom domain entities.
3. Django ORM manages database interactions.
4. Django's built-in authentication models are reused.
5. Global football data is separated from organisation-owned data.
6. Organisation-owned information must enforce tenant isolation.
7. Historical football relationships must be preserved.
8. Database constraints must enforce critical integrity rules.
9. External provider identifiers must be centrally mapped.
10. Database changes must be version-controlled through migrations.

# 3. Global Database Conventions

## 3.1 Primary Keys

Custom domain entities use UUID primary keys.

## 3.2 Timestamps

Entities requiring lifecycle tracking should include:

- created_at
- updated_at

Additional timestamps must be defined where business processes
require them.

## 3.3 Referential Integrity

Foreign keys must represent valid domain relationships.

Deletion policies must be explicitly defined for important
historical and financial records.

## 3.4 Organisation Ownership

Organisation-specific entities must have an explicit
organisation ownership relationship.

Tenant isolation must be enforced at the application
and authorization layers.

## 3.5 Historical Records

Historical contracts, transfers, match events and
provider ingestion records must not be silently overwritten.

---

# 4. Entity Relationship Diagrams

# ERD-001: Identity and Authentication

**Status:** In Progress

## 4.1 Purpose

Defines user identity, authentication, profile management,
authorization and account recovery.

## 4.2 Scope

- User accounts
- User profiles
- Groups
- Permissions
- User-group assignments
- Group-permission assignments
- Authentication sessions
- Email verification
- Password reset

## 4.3 Entities

### USER

Represents an authenticated Football OS account.

### USER_PROFILE

Stores additional user information that does not belong
in the authentication model.

### GROUP

Represents a collection of permissions.

Implementation: Django built-in Group model.

### PERMISSION

Represents an individual authorization capability.

Implementation: Django built-in Permission model.

### USER_GROUP

Represents the many-to-many relationship between users
and groups.

Implementation: Django's built-in user-group relationship.

### GROUP_PERMISSION

Represents the many-to-many relationship between groups
and permissions.

Implementation: Django's built-in group-permission relationship.

### USER_SESSION

Represents tracked authentication sessions where required.

Implementation approach: To be finalized.

### EMAIL_VERIFICATION

Tracks email verification tokens and their lifecycle.

### PASSWORD_RESET

Tracks password recovery requests and their lifecycle.

## 4.4 Relationships

- USER has one USER_PROFILE.
- USER belongs to zero or more GROUP records.
- GROUP contains zero or more PERMISSION records.
- USER may have multiple tracked authentication sessions.
- USER may have multiple email verification attempts.
- USER may have multiple password reset attempts.

## 4.5 Business Rules

1. Email addresses must be unique.
2. Email addresses are the primary authentication identifier.
3. User identifiers use UUIDs.
4. Passwords must never be stored in plaintext.
5. Verification tokens must have expiry rules.
6. Password reset tokens must be single-use.
7. Disabled accounts must not authenticate.
8. Authorization must use Django Groups and Permissions
   rather than a duplicated permission framework.

## 4.6 Security Considerations

- Secure password hashing.
- Email verification.
- Token expiry.
- Authentication throttling.
- Session revocation.
- Account recovery protection.
- Audit logging for security-sensitive operations.

## 4.7 Dependencies

- Django authentication framework.
- Organisation Management (ERD-002).

---

# ERD-002: Organisation Management

**Status:** Not Started

# ERD-003: Football Core Entities

**Status:** Not Started

# ERD-004: Competitions and Seasons

**Status:** Not Started

# ERD-005: Matches and Match Events

**Status:** Not Started

# ERD-006: Player Contracts and Transfers

**Status:** Not Started

# ERD-007: External Provider Integration

**Status:** Not Started

# ERD-008: Workflows and Events

**Status:** Not Started

# ERD-009: Notifications

**Status:** Not Started

# ERD-010: Community

**Status:** Not Started

# ERD-011: Analytics

**Status:** Not Started

# ERD-012: AI Intelligence

**Status:** Not Started

---

# 5. Cross-Domain Dependencies

To be completed after all twelve ERDs have been designed.

# 6. Global Integrity and Constraint Review

To be completed after all twelve ERDs have been designed.

# 7. Tenant Isolation Review

To be completed after all organisation-owned entities
have been identified.

# 8. Outstanding Architectural Decisions

To be consolidated from all twelve ERDs.

# 9. Architecture Approval

**Status:** Pending

Approval requires:

- All twelve ERDs completed.
- Relationships reviewed.
- Database constraints reviewed.
- Tenant isolation reviewed.
- Cross-domain dependencies reviewed.
- Architecture consistency verified.

