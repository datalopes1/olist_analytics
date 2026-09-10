from pathlib import Path

import dlt
from dlt.sources.filesystem import filesystem, read_csv

RAW_DATA_PATH = Path("./data/")


@dlt.resource(table_name="customers", write_disposition="replace")
def customers():
    file_path = RAW_DATA_PATH / "olist_customers_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="geolocation", write_disposition="replace")
def geolocation():
    file_path = RAW_DATA_PATH / "olist_geolocation_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="order_items", write_disposition="replace")
def order_items():
    file_path = RAW_DATA_PATH / "olist_order_items_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="order_payments", write_disposition="replace")
def order_payments():
    file_path = RAW_DATA_PATH / "olist_order_payments_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="order_reviews", write_disposition="replace")
def order_reviews():
    file_path = RAW_DATA_PATH / "olist_order_reviews_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="orders", write_disposition="replace")
def orders():
    file_path = RAW_DATA_PATH / "olist_orders_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="products", write_disposition="replace")
def products():
    file_path = RAW_DATA_PATH / "olist_products_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.resource(table_name="sellers", write_disposition="replace")
def sellers():
    file_path = RAW_DATA_PATH / "olist_sellers_dataset.csv"
    yield from filesystem(bucket_url=str(file_path), file_glob="") | read_csv

@dlt.source
def olist_raw():
    return [
        customers(),
        geolocation(),
        order_items(),
        order_payments(),
        order_reviews(),
        orders(),
        products(),
        sellers()
    ]


def load():
    pipeline = dlt.pipeline(
        pipeline_name="olist_raw",
        destination="postgres",
        dataset_name="raw",
    )

    load_info = pipeline.run(olist_raw())
    return print(load_info)


if __name__ == "__main__":
    load()
