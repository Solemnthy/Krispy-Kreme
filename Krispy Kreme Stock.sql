-- yearly performance overview
select 
    strftime('%Y', `date`) as year,
    avg(`close`) as avg_close_price,
    sum(`volume`) as total_volume
from 
    `dnut`
group by 
    year
order by 
    year asc;

-- price volatility analysis
select 
    `date`,
    (`high` - `low`) / `low` * 100 as price_fluctuation_percent
from 
    `dnut`
where 
    (`high` - `low`) / `low` * 100 > 5
order by 
    price_fluctuation_percent desc;

-- moving averages for trend analysis
select 
    `date`, 
    avg(`close`) over (order by `date` rows between 49 preceding and current row) as `50_day_moving_avg`,
    avg(`close`) over (order by `date` rows between 199 preceding and current row) as `200_day_moving_avg`
from 
    `dnut`
order by 
    `date` asc;

-- peak trading volume days
select 
    `date`, 
    `volume`
from 
    `dnut`
where 
    `volume` = (select max(`volume`) from `dnut`)
order by 
    `volume` desc;

-- most profitable days
select 
    `date`, 
    `close`
from 
    `dnut`
where 
    `close` = (select max(`close`) from `dnut`)
order by 
    `date` asc;

-- bearish and bullish trends
select 
    `date`,
    case 
        when `close` > lag(`close`, 5) over (order by `date`) then 'Bullish Trend'
        when `close` < lag(`close`, 5) over (order by `date`) then 'Bearish Trend'
        else 'Neutral'
    end as trend_direction
from 
    `dnut`
order by 
    `date` asc;

-- volume-price correlation
select 
    `date`, 
    `close`, 
    `volume`
from 
    `dnut`
order by 
    `date` asc;

-- historical highs and lows
select 
    max(`high`) as all_time_high,
    min(`low`) as all_time_low
from 
    `dnut`;
