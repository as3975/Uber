SELECT
    sl.session_id,
    sl.eater_id,
    sl.start_time AS session_start,
    sl.town_name,
    COUNT(DISTINCT f.store_id) AS deliverable_stores,
    COUNT(DISTINCT CASE WHEN fi.is_viewed = 1 THEN f.store_id END) AS impressions,
    COUNT(DISTINCT CASE WHEN fi.is_clicked = 1 THEN f.store_id END) AS clicks,
    COUNT(DISTINCT fo.order_id) AS orders,
    MAX(CASE WHEN fo.order_id IS NOT NULL THEN f.store_id END) AS order_store
FROM
    session_list sl
LEFT JOIN
    feed_items fi ON sl.feed_id = fi.feed_id
LEFT JOIN
    fact_order_log fo ON sl.session_id = fo.session_id
    AND fo.eater_id = sl.eater_id
    AND fo.store_id = f.store_id
GROUP BY
    sl.session_id,
    sl.eater_id,
    sl.start_time,
    sl.town_name;
