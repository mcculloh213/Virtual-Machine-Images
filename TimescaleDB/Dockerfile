FROM timescale/timescaledb:latest-pg13
LABEL maintainer="mccullough@endtoendinnovations.com"

# Replace these in `docker-compose.yaml` or `.env`
ENV POSTGRES_USER=postgres
ENV POSGRES_PASSWORD=password

COPY ./docker-entrypoint-initdb.d/init-application-db.sql /docker-entrypoint-initdb.d/init-application-db.sql