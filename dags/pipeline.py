from datetime import datetime, timedelta
from loguru import logger
from pathlib import Path
from airflow.decorators import dag, task
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig
from src.extract import extract as extract_main  
from src.load import load as load_main            


@dag(
    dag_id="olist_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["olist", "dbt", "cosmos"],
    description="Pipeline ETL para dados Olist + transformações dbt",
    default_args={
        "retries": 2,
        "retry_delay": timedelta(minutes=2),
        "owner": "data-team",
    },
)
def olist_pipeline():

    @task()
    def extract():
        logger.info("Iniciando extração de dados...")
        extract_main() 
        logger.info("Extração concluída")

    @task()
    def load():
        logger.info("Iniciando carregamento de dados...")
        load_main() 
        logger.info("Carregamento concluído")

    dbt = DbtTaskGroup(
        group_id="dbt",
        project_config=ProjectConfig(
            dbt_project_path="/usr/local/airflow/dbt"  
        ),
        profile_config=ProfileConfig(
            profile_name="olist",
            target_name="prod", 
            profiles_yml_filepath="/usr/local/airflow/dbt/profiles.yml",
        ),
    )

    extract() >> load() >> dbt


olist_pipeline()