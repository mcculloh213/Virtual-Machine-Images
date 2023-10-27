FROM timescale/timescaledb:latest-pg13
LABEL maintainer="mccullough@endtoendinnovations.com"

# Replace these in `docker-compose.yaml` or `.env`
ENV POSTGRES_USER=postgres
ENV POSGRES_PASSWORD=password
ENV TEST_USER=user_test
ENV TEST_PASSWORD=password
ENV TEST_DATABASE=test

RUN mkdir -p /docker-entrypoint-initdb.d/
COPY ./docker-entrypoint-initdb.d/init-application-db.sh /docker-entrypoint-initdb.d/init-application-db.sh
RUN chown -R ${POSTGRES_USER}:${POSTGRES_USER} /docker-entrypoint-initdb.d