# ADR-008: Adopt a Custom Django User Model with Email Authentication

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS will support multiple categories of users, including:

- Individual football supporters.
- Club administrators.
- Coaches.
- Scouts.
- Analysts.
- Players.
- Football organisation staff.
- Platform administrators.
- External integration operators.

The platform requires a flexible identity system capable of supporting registration, authentication, account verification, password recovery, organisation invitations and future third-party authentication integrations.

Django's default User model includes a username field as its primary login identifier.

Introducing a custom user model after initial migrations can create significant migration and dependency complexity.

We therefore need to establish our identity architecture before creating the initial database migrations.

## 2. Decision

We will implement a custom Django User model using email as the unique authentication identifier.

The model will extend Django's AbstractUser, removing the username field and introducing a unique email field.

The model will be defined inside the Identity application.

The project will configure:

    AUTH_USER_MODEL = "identity.User"

Authentication will use email rather than username.

The user will retain a stable internal UUID identifier.

Email addresses will be normalized consistently before account creation and authentication.

A custom user manager will handle user and superuser creation.

## 3. Proposed Model Structure

The initial model will contain:

- UUID primary key.
- Email address.
- Password hash.
- First name.
- Last name.
- Active status.
- Staff status.
- Superuser status.
- Date joined.
- Last login.

Additional personal information will be stored in a separate UserProfile entity.

Passwords will use Django's authentication framework and password hashing mechanisms.

Plain-text passwords must never be stored.

## 4. Authentication Design

The identity module will support:

- Email and password registration.
- Email and password authentication.
- Email verification.
- Password reset.
- Account activation and deactivation.
- JWT-based API authentication.
- Future OAuth and social authentication integrations.

Email authentication and email verification will be treated as separate concerns.

A unique email address does not automatically mean that the account has been verified.

## 5. Alternatives Considered

### Default Django User Model

Rejected because it retains a username-based identity structure that does not align with our preferred authentication approach.

### Custom User Model Implemented Later

Rejected because changing the user model after initial migrations can introduce significant migration and dependency complexity.

### Email as the Primary Database Identifier

Rejected because email addresses can change.

A stable internal UUID is more appropriate for permanent entity identification.

## 6. Consequences

### Positive

- Consistent email-based authentication.
- Greater flexibility for future authentication integrations.
- Better alignment with modern B2C and B2B applications.
- Stable internal user identifiers.
- Cleaner registration and invitation workflows.
- Easier future account management.

### Negative

- Requires a custom user manager.
- Requires careful email normalization.
- Authentication implementation needs additional testing.
- Email changes require verification and account-security controls.

## 7. Security Considerations

- Use Django's password hashing framework.
- Never store plain-text passwords.
- Enforce email uniqueness at the database level.
- Verify email ownership before enabling verified-account features.
- Implement appropriate login throttling.
- Protect password reset flows.
- Avoid exposing whether an email address belongs to an existing account.
- Protect authentication tokens.
- Apply appropriate session and token expiration policies.

## 8. Implementation Considerations

The custom user model must be created before the first application database migration.

All other applications must reference the user model through:

    settings.AUTH_USER_MODEL

Django model relationships should not directly depend on the default auth.User model.

## 9. Related Decisions

- ADR-001: Modular Monolith Architecture.
- ADR-004: Versioned REST API.
- ADR-009: Hybrid Authorization and Role Management.
- ADR-015: Subscription and Entitlement Management.
