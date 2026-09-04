{{ config(materialized='table') }}

select *
from read_csv_auto('data/raw/olist_order_payments_dataset.csv')