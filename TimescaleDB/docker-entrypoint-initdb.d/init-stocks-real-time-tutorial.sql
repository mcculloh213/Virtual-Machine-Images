CREATE ROLE user_stocks WITH
    LOGIN
    NOSUPERUSER
    NOINHERIT
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    PASSWORD 'password';

COMMENT ON ROLE user_stocks IS 'Real-Time stocks application user.';

CREATE DATABASE stocks
    WITH
    OWNER = user_stocks
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE stocks
    IS 'Real-Time stocks application database.';

GRANT CREATE, CONNECT ON DATABASE stocks TO user_stocks;

\c stocks

GRANT ALL ON SCHEMA public to user_stocks;

CREATE TABLE stocks_real_time (
    time TIMESTAMPTZ NOT NULL,
    symbol TEXT NOT NULL,
    price DOUBLE PRECISION NULL,
    day_volume INT NULL
);

SELECT create_hypertable('stocks_real_time', 'time');

CREATE INDEX ix_symbol_time ON stocks_real_time (symbol, time DESC);

CREATE TABLE company (
    symbol TEXT NOT NULL,
    name TEXT NOT NULL
);

\COPY stocks_real_time from '/docker-entrypoint-initdb.d/tutorial_sample_tick.csv' DELIMITER ',' CSV HEADER;
\COPY company FROM '/docker-entrypoint-initdb.d/tutorial_sample_company.csv' DELIMITER ',' CSV HEADER;