# ADR-007: Adopt Event-Driven Internal Processing

**Status:** Proposed  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS contains multiple modules that may need to respond to business events.

For example, when a match receives an important update:

- Match information may change.
- Interested supporters may require notifications.
- Analytics may require recalculation.
- Audit records may need updating.
- AI intelligence may require refreshed contextual information.

Directly coupling all these operations to the match update process would make the application difficult to maintain.

We therefore require a mechanism for communicating meaningful business events between modules.

## 2. Decision

We will adopt event-driven internal processing.

Modules may publish domain events when meaningful business operations occur.

Other modules can respond to these events through defined handlers.

Initial examples include:

- UserRegistered.
- OrganisationCreated.
- OrganisationMemberInvited.
- MatchUpdated.
- MatchCompleted.
- FavouriteClubAdded.
- NotificationRequested.
- WorkflowCompleted.

For the initial modular monolith, event handling will use internal application-level mechanisms.

Celery will be used when processing needs to occur asynchronously.

We will evaluate the transactional outbox pattern to ensure reliable publication of events generated from database transactions.

## 3. Alternatives Considered

### Direct Synchronous Calls

Suitable for simple operations but can introduce excessive coupling when multiple modules depend on the same business event.

### External Message Broker From Day One

Not required for the initial modular monolith.

A distributed message broker may become appropriate if independent services are introduced.

### Event Sourcing

Not selected.

Event-driven processing does not require storing every state change as the authoritative source of truth.

We will use conventional relational persistence and selectively record meaningful domain events.

## 4. Consequences

### Positive

- Reduced coupling.
- Easier extension of business processes.
- Supports notification workflows.
- Improves integration capabilities.
- Creates a foundation for future distributed processing.

### Negative

- More complex debugging.
- Event ordering may matter.
- Duplicate event handling must be considered.
- Asynchronous processing introduces eventual consistency.
- Reliable event publication requires additional design.

## 5. Reliability Requirements

- Handlers should be idempotent where practical.
- Failed processing should be observable.
- Important events should not be silently discarded.
- Transactional consistency must be considered.
- Event payloads should be versioned when necessary.
- Sensitive information should not be unnecessarily included in events.

OAOAOA## 6. Related Decisions
OAOAOA
- ADR-001: Modular Monolith Architecture.
OAOAOA- ADR-005: Football Data Integration.
- ADR-006: Background Processing.
