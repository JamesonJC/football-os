# ADR-010: Introduce a Unified Player Contract and Transfer Registry

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team

## 1. Context

Football OS requires accurate historical and current information about player-club relationships.

A direct many-to-many relationship between Player and Club would not adequately represent the history and complexity of professional football employment and registration.

Players may:

- Sign permanent contracts.
- Move between clubs.
- Join clubs on loan.
- Return from loan.
- Renew existing contracts.
- Join youth academies.
- Leave clubs after contract expiration.

A player may have an ongoing employment relationship with one club while temporarily representing another club through a loan arrangement.

We therefore require a historical relationship model.

## 2. Decision

We will introduce a dedicated Player Contract and Transfer Registry.

Player-club relationships will be represented through explicit records containing contract type, relevant clubs, dates and status.

The model will support different relationship types, including:

- Permanent employment.
- Loan agreements.
- Youth agreements.
- Contract renewals.
- Other approved player-club arrangements.

A contract record will maintain its historical information rather than being overwritten when a player changes clubs.

## 3. Proposed Data Structure

### PlayerContract

- ID.
- Player.
- Contract type.
- Contracting club.
- Start date.
- End date.
- Contract status.
- Created date.
- Updated date.

### LoanAgreement

Where necessary, additional loan-specific information will include:

- Parent club.
- Borrowing club.
- Loan start date.
- Loan end date.
- Loan status.
- Optional purchase clause information.

The exact relationship between PlayerContract and LoanAgreement will be established during detailed database modelling.

### PlayerTransfer

Where transfer history requires additional detail, a separate transfer transaction record may capture:

- Player.
- Previous club.
- New club.
- Transfer date.
- Transfer type.
- Transfer fee where legally and reliably available.
- Source provenance.

## 4. Domain Rules

- Historical player-club relationships must be preserved.
- Contract dates must be valid.
- Loan relationships must identify both parent and borrowing clubs.
- Transfers must not silently overwrite historical records.
- Contract status must be distinguishable from player registration status.
- Multiple historical contracts may exist for the same player and club.
- Overlapping contracts must be evaluated according to contract type and applicable football rules.

A loan arrangement must not automatically be interpreted as a permanent termination of the player's parent-club employment contract.

## 5. Alternatives Considered

### Direct Player-to-Club Foreign Key

Rejected because it cannot adequately represent historical club relationships.

### Simple Many-to-Many Relationship

Rejected because it does not naturally capture contract dates, loan status and transfer history.

### Single Unstructured Transfer History Field

Rejected because it prevents reliable querying, validation and reporting.

## 6. Consequences

### Positive

- Historical player-club tracking.
- Better transfer analytics.
- Loan relationship support.
- Contract lifecycle management.
- Improved player career histories.
- More accurate football intelligence.

### Negative

- More complex relational modelling.
- Requires contract lifecycle rules.
- Requires careful date validation.
- Different football jurisdictions may have different registration rules.

## 7. Data Governance Considerations

Public football career information must be distinguished from confidential employment and contractual information.

Sensitive contractual information must only be exposed where there is an appropriate legal basis and data-sharing permission.

The system must not assume that all contract information is publicly available.

## 8. Related Decisions

- ADR-002: PostgreSQL Database.
- ADR-005: Provider-Independent Football Data Integration.
- ADR-013: Competition Season Registration.
- ADR-014: Organisation Data Isolation.
