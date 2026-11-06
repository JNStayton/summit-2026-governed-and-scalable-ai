with source as (

    select * from {{ source('alembic_ops', 'raw_ingredients') }}

),

renamed as (

    select
        ingredient_id,
        trim(ingredient_name) as ingredient_name,
        supplier_id,
        lower(trim(unit)) as unit,
        unit_cost_copper,
        case
            when lower(trim(is_hazardous)) in ('true', 't', 'yes', 'y', '1') then true
            when lower(trim(is_hazardous)) in ('false', 'f', 'no', 'n', '0') then false
        end as is_hazardous,
        trim(harvest_season) as harvest_season
    from source

)

select * from renamed
