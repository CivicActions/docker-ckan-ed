FROM alpine:3.7
ENV TERM=xterm

RUN apk add --no-cache curl \
    bash \
    net-tools \
    procps
MAINTAINER Keitaro Inc <info@keitaro.info>

ENV APP_DIR=/srv/app
ENV GIT_BRANCH 0.0.15
ENV GIT_URL https://github.com/ckan/datapusher.git
ENV JOB_CONFIG ${APP_DIR}/datapusher_settings.py

WORKDIR ${APP_DIR}

RUN apk add --no-cache python \
    py-pip \
    py-gunicorn \
    libffi-dev \
    libressl-dev \
    libxslt && \
    # Temporary packages to build CKAN requirements
    apk add --no-cache --virtual .build-deps \
    gcc \
    git \
    musl-dev \
    python-dev \
    libxml2-dev \
    libxslt-dev && \
    cryptography==1.3.4 && \
    cffi==1.12

    # Fetch datapusher and install
RUN mkdir ${APP_DIR}/src && cd ${APP_DIR}/src && \
    git clone -b ${GIT_BRANCH} --depth=1 --single-branch ${GIT_URL} && \
    cd datapusher && \
    pip install --upgrade pip==20.3.3 && \
    python setup.py install && \
    pip install --no-cache-dir -r requirements.txt && \
    # Remove temporary packages and files
    apk del .build-deps && \
    rm -rf ${APP_DIR}/src

COPY setup ${APP_DIR}

EXPOSE 8800
CMD ["gunicorn", "--bind=0.0.0.0:8800", "--log-file=-", "wsgi"]
