{% if target.type == 'snowflake' %}

select
    payload:id::integer as state_id,
    payload:sigla::string as state_code,
    payload:nome::string as state_name,
    payload:regiao:id::integer as region_id,
    payload:regiao:sigla::string as region_code,
    payload:regiao:nome::string as region_name,
    load_timestamp
from {{ source('ibge', 'states_raw') }}

{% elif target.type == 'duckdb' %}

select
    id::integer as state_id,
    sigla::varchar as state_code,
    nome::varchar as state_name,
    regiao.id::integer as region_id,
    regiao.sigla::varchar as region_code,
    regiao.nome::varchar as region_name,
    current_timestamp as load_timestamp
from read_json_auto('../ingestion/ibge_states_raw.json')

{% endif %}