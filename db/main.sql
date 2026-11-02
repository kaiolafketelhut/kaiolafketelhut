-- main.sql - KDP profile as a database (SQLite / ANSI SQL; also imports into Access via ODBC or CSV)
CREATE TABLE profile (
    id        INTEGER PRIMARY KEY,
    nickname  TEXT NOT NULL,
    code      TEXT NOT NULL,
    role      TEXT NOT NULL,
    points    INTEGER NOT NULL
);
INSERT INTO profile (nickname, code, role, points)
VALUES ('KDPMember:KL5UQ4f48673352', 'KL5UQ4f48673352', 'Member', 1);
