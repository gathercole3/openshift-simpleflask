FROM python:3.5.3
MAINTAINER Jacob Gathercole

RUN pip3 -q install gunicorn eventlet

COPY requirements.txt /opt/requirements.txt
COPY requirements_test.txt /opt/requirements_test.txt

RUN pip3 install -q -r /opt/requirements.txt && \
    pip3 install -q -r /opt/requirements_test.txt

COPY / /opt/

EXPOSE 8000

WORKDIR /opt

CMD ["/usr/local/bin/gunicorn", "-k", "eventlet", "--pythonpath", "/opt", "--access-logfile", "-", "manage:manager.app", "--reload", "-b", "0.0.0.0:8000"]
