FROM python:3.7-alpine AS compile-image
RUN apk add --no-cache build-base

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN pip install ruamel.yaml argparse \
  && wget https://raw.githubusercontent.com/jumanjihouse/pre-commit-hook-yamlfmt/0.1.0/pre_commit_hooks/yamlfmt \
       -O /opt/venv/bin/yamlfmt \
  && chmod +x /opt/venv/bin/yamlfmt

FROM python:3.7-alpine

ENV PATH="/opt/venv/bin:$PATH"

RUN set -ex \
 && addgroup -g 1000 "yamlfmt" \
 && adduser -D -u 1000 -G "yamlfmt" "yamlfmt"

COPY --from=compile-image /opt/venv /opt/venv

ENTRYPOINT ["/opt/venv/bin/yamlfmt"]

CMD ["--help"]
