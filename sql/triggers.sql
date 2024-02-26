--Нельзя быть частью распущенной или уничтоженной группы
CREATE FUNCTION update_group_id() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status_id != OLD.status_id THEN
        UPDATE "human" SET grouping_id = NULL WHERE grouping_id = OLD.group_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_group_id
    AFTER UPDATE ON grouping
    FOR EACH ROW
EXECUTE FUNCTION update_group_id();


--Нельзя перемещаться в локацию, в которой вы уже находитесь
CREATE FUNCTION prevent_same_location() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.location1_id = NEW.location2_id THEN
        RAISE EXCEPTION 'Невозможно добавить запись с одинаковыми ID локаций';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_same_location
    BEFORE INSERT ON movements
    FOR EACH ROW
EXECUTE FUNCTION prevent_same_location();


--Если у персонажа уже есть группа, то он не может ее менять
CREATE FUNCTION check_group_id() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.group_id = OLD.group_id AND NEW.group_id IS NOT NULL THEN
        RAISE EXCEPTION 'Если у персонажа уже есть группа, то он не может ее менять';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_group_id
    BEFORE UPDATE ON "human"
    FOR EACH ROW
EXECUTE FUNCTION check_group_id();


--Злодей не может давать дебаффы на задания с боссами(боссы бывают только в сюжетных заданиях)
CREATE FUNCTION check_status_trigger() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status_id = (SELECT id FROM Action_Status WHERE name = 'сюжетная') THEN
        SET NEW.villain_debuf_id = NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_status_trigger
    BEFORE UPDATE ON "action"
    FOR EACH ROW
EXECUTE FUNCTION check_status_trigger();