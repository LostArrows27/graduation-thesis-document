CREATE OR REPLACE FUNCTION notify_new_image_face_detection()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify('image_face_detection', row_to_json(NEW)::text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_image_face_detection
AFTER INSERT ON public.image
FOR EACH ROW
EXECUTE FUNCTION notify_new_image_face_detection();