# syntax=docker/dockerfile:1.4
FROM python:3.9.11-alpine3.15 AS builder

# hadolint ignore=DL3013,DL3018
RUN apk update && \
    apk add --no-cache make g++ && \
    pip install --upgrade --no-cache-dir poetry

WORKDIR /build
COPY . ./
RUN poetry config virtualenvs.create false && \
    poetry install --no-dev && \
    poetry build


FROM python:$3.9.11-alpine3.15 AS runtime
LABEL\
  org.label-schema.schema-version="1.1.0"\
  org.label-schema.name="__PROJECT_NAME__"\
  org.label-schema.vendor="ibm.com"\
  org.label-schema.url="https://research.ibm.com"\
  org.label-schema.description="__PROJECT_DESCRIPTION__"\
  org.label-schema.vcs-url="https://github.ibm.com/IBM-Q-Software/__PROJECT_GITHUB__"\
  org.label-schema.usage="https://github.ibm.com/IBM-Q-Software/__PROJECT_GITHUB__/README.md"\
  org.label-schema.maintainer="javier.juarez.martinez@ibm.com"

COPY --from=builder /build/dist/__PROJECT_PACKAGE__-*-py3-none-any.whl /tmp/
RUN pip install --no-cache-dir /tmp/__PROJECT_PACKAGE__-*-py3-none-any.whl

# Adds a non-privileged user
ARG GROUP_NAME="services"
ARG USER_NAME="srvuser"
RUN addgroup -S ${GROUP_NAME} && \
    adduser -S -D ${USER_NAME} -s /bin/sh -h /home/${USER_NAME} -g "Service User" -G ${GROUP_NAME}
USER ${USER_NAME}
CMD ["/bin/sh"]
