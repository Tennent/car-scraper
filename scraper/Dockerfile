FROM python:3.12 as build-image

ARG FUNCTION_DIR="/scraper"

RUN mkdir -p ${FUNCTION_DIR}
COPY . ${FUNCTION_DIR}

RUN pip install \
    --target ${FUNCTION_DIR} \
    -r ${FUNCTION_DIR}/requirements.txt


FROM python:3.12-slim

ARG FUNCTION_DIR="/scraper"

WORKDIR ${FUNCTION_DIR}

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

CMD [ "scraper.handler" ]
