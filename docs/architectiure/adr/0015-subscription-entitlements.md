# ADR-015: Separate Subscription Management from Authorization

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS has the potential to become a commercial football intelligence platform.

Future product offerings may include:

- Free football information.
- Premium football analytics.
- Advanced AI football assistance.
- Enhanced notifications.
- Supporter community capabilities.
- Organisation management features.
- Enterprise intelligence services.

A user's commercial subscription status is different from their identity and authorization permissions.

For example, a Premium Subscriber may still have no permission to access a football organisation's confidential scouting reports.

Likewise, an organisation administrator may require access to enterprise functionality through an organisation subscription rather than an individual subscription.

We therefore need a separate subscription and entitlement architecture.

## 2. Decision

We will introduce a dedicated Subscription and Entitlement domain.

The domain will manage commercial plans, subscriptions and feature entitlements independently of the global and organisation-specific authorization systems.

The initial conceptual entities will include:

### SubscriptionPlan

Defines available commercial plans.

Attributes may include:

- ID.
- Name.
- Description.
- Billing interval.
- Price.
- Currency.
- Active status.

### Subscription

Represents an active or historical subscription.

Attributes may include:

- ID.
- Subscriber.
- Subscription plan.
- Start date.
- End date.
- Subscription status.
- Renewal information.

The subscriber may be an individual user or an organisation.

### FeatureEntitlement

Defines capabilities included within a subscription plan.

Examples include:

- Advanced analytics.
- AI assistant usage.
- Enhanced notifications.
- Additional organisation features.
- Extended historical data access.

### SubscriptionEvent

Records relevant subscription lifecycle events where required.

## 3. Separation of Responsibilities

The architecture will maintain three distinct concerns:

### Identity

Who is the user?

### Authorization

What is the user permitted to do?

### Entitlement

What commercial capabilities does the user or organisation currently have access to?

A subscription entitlement must never automatically override an authorization restriction.

For example, purchasing an AI Premium subscription must not grant access to confidential data owned by another organisation.

## 4. Alternatives Considered

### Use Django Groups for Subscription Tiers

Rejected because subscription plans are commercial products rather than ordinary authorization roles.

### Hardcode Premium Checks Throughout the Application

Rejected because it creates scattered business rules and makes pricing or product changes difficult.

### Couple Subscription Status Directly to User Permissions

Rejected because commercial entitlement and authorization have different lifecycles and responsibilities.

## 5. Consequences

### Positive

- Clear separation between commercial and security concerns.
- Supports individual subscriptions.
- Supports organisation subscriptions.
- Easier future billing integrations.
- Centralized entitlement management.
- Better commercial product extensibility.

### Negative

- Additional domain complexity.
- Subscription lifecycle management is required.
- Billing integrations require careful reconciliation.
- Entitlement checks must be consistent across API endpoints.

## 6. Security and Operational Considerations

- Subscription status must be validated server-side.
- Client-side premium indicators are not security controls.
- Billing credentials must be protected.
- Payment provider webhooks must be verified.
- Subscription events should be auditable.
- Expired or cancelled subscriptions must be handled correctly.
- Payment information should be handled through appropriate payment providers rather than storing unnecessary sensitive card data.
- Subscription entitlements must never bypass organisation authorization.

## 7. Future Considerations

Future capabilities may include:

- Monthly and annual billing.
- Individual and organisation subscriptions.
- Usage-based AI pricing.
- Enterprise contracts.
- Promotional plans.
- Trials and discounts.
- Subscription analytics.
- Billing provider integrations.

These capabilities will be implemented according to commercial validation and available development time.

## 8. Related Decisions

- ADR-008: Custom Django User Model.
- ADR-009: Hybrid Authorization and Role Management.
- ADR-014: Organisation Data Isolation.
