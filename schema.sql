-- ============================================================
-- Transactional Gaming Database
-- Relational Schema
-- ============================================================

CREATE TABLE Players (
    player_id INT,
    birth_date DATE,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    is_dealer BOOL,
    PRIMARY KEY (player_id)
);

CREATE TABLE Hands (
    hand_id INT,
    round_id INT,
    player_id INT,
    played_at DATETIME,
    game_type VARCHAR(20),
    PRIMARY KEY (hand_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

CREATE TABLE Cards (
    card_id INT,
    hand_id INT,
    card_rank INT,
    suit VARCHAR(20),
    PRIMARY KEY (card_id),
    FOREIGN KEY (hand_id) REFERENCES Hands(hand_id)
);

CREATE TABLE Bets (
    bet_id INT,
    hand_id INT,
    amount INT,
    PRIMARY KEY (bet_id),
    FOREIGN KEY (hand_id) REFERENCES Hands(hand_id)
);
