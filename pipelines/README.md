# Data Engineering Course - Pipelines

## Building the Docker Image

To build the Docker image, run the following command:

```sh
docker build -t trip_ingestion .
```

## Running the Ingestion Script

To run the ingestion script using Docker, use the following command:

```sh
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"

docker run -it --network=DE_NETWORK trip_ingestion \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table=green_taxi_trips \
    --data_url=${URL}
```

Make sure to replace the placeholder values with your actual database credentials and network settings.
