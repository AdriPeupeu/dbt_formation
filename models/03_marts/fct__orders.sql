

WITH payments as (
    select
        order_id,
        sum(amount) as amount,
    from {{ ref('stg__payments') }}
        group by order_id
)

SELECT
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    orders.status,
    ifnull(payments.amount, 0) as amount,

    op.bank_transfer_amount,
    op.credit_card_amount,
    op.coupon_amount,
    op.gift_card_amount,

from {{ ref('stg__orders') }} orders
    left join payments using (order_id)
    left join {{ ref('int__orders_pivoted') }} op using(order_id) 

