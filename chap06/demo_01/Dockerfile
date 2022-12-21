FROM python:3.7

RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
RUN pip install Flask==2.2.2 uwsgi==2.0.21 requests==2.26.0

WORKDIR /app

COPY app /app
COPY cmd.sh /

EXPOSE 9090 9191

USER uwsgi

CMD ["/cmd.sh"]