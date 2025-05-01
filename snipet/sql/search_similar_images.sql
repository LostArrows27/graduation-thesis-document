BEGIN
    RETURN QUERY
    WITH search_history_features AS (
        SELECT text_features FROM public.search_history 
        WHERE id = search_history_id
    )
    SELECT
        i.id AS image_id, i.image_name, i.image_bucket_id,
        -- Calculate cosine similarity
        (1 - (i.image_features <=> sh.text_features)) AS similarity
    FROM
        public.image i, search_history_features sh
    WHERE
        i.uploader_id = user_id
        AND (1 - (i.image_features <=> sh.text_features)) >= similarity_threshold
    ORDER BY similarity DESC;
END;
