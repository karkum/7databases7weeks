create or replace function find_movies_by_actors(search text)
returns setof movies as $$
declare
  found_name text;
  tempmovie movies%rowtype;
begin
  select into found_name name
  from (
    select a.name as name, levenshtein(lower(search), lower(a.name)) as dist from actors a where metaphone(a.name, 8) = metaphone(search, 8) 
  ) t order by dist limit 1;

  for tempmovie in select m.* from movies m natural join movies_actors natural join actors where name =found_name limit 5 loop
    return next tempmovie;
  end loop;
end;
$$ LANGUAGE plpgsql
