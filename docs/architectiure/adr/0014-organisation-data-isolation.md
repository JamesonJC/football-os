# ADR-014: Enforce Organisation Data Isolation and Confidentiality

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will serve individual supporters and multiple football organisations.

The platform will maintain globally shared football information alongside confidential organisational information.

Examples of global information include:

- Clubs.
- Players.
- Competitions.
- Seasons.
- Matches.
- Public statistics.
- Stadiums.

Examples of confidential organisational information include:

- Scouting reports.
- Internal tactical analysis.
- Player medical information.
- Private GPS metrics.
- Financial records.
- Internal operational workflows.
- Confidential performance reports.

These two information categories have fundamentally different ownership and access requirements.

A user associated with one organisation must not gain access to another organisation's confidential information merely because both organisations use Football OS.

## 2. Decision

We will adopt a shared-database multi-tenancy architecture with explicit organisation ownership for confidential records.

The architecture will distinguish between:

### Global Football Data

Global football entities will be maintained independently of individual organisation ownership.

Examples:

- Club.
- Player.
- Competition.
- Season.
- Match.
- Stadium.

### Organisation-Owned Data

Confidential organisation-specific entities will contain an explicit foreign key referencing their owning Organisation.

Examples:

- ScoutingReport.
- InternalTactics.
- PlayerMedicalHistory.
- PrivateGPSMetrics.
- ClubFinancialRecord.
- OrganisationTask.

## 3. Organisation Ownership

Organisation-owned records must contain an organisation reference.

Conceptual example:

    class ScoutingReport(models.Model):

        organisation = models.ForeignKey(
            "organisations.Organisation",
            on_delete=models.PROTECT
        )

        player = models.ForeignKey(
            "football.Player",
            on_delete=models.PROTECT
        )

        created_by = models.ForeignKey(
            settings.AUTH_USER_MODEL,
            on_delete=models.PROTECT
        )

        report = models.TextField()

The organisation reference identifies the owner of the confidential report.

The referenced Player remains a globally shared football entity.

This distinction allows organisations to maintain private information about the same globally known player without duplicating the Player record.

## 4. Application-Level Authorization

The backend must verify:

1. The requesting user is authenticated.
2. The requested organisation exists.
3. The user has an active membership.
4. The membership grants the required permission.
5. The requested resource belongs to the authorised organisation.

Membership alone does not automatically grant access to every resource.

Unauthorized cross-organisation access must return an appropriate HTTP 403 Forbidden response.

## 5. PostgreSQL Row-Level Security

PostgreSQL Row-Level Security will be introduced as an additional database-level isolation mechanism for sensitive organisation-owned tables.

The implementation will use policies that restrict records according to the active organisation context.

The tenant context must be established securely within the database transaction.

The application database role must not have privileges that bypass the intended RLS policies.

We will carefully distinguish the application database role from privileged administrative or migration roles.

## 6. Tenant-Aware Application Architecture

Tenant-aware query services and managers may be introduced to make organisation filtering consistent.

However, custom Django managers will not be treated as the sole security boundary.

Critical isolation controls must be enforced through backend authorization and, where implemented, PostgreSQL RLS.

All tenant-sensitive operations must be tested for cross-organisation access.

## 7. Alternatives Considered

### Shared Database Without Tenant Isolation

Rejected because it exposes confidential information to cross-organisation access risks.

### Separate Database Per Organisation

Not selected for the initial implementation because of additional infrastructure and operational complexity.

It may be considered for specific enterprise customers later.

### Django Managers Only

Rejected as the only protection because alternative query paths can bypass custom managers.

### PostgreSQL RLS Only

Rejected as the only protection because application-level authorization is still necessary for role checks and business rules.

## 8. Consequences

### Positive

- Stronger organisational confidentiality.
- Supports multiple organisations.
- Allows shared global football information.
- Reduces data duplication.
- Supports enterprise reporting.
- Creates a foundation for regulated information management.

### Negative

- More complex authorization architecture.
- Requires careful transaction and connection management.
- RLS policies require dedicated testing.
- Debugging tenant-related issues can become more difficult.
- Administrative operations require controlled privileged access.

## 9. Security Requirements

- Enforce least-privilege authorization.
- Verify organisation membership and role.
- Never trust client-supplied organisation identifiers.
- Apply tenant filtering consistently.
- Protect sensitive medical and financial information.
- Maintain audit records for sensitive operations.
- Test cross-tenant access denial.
- Use secure database connection settings.
- Prevent application database roles from bypassing RLS.
- Avoid leaking confidential information through error messages, exports or analytics.

## 10. Future Considerations

Additional enterprise security capabilities may include:

- Organisation-specific encryption policies.
- Data retention policies.
- Confidential document management.
- Advanced audit trails.
- Dedicated database deployments.
- Organisation-specific data residency requirements.

## 11. Related Decisions

- ADR-003: Shared-Database Multi-Tenancy.
- ADR-009: Hybrid Authorization and Role Management.
- ADR-011: Database-Level Integrity Constraints.
- ADR-015: Subscription and Entitlement Management.
