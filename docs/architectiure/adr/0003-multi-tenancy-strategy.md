# ADR-010: Introduce a Unified Player Contract and Transfer Registry

**Status:** Accepted  
**Date:** 11 November 2026  
**Decision Owner:** Football OS Engineering Team  
**Implementation Status:** Not Implemented

## 1. Context

Football OS requires accurate historical and current information about player-club relationships.

A direct many-to-many relationship between Player and Club cannot adequately represent the complexity of professional football employment, loans, transfers and sporting registrations.

Players may:

- Sign permanent contracts.
- Move between clubs.
- Join clubs on loan.
- Return from loan.
- Renew existing contracts.
- Join youth academies.
- Leave clubs after contract expiration.
- Register for competitions independently of their employment arrangements.

A player may have an active employment contract with one club while temporarily representing another club through a loan arrangement.

Employment, transfer transactions, loan arrangements and sporting registrations are related but distinct football domain concepts.

Football OS must preserve these distinctions and maintain historical records.

## 2. Decision

Football OS will implement a dedicated Player Contract and Transfer Registry.

The domain will initially distinguish four concepts:

1. PlayerContract.
2. LoanAgreement.
3. PlayerTransfer.
4. PlayerRegistration.

These entities will have explicit relationships and separate business rules.

The design must preserve historical information rather than overwriting previous relationships.

## 3. Domain Entities

### 3.1 PlayerContract

Represents an employment or contractual relationship between a player and a contracting club.

Proposed attributes:

- ID.
- Player.
- Contracting club.
- Contract type.
- Start date.
- End date.
- Contract status.
- Source or provenance reference, where applicable.
- Created date.
- Updated date.

Contract types may include:

- Professional.
- Youth.
- Amateur.
- Other approved contractual arrangements.

Business rules:

- A contract must reference a valid player and club.
- Contract start date must not be after its end date.
- Historical contracts must be retained.
- Contract status must be distinct from sporting registration status.
- Contractual information must have appropriate access restrictions.
- Contract renewals must preserve the relevant historical record.

### 3.2 LoanAgreement

Represents a temporary arrangement through which a player moves from a parent club to a borrowing club.

Proposed attributes:

- ID.
- Player.
- Parent club.
- Borrowing club.
- Loan start date.
- Loan end date.
- Loan status.
- Purchase option information, where applicable.
- Purchase obligation information, where applicable.
- Created date.
- Updated date.

Business rules:

- A loan must identify both parent and borrowing clubs.
- Parent and borrowing clubs must be different.
- Loan start date must not be after its end date.
- A loan must not automatically terminate the player's parent-club contract.
- Historical loan records must be preserved.
- Loan status must be distinguishable from employment contract status.

### 3.3 PlayerTransfer

Represents a player movement transaction between clubs.

Proposed attributes:

- ID.
- Player.
- Previous club.
- New club.
- Transfer date.
- Transfer type.
- Transfer fee, where legally and reliably available.
- Currency, where applicable.
- Transfer status.
- Source provenance.
- Created date.
- Updated date.

Transfer types may include:

- Permanent.
- Loan.
- Free transfer.
- Youth transfer.
- Other approved movement types.

Business rules:

- Previous and new clubs must be different.
- Transfer dates must be valid.
- Transfer fees must not be assumed when unavailable.
- Currency must be explicit where financial amounts are recorded.
- Transfer history must not be silently overwritten.
- A transfer transaction must not automatically be treated as proof of an employment contract or competition registration.

### 3.4 PlayerRegistration

Represents a player's sporting registration with a club or competition where applicable.

Proposed attributes:

- ID.
- Player.
- Club.
- Competition, where applicable.
- Season, where applicable.
- Registration start date.
- Registration end date.
- Registration status.
- Created date.
- Updated date.

Business rules:

- Sporting registration must be distinct from employment.
- Registration must comply with the applicable competition rules.
- Historical registration records must be preserved.
- A player may have different registration relationships depending on the competition and applicable regulations.
- The model must accommodate different registration requirements across jurisdictions.

## 4. Relationships

The conceptual relationships are:

```text
Player
  |
  | 1-to-many
  |
PlayerContract
  |
  | many-to-1
  |
ContractingClub


Player
  |
  | 1-to-many
  |
LoanAgreement
  |
  |-------------------------|
  |                         |
ParentClub              BorrowingClub


Player
  |
  | 1-to-many
  |
PlayerTransfer
  |
  |-------------------------|
  |                         |
PreviousClub             NewClub


Player
  |
  | 1-to-many
  |
PlayerRegistration
  |
  |-------------------------|
  |                         |
Club                  Competition/Season
