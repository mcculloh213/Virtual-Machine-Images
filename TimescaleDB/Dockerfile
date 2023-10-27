FROM timescale/timescaledb:latest-pg13
LABEL maintainer="mccullough@endtoendinnovations.com"

# Replace these in `docker-compose.yaml` or `.env`
ENV POSTGRES_USER=postgres
ENV POSGRES_PASSWORD=password

COPY ./docker-entrypoint-initdb.d/init-application-db.sql /docker-entrypoint-initdb.d/init-application-db.sql
COPY ./docker-entrypoint-initdb.d/init-stocks-real-time-tutorial.sql /docker-entrypoint-initdb.d/init-stocks-real-time-tutorial.sql
COPY ./docker-entrypoint-initdb.d/tutorial_sample_company.csv /docker-entrypoint-initdb.d/tutorial_sample_company.csv 
COPY ./docker-entrypoint-initdb.d/tutorial_sample_tick.csv /docker-entrypoint-initdb.d/tutorial_sample_tick.csv 
