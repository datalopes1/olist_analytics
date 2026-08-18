from time import perf_counter

import kagglehub
import pandas as pd
from loguru import logger


def get_kaggle_data(kaggle_path: str, datasets: list) -> None:
    """
    Extrai datasets a partir do Kaggle.

    Args:
        kaggle_path (str): Caminho para o dataset do Kaggle.
        datasets (list): Lista de arquivos que serão extraídos.
    """
    try:
        logger.info("Iniciando a extração de dados.")
        start = perf_counter()

        for idx, dataset in enumerate(datasets, start=1):
            logger.info("[{}/{}]Processando o arquivo: {}", idx, len(datasets), dataset)
            temp_df = pd.read_csv(f"{kaggle_path}/{dataset}.csv")
            temp_df.to_json(
                f"data/raw/{dataset}.jsonl",
                orient="records",
                force_ascii=False,
                lines=True,
                index=False,
            )
            logger.info(
                "Dataset {} extraído. {} linhas carregadas.", dataset, len(temp_df)
            )
        elapsed = perf_counter() - start
        logger.success(
            "Extração de dados concluída com sucesso. Dados processados em {:.2f}s.",
            elapsed,
        )
    except Exception:
        logger.exception("Erro na extração dos dados")
        raise


def extract():
    """
    Executa a extração de dados.
    """
    kaggle_path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
    datasets = [
        "olist_customers_dataset",
        "olist_geolocation_dataset",
        "olist_order_items_dataset",
        "olist_order_payments_dataset",
        "olist_order_reviews_dataset",
        "olist_orders_dataset",
        "olist_products_dataset",
        "olist_sellers_dataset",
        "product_category_name_translation",
    ]

    get_kaggle_data(kaggle_path, datasets)


if __name__ == "__main__":
    extract()
