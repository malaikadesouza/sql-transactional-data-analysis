-- ============================================================
-- Transactional Gaming Database
-- Synthetic Sample Data
-- ============================================================

-- Players
INSERT INTO Players
    (player_id, birth_date, first_name, last_name, is_dealer)
VALUES
    (101, '1988-02-14', 'Daniel', 'Reed', FALSE),
    (102, '1996-07-21', 'Maya', 'Patel', FALSE),
    (103, '1991-12-03', 'Oliver', 'Chen', TRUE),
    (104, '2003-04-18', 'Sofia', 'Martinez', FALSE),
    (105, '1985-09-09', 'Noah', 'Williams', TRUE),
    (106, '1999-11-27', 'Amara', 'Singh', FALSE);


-- Hands
INSERT INTO Hands
    (hand_id, round_id, player_id, played_at, game_type)
VALUES
    (201, 1, 101, '2025-01-10 19:30:00', 'Blackjack'),
    (202, 1, 103, '2025-01-10 19:30:00', 'Blackjack'),

    (203, 2, 102, '2025-02-15 20:10:00', 'Blackjack'),
    (204, 2, 105, '2025-02-15 20:10:00', 'Blackjack'),

    (205, 3, 104, '2025-03-08 21:00:00', 'Poker'),
    (206, 3, 106, '2025-03-08 21:00:00', 'Poker'),

    (207, 4, 101, '2025-04-12 18:45:00', 'Poker'),
    (208, 4, 102, '2025-04-12 18:45:00', 'Poker');


-- Cards

-- Blackjack hand: 10 + 9 = 19
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (301, 201, 10, 'Hearts'),
    (302, 201, 9, 'Clubs');

-- Dealer: 10 + 7 = 17
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (303, 202, 13, 'Spades'),
    (304, 202, 7, 'Diamonds');

-- Blackjack with ace: A + 9 = 20
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (305, 203, 1, 'Hearts'),
    (306, 203, 9, 'Diamonds');

-- Dealer: 10 + 8 = 18
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (307, 204, 12, 'Clubs'),
    (308, 204, 8, 'Spades');

-- Poker: full house
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (309, 205, 6, 'Hearts'),
    (310, 205, 6, 'Diamonds'),
    (311, 205, 6, 'Clubs'),
    (312, 205, 4, 'Spades'),
    (313, 205, 4, 'Hearts');

-- Poker: flush
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (314, 206, 2, 'Diamonds'),
    (315, 206, 5, 'Diamonds'),
    (316, 206, 8, 'Diamonds'),
    (317, 206, 11, 'Diamonds'),
    (318, 206, 13, 'Diamonds');

-- Poker: straight
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (319, 207, 3, 'Hearts'),
    (320, 207, 4, 'Clubs'),
    (321, 207, 5, 'Diamonds'),
    (322, 207, 6, 'Spades'),
    (323, 207, 7, 'Hearts');

-- Poker: pair
INSERT INTO Cards (card_id, hand_id, card_rank, suit) VALUES
    (324, 208, 9, 'Hearts'),
    (325, 208, 9, 'Spades'),
    (326, 208, 3, 'Clubs'),
    (327, 208, 6, 'Diamonds'),
    (328, 208, 12, 'Hearts');


-- Bets
INSERT INTO Bets (bet_id, hand_id, amount) VALUES
    (401, 201, 25),
    (402, 203, 40),
    (403, 205, 15),
    (404, 205, 10),
    (405, 206, 30),
    (406, 207, 20),
    (407, 208, 35),
    (408, 208, 15);
