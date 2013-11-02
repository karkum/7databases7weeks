create rule update_holidays as on update to holidays do instead
update events set title = NEW.name, starts=NEW.date. colors = NEW.colors where title=OLD.name;

