FROM python
RUN set -ex && pip install pipenv --upgrade

RUN mkdir /app
WORKDIR /app
COPY Pipfile /app
COPY Pipfile.lock /app
RUN set -ex && pipenv install --deploy --system

COPY . /app

VOLUME /certbot53

ENV PATH="/app:${PATH}"
ENV CERTS_DIR='/certbot53/config/live/'
ENV VAULT_CERT_PATH='secret/letsencrypt/'

CMD /app/certbot53
