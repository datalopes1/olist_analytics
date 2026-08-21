import dlt
from dlt.sources.filesystem import filesystem, read_jsonl


@dlt.resource(
    table_name="customers", write_disposition="merge", primary_key="customer_id"
)
def customers():
    file_path = "./data/raw/olist_customers_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(table_name="geolocation", write_disposition="replace")
def geolocation():
    file_path = "./data/raw/olist_geolocation_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(
    table_name="order_items",
    write_disposition="merge",
    primary_key=["order_id", "order_item_id"],
)
def order_items():
    file_path = "./data/raw/olist_order_items_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(
    table_name="order_payments",
    write_disposition="merge",
    primary_key="order_id",
)
def order_payments():
    file_path = "./data/raw/olist_order_payments_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(
    table_name="order_reviews",
    write_disposition="merge",
    primary_key="review_id",
)
def order_reviews():
    file_path = "./data/raw/olist_order_reviews_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(table_name="orders", write_disposition="merge", primary_key="order_id")
def orders():
    file_path = "./data/raw/olist_orders_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(
    table_name="products", write_disposition="merge", primary_key="product_id"
)
def products():
    file_path = "./data/raw/olist_products_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.resource(table_name="sellers", write_disposition="merge", primary_key="seller_id")
def sellers():
    file_path = "./data/raw/olist_sellers_dataset.jsonl"
    yield from filesystem(bucket_url=file_path, file_glob="") | read_jsonl()


@dlt.source
def olist_source():
    return [
        customers(),
        geolocation(),
        order_items(),
        order_payments(),
        order_reviews(),
        orders(),
        products(),
        sellers(),
    ]


pipeline = dlt.pipeline(
    pipeline_name="olist", destination="postgres", dataset_name="raw"
)

load_info = pipeline.run(olist_source())
print(load_info)
