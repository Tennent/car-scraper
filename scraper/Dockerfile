FROM python:3.12-slim

ARG FUNCTION_DIR="/scraper"

RUN mkdir -p ${FUNCTION_DIR}
COPY . ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

CMD [ "scraper.handler" ]
