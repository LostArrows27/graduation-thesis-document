CREATE OR REPLACE FUNCTION public.search_similar_images(
    search_history_id UUID,
    similarity_threshold FLOAT,
    user_id UUID
)
RETURNS TABLE (
    image_id UUID,
    image_name TEXT,
    image_bucket_id TEXT,
    similarity FLOAT
) AS $$
BEGIN
    RETURN QUERY
    WITH search_history_features AS (
        SELECT text_features
        FROM public.search_history
        WHERE id = search_history_id
    )
    SELECT
        i.id AS image_id,
        i.image_name,
        i.image_bucket_id,
        -- Calculate cosine similarity
        (1 - (i.image_features <=> sh.text_features)) AS similarity
    FROM
        public.image i,
        search_history_features sh
    WHERE
        i.uploader_id = user_id
        AND (1 - (i.image_features <=> sh.text_features)) >= similarity_threshold
    ORDER BY
        similarity DESC;
END;
$$ LANGUAGE plpgsql;
