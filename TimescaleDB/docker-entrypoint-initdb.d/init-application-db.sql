CREATE ROLE user_test WITH
    LOGIN
    NOSUPERUSER
    NOINHERIT
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    PASSWORD 'password';

COMMENT ON ROLE user_test IS 'Test application user.';

CREATE DATABASE test_database
    WITH
    OWNER = user_test
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE test_database
    IS 'Test application database.';

GRANT CREATE, CONNECT ON DATABASE test_database TO user_test;

\c test_database

GRANT ALL ON SCHEMA public to user_test;