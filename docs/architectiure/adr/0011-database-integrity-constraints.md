# ADR-011: Enforce Critical Data Integrity Rules at the Database Level

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will receive data through multiple entry points, including:

- Flutter mobile applications.
- Django REST APIs.
- Administrative interfaces.
- External football data providers.
- Background processing tasks.
- Internal management commands.

Application-level validation alone cannot guarantee data integrity across all these entry points.

Incorrect or inconsistent data could enter the database through scripts, integrations, concurrent operations or incomplete validation.

We therefore require important business integrity rules to be enforced at the database level.

## 2. Decision

We will use PostgreSQL database constraints, implemented through Django model definitions and migrations, to enforce critical data integrity rules.

These will include:

- Unique constraints.
- Check constraints.
- Foreign key constraints.
- Non-null constraints.
- Appropriate indexes.

Application-level validation will remain necessary for meaningful error messages and business workflows.

Database constraints will act as the final integrity boundary.

## 3. Match Integrity Example

A football match cannot have the same club as both its home and away team.

The Match model will enforce this using a database-level check constraint.

    from django.db import models
    from django.db.models import F, Q

    class Match(models.Model):

        home_club = models.ForeignKey(
            "football.Club",
            on_delete=models.PROTECT,
            related_name="home_matches"
        )

        away_club = models.ForeignKey(
            "football.Club",
            on_delete=models.PROTECT,
            related_name="away_matches"
        )

        class Meta:
            constraints = [
                models.CheckConstraint(
                    condition=~Q(
                        home_club=F("away_club")
                    ),
                    name="prevent_self_matching"
                )
            ]

## 4. Additional Integrity Requirements

### Organisation Membership

A user should not have duplicate membership records for the same organisation under the initial one-membership-per-organisation model.

### External Identifiers

A provider must not map the same external entity identifier to multiple internal records of the same entity type.

### Contract Dates

A contract end date must not precede its start date.

### Competition Registration

Duplicate registrations for the same club within the same competition season must be prevented where the competition rules require uniqueness.

### Match Scores

Scores must not be negative.

### User Preferences

A user should not have duplicate favourite-club relationships for the same club.

## 5. Alternatives Considered

### Application-Level Validation Only

Rejected because it does not provide sufficient protection against every database write path.

### Database Constraints Only

Rejected because database errors alone do not provide a complete business validation and user-feedback strategy.

### Manual Database Triggers for Every Rule

Not selected as the default approach because Django model constraints are more transparent and maintainable for ordinary relational integrity rules.

Triggers may be introduced when a requirement cannot be adequately represented through standard constraints.

## 6. Consequences

### Positive

- Stronger data integrity.
- Protection across multiple application entry points.
- Reduced duplicate records.
- Better concurrency safety.
- More reliable integrations.
- Explicit business invariants.

### Negative

- Additional migration complexity.
- Database errors must be handled correctly.
- Some complex business rules cannot be represented by simple constraints.
- Constraint changes require careful deployment planning.

## 7. Implementation Guidelines

- Prefer database constraints for permanent integrity rules.
- Use serializers and forms for input validation.
- Use service-layer validation for complex business operations.
- Handle IntegrityError appropriately.
- Test constraints against the actual database engine.
- Avoid assuming SQLite testing provides identical PostgreSQL behaviour.

## 8. Related Decisions

- ADR-002: PostgreSQL Database.
- ADR-003: Shared-Database Multi-Tenancy.
- ADR-010: Player Contract and Transfer Registry.
- ADR-012: External Identifier Mapping.
- ADR-013: Competition Season Registration.
