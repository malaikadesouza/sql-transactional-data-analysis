-- ============================================================
-- Transactional Gaming Database
-- Analytical Views
-- ============================================================


-- ============================================================
-- 1. TRANSACTION ANALYSIS
-- ============================================================

-- Summarises betting activity by month, including total value,
-- number of bets and average bet size.

CREATE VIEW MonthlyBettingSummary AS
SELECT
    YEAR(h.played_at) AS year,
    MONTH(h.played_at) AS month,
    COUNT(b.bet_id) AS number_of_bets,
    SUM(b.amount) AS total_bet_value,
    AVG(b.amount) AS average_bet_value
FROM Hands h
JOIN Bets b ON h.hand_id = b.hand_id
GROUP BY
    YEAR(h.played_at),
    MONTH(h.played_at);


-- Summarises betting activity for each player.

CREATE VIEW PlayerBettingSummary AS
SELECT
    p.player_id,
    p.first_name,
    p.last_name,
    COUNT(b.bet_id) AS number_of_bets,
    SUM(b.amount) AS total_bet_value,
    AVG(b.amount) AS average_bet_value
FROM Players p
JOIN Hands h ON p.player_id = h.player_id
JOIN Bets b ON h.hand_id = b.hand_id
WHERE p.is_dealer = FALSE
GROUP BY
    p.player_id,
    p.first_name,
    p.last_name;


-- ============================================================
-- 2. PLAYER ANALYSIS
-- ============================================================

-- Calculates each player's age in days when each hand was played.

CREATE VIEW PlayerAgeAtHand AS
SELECT
    h.hand_id,
    p.player_id,
    p.first_name,
    p.last_name,
    h.played_at,
    DATEDIFF(h.played_at, p.birth_date) AS age_in_days
FROM Hands h
JOIN Players p ON h.player_id = p.player_id;


-- ============================================================
-- 3. BLACKJACK ANALYSIS
-- ============================================================

-- Calculates the initial value of each Blackjack hand.
-- Face cards are worth 10 and aces initially count as 1.

CREATE VIEW BlackjackInitialTotals AS
SELECT
    h.hand_id,
    h.round_id,
    h.player_id,
    SUM(
        CASE
            WHEN c.card_rank IN (11, 12, 13) THEN 10
            ELSE c.card_rank
        END
    ) AS initial_value
FROM Hands h
JOIN Cards c ON h.hand_id = c.hand_id
WHERE h.game_type = 'Blackjack'
GROUP BY
    h.hand_id,
    h.round_id,
    h.player_id;


-- Adjusts the value of an ace from 1 to 11 when doing so
-- does not cause the hand to exceed 21.

CREATE VIEW BlackjackHandValues AS
SELECT
    t.hand_id,
    t.round_id,
    t.player_id,
    CASE
        WHEN t.initial_value > 21 THEN 0

        WHEN EXISTS (
            SELECT 1
            FROM Cards c
            WHERE c.hand_id = t.hand_id
              AND c.card_rank = 1
        )
        AND t.initial_value <= 11
        THEN t.initial_value + 10

        ELSE t.initial_value
    END AS hand_value
FROM BlackjackInitialTotals t;


-- Compares the player and dealer hands within each Blackjack round.

CREATE VIEW BlackjackRoundResults AS
SELECT
    player_hand.round_id,
    player_hand.hand_value AS player_hand_value,
    dealer_hand.hand_value AS dealer_hand_value,

    CASE
        WHEN player_hand.hand_value > dealer_hand.hand_value
        THEN TRUE
        ELSE FALSE
    END AS player_wins

FROM BlackjackHandValues player_hand

JOIN Hands player_h
    ON player_hand.hand_id = player_h.hand_id

JOIN Players player_p
    ON player_h.player_id = player_p.player_id

JOIN BlackjackHandValues dealer_hand
    ON player_hand.round_id = dealer_hand.round_id

JOIN Hands dealer_h
    ON dealer_hand.hand_id = dealer_h.hand_id

JOIN Players dealer_p
    ON dealer_h.player_id = dealer_p.player_id

WHERE player_p.is_dealer = FALSE
  AND dealer_p.is_dealer = TRUE;


-- ============================================================
-- 4. POKER HAND ANALYSIS
-- ============================================================

-- Counts how many cards of each rank occur within each Poker hand.

CREATE VIEW PokerRankCounts AS
SELECT
    h.hand_id,
    c.card_rank,
    COUNT(*) AS rank_count
FROM Hands h
JOIN Cards c ON h.hand_id = c.hand_id
WHERE h.game_type = 'Poker'
GROUP BY
    h.hand_id,
    c.card_rank;


-- Identifies Poker hands where all cards have the same suit.

CREATE VIEW PokerFlushes AS
SELECT
    h.hand_id
FROM Hands h
JOIN Cards c ON h.hand_id = c.hand_id
WHERE h.game_type = 'Poker'
GROUP BY h.hand_id
HAVING COUNT(DISTINCT c.suit) = 1;


-- Identifies Poker hands containing five consecutive ranks.

CREATE VIEW PokerStraights AS
SELECT
    h.hand_id
FROM Hands h
JOIN Cards c ON h.hand_id = c.hand_id
WHERE h.game_type = 'Poker'
GROUP BY h.hand_id
HAVING
    COUNT(DISTINCT c.card_rank) = 5
    AND MAX(c.card_rank) - MIN(c.card_rank) = 4;


-- Classifies Poker hands using rank frequency, straight
-- detection and flush detection.

CREATE VIEW PokerHandClassification AS
SELECT
    h.hand_id,

    CASE

        WHEN h.hand_id IN (SELECT hand_id FROM PokerStraights)
         AND h.hand_id IN (SELECT hand_id FROM PokerFlushes)
            THEN 'Straight Flush'

        WHEN 4 IN (
            SELECT prc.rank_count
            FROM PokerRankCounts prc
            WHERE prc.hand_id = h.hand_id
        )
            THEN 'Four of a Kind'

        WHEN 3 IN (
            SELECT prc.rank_count
            FROM PokerRankCounts prc
            WHERE prc.hand_id = h.hand_id
        )
        AND 2 IN (
            SELECT prc.rank_count
            FROM PokerRankCounts prc
            WHERE prc.hand_id = h.hand_id
        )
            THEN 'Full House'

        WHEN h.hand_id IN (SELECT hand_id FROM PokerFlushes)
            THEN 'Flush'

        WHEN h.hand_id IN (SELECT hand_id FROM PokerStraights)
            THEN 'Straight'

        WHEN 3 IN (
            SELECT prc.rank_count
            FROM PokerRankCounts prc
            WHERE prc.hand_id = h.hand_id
        )
            THEN 'Three of a Kind'

        WHEN (
            SELECT COUNT(*)
            FROM PokerRankCounts prc
            WHERE prc.hand_id = h.hand_id
              AND prc.rank_count = 2
        ) = 2
            THEN 'Two Pair'

        WHEN 2 IN (
            SELECT prc.rank_count
            FROM PokerRankCounts prc
            WHERE prc.hand_id = h.hand_id
        )
            THEN 'Pair'

        ELSE 'High Card'

    END AS hand_type

FROM Hands h
WHERE h.game_type = 'Poker';
