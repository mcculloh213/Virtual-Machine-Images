FROM timescale/timescaledb:latest-pg13
LABEL maintainer="mccullough@endtoendinnovations.com"

# Replace these in `docker-compose.yaml`
ENV POSTGRES_USER=postgres
ENV POSGRES_PASSWORD=password

COPY --chown=${POSTGRES_USER}:${POSTGRES_USER} ./docker-entrypoint-initdb.d/init-docker-db.sh /docker-entrypoint-initdb.d/