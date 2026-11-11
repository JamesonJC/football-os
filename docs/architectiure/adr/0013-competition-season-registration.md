# ADR-013: Introduce Season-Scoped Competition Registration

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will support football competitions across different countries and governing structures.

Clubs may participate in different competitions depending on their sporting qualification, league position, promotion, relegation and other competition-specific rules.

A direct many-to-many relationship between Club and Competition cannot adequately represent historical participation.

For example:

- A club may participate in the Premier League during one season.
- The same club may participate in the Championship during another season.
- A club may qualify for a continental competition in addition to its domestic league.
- A club may be disqualified or withdraw from a competition.

We therefore require a season-specific registration model.

## 2. Decision

We will introduce a CompetitionSeasonRegistration entity.

The entity will connect:

- Club.
- Competition.
- Season.

It will maintain the participation status and relevant historical information.

A Season will belong to a Competition.

A CompetitionSeasonRegistration will identify the clubs participating in a particular competition season.

## 3. Proposed Domain Structure

    Competition
        |
        | 1 to many
        |
    Season
        |
        | 1 to many
        |
    CompetitionSeasonRegistration
        |
        | many to 1
        |
    Club

## 4. Proposed Registration Attributes

- ID.
- Season.
- Club.
- Registration status.
- Qualification date.
- Registration date.
- Withdrawal date.
- Created date.
- Updated date.

Initial registration statuses may include:

- Qualified.
- Registered.
- Active.
- Promoted.
- Relegated.
- Withdrawn.
- Disqualified.

The status lifecycle will be validated against competition-specific rules.

## 5. Domain Rules

- A season must belong to one competition.
- A registration must reference a valid season and club.
- Duplicate club registrations within the same competition season must be prevented where applicable.
- Historical registrations must be retained.
- Promotion and relegation must not overwrite previous season participation.
- Clubs may participate in multiple competitions during the same football season.
- Competition-specific rules may determine additional registration requirements.

## 6. Alternatives Considered

### Direct Club-to-Competition Relationship

Rejected because it cannot represent season-specific participation.

### Store Participating Clubs as a List

Rejected because it prevents proper relational integrity and historical querying.

### Use Match Records to Infer Participation

Rejected because qualification and registration can exist independently of an individual match.

## 7. Consequences

### Positive

- Historical competition participation.
- Promotion and relegation tracking.
- Qualification tracking.
- Better competition analytics.
- More accurate historical reporting.
- Support for international and domestic competitions.

### Negative

- Additional relational complexity.
- Different competitions require different registration rules.
- Status transitions require validation.
- Historical data may be incomplete for some competitions.

## 8. Future Considerations

Additional entities may be introduced for:

- Qualification pathways.
- Group-stage participation.
- Knockout-stage registration.
- Competition-specific squad registration.
- Disciplinary restrictions.
- Competition entry requirements.

## 9. Related Decisions

- ADR-002: PostgreSQL Database.
- ADR-005: Provider-Independent Football Data Integration.
- ADR-010: Player Contract and Transfer Registry.
- ADR-011: Database-Level Integrity Constraints.
