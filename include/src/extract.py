from pathlib import Path
from time import perf_counter

import kagglehub
import pandas as pd
from loguru import logger

RAW_PATH = Path("./include/data/")
TABLES = [
    "olist_customers_dataset",
    "olist_geolocation_dataset",
    "olist_order_items_dataset",
    "olist_order_payments_dataset",
    "olist_order_reviews_dataset",
    "olist_orders_dataset",
    "olist_products_dataset",
    "olist_sellers_dataset",
]


def extract() -> None:
    """Realiza a extração de dados do dataset Brazilian E-Commerce Public Dataset by Olist no Kaggle"""
    kaggle_dataset = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
    try:
        start = perf_counter()
        for idx, table in enumerate(TABLES, start=1):
            logger.info(
                "[{}/{}] - Extração da tabela {} iniciada.", idx, len(TABLES), table
            )

            temp_df = pd.read_csv(f"{kaggle_dataset}/{table}.csv")
            temp_df.to_csv(f"{RAW_PATH}/{table}.csv", index=False)

            logger.info(
                "Extração da tabela {} bem sucedida. {} linhas carregadas.",
                table,
                len(temp_df),
            )

        elapsed = perf_counter() - start
        logger.success(
            "Extração de dados bem sucedida. Processo realizado em {:.2f}s.", elapsed
        )
    except Exception:
        logger.exception("Erro na extração dos dados.")
        raise


if __name__ == "__main__":
    extract()
