create or replace function log_event() returns trigger as $$
declare
begin
    insert into logs (event_id, old_title, old_starts, old_ends)
    values(OLD.event_id, OLD.title, OLD.starts, OLD.ends);
    raise notice 'Someone just changed event #%', OLD.event_id;
    return new;
end
$$ language plpgsql;
