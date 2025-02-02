FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2-binary argparse

WORKDIR /app
COPY ingestion.py ingestion.py

CMD ["python", "ingestion.py"]
