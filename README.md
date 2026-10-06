# SQL Transactional Data Analysis

A MySQL relational database project for modelling and analysing transactional gaming data.

The project combines relational database design with reusable analytical SQL views to explore betting activity, player data and game outcomes across Blackjack and Poker transactions.

## Project Overview

The database models a transactional gaming environment containing players, game hands, cards and bets.

The project demonstrates two main areas:

- **Relational database design** – creating a normalised schema with primary and foreign key relationships.
- **SQL data analysis** – transforming transactional records into structured analytical outputs using joins, aggregations, conditional logic, date calculations and reusable views.

All data included in this repository is synthetic and was created specifically for the portfolio version of the project.

## Database Schema

The database consists of four related tables:

### Players
Stores player and dealer information, including:
- Player ID
- Name
- Date of birth
- Dealer status

### Hands
Stores individual game hands, including:
- Hand ID
- Round ID
- Player ID
- Game type
- Date and time played

Each hand is linked to a player through a foreign key.

### Cards
Stores the cards associated with each hand, including:
- Card ID
- Hand ID
- Card rank
- Suit

### Bets
Stores betting transactions associated with game hands, including:
- Bet ID
- Hand ID
- Bet amount

The relationships can be represented as:

```text
Players
   |
   | 1:N
   v
 Hands
   |
   +----------+
   |          |
   | 1:N      | 1:N
   v          v
 Cards       Bets
```

## Analysis

The analytical layer is implemented through reusable SQL views.

### Transaction Analysis

`MonthlyBettingSummary`

Aggregates betting activity by month to calculate:
- Number of bets
- Total bet value
- Average bet value

`PlayerBettingSummary`

Combines player, hand and betting records to summarise transactional activity for each non-dealer player.

### Player Analysis

`PlayerAgeAtHand`

Uses date calculations to determine a player's age in days at the time each hand was played.

### Blackjack Analysis

The Blackjack analysis uses a multi-stage transformation process.

`BlackjackInitialTotals` calculates the initial value of each hand while converting face cards to their Blackjack value.

`BlackjackHandValues` applies conditional ace logic and handles hands exceeding 21.

`BlackjackRoundResults` joins player and dealer hands within each round to compare their final values and determine the outcome.

### Poker Analysis

Poker hands are classified by analysing card ranks and suits.

Supporting views identify:
- Rank frequencies
- Flushes
- Straights

`PokerHandClassification` then combines these results using conditional logic and subqueries to classify hands as:

- Straight Flush
- Four of a Kind
- Full House
- Flush
- Straight
- Three of a Kind
- Two Pair
- Pair
- High Card

## SQL Techniques Demonstrated

The project demonstrates practical use of:

- Relational database design
- Primary and foreign keys
- One-to-many relationships
- `JOIN`
- `GROUP BY`
- `HAVING`
- `SUM`, `AVG` and `COUNT`
- `CASE` expressions
- `DATEDIFF`
- Subqueries
- `EXISTS`
- Aggregate analysis
- Reusable SQL views

## Repository Structure

```text
sql-transactional-data-analysis/
├── README.md
├── schema.sql
├── sample_data.sql
└── analysis.sql
```

- `schema.sql` – creates the relational database structure.
- `sample_data.sql` – populates the database with synthetic example data.
- `analysis.sql` – creates the analytical views used to transform and analyse the data.

## Running the Project

The project is designed for MySQL.

Create an empty database and select it, then run the SQL files in the following order:

```text
1. schema.sql
2. sample_data.sql
3. analysis.sql
```

Example analyses can then be queried using:

```sql
SELECT * FROM MonthlyBettingSummary;
SELECT * FROM PlayerBettingSummary;
SELECT * FROM BlackjackRoundResults;
SELECT * FROM PokerHandClassification;
```

## Example Outputs

The synthetic dataset includes Blackjack and Poker scenarios that demonstrate the analytical logic.

For example, the Poker classification produces results such as:

```text
hand_id    hand_type
205        Full House
206        Flush
207        Straight
208        Pair
```

The Blackjack analysis compares player and dealer hand values within each round and determines whether the player won.

## Technologies

- MySQL
- SQL
- Relational Database Design
- Data Analysis
