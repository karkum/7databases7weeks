create or replace function find_movies_by_titles(search text)
returns setof movies as $$
declare
  found_name text;
  tempmovie movies%rowtype;
begin
  select into found_name name
  from (
    select m.title as name, levenshtein(lower(search), lower(m.title)) as dist from movies m where to_tsvector('english', m.title) @@ to_tsquery(search) 
  ) t order by dist limit 1;

  for tempmovie in select m.* from movies m, (select genre, title from movies where title=found_name) s where cube_enlarge(s.genre, 5,18) @> m.genre and s.title <>m.title order by cube_distance(m.genre, s.genre) limit 5 loop
    return next tempmovie;
  end loop;
end;
$$ LANGUAGE plpgsql
