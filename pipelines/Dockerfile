FROM python:3.9.1

WORKDIR /app
COPY ingestion.py .

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2-binary argparse

ENTRYPOINT ["python", "ingestion.py"]