with source as (

    select * from {{ source('alembic_ops', 'raw_brew_events') }}

),

renamed as (

    select
        brew_id,
        potion_sku,
        shop_id,
        cauldron_id,
        try_to_timestamp_ntz(brewed_at) as brewed_at,
        try_to_number(batch_size) as batch_size,
        try_to_number(brew_duration_minutes) as brew_duration_minutes,
        lower(trim(quality_check)) as quality_check,
        trim(brewer_name) as brewer_name
    from source

)

select * from renamed
