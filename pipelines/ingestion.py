import os
import argparse

from time import time

import pandas as pd
from sqlalchemy import create_engine

def main(args):
    user = args.user
    password = args.password
    host = args.host
    port = args.port
    db = args.db
    table = args.table
    data_url = args.data_url
    
    print(f'Ingesting data from {data_url}')
    
    
    if data_url.endswith('.csv.gz'):
        csv_name = 'output.csv.gz'
    else:
        csv_name = 'output.csv'
        
    print(f'Downloading data to {csv_name}')
        
    os.system(f'wget {data_url} -O {csv_name}')
    
    print(f'Ingesting data into Postgres') 
    
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    # engine.connect()
    
    df_iter = pd.read_csv(csv_name, chunksize=10000, iterator=True)
    
    print(f'Inserting data into {table}')
    
    for df in df_iter:
        try: 
            t_start = time()
            
            df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
            df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])
            
            df.to_sql(name=table, con=engine, if_exists='append')
            
            t_end = time()
            
            print(f'Inserted chunk and took {t_end - t_start} seconds')
        except Exception as e:
            print(f'Error: {e}')
            break


if __name__ == '__main__':
    print('Starting ingestion')
    parser = argparse.ArgumentParser(description='Ingest CSV into Postgres')
    parser.add_argument('--user', type=str, required=True, help='Postgres username')
    parser.add_argument('--password', type=str, required=True, help='Postgres password')
    parser.add_argument('--host', type=str, required=True, help='Postgres host')
    parser.add_argument('--port', type=str, required=True, help='Postgres port')
    parser.add_argument('--db', type=str, required=True, help='Postgres database')
    parser.add_argument('--table', type=str, required=True, help='Postgres table name')
    parser.add_argument('--data_url', type=str, required=True, help='URL to CSV file')
        
        
    args = parser.parse_args()
    
    main(args)
    
    