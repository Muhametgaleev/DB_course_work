--Нельзя быть частью распущенной или уничтоженной группы
CREATE TRIGGER update_group_id
AFTER UPDATE ON grouping
FOR EACH ROW
BEGIN
    IF NEW.status_id != OLD.status_id THEN
        UPDATE Human SET group_id = NULL WHERE group_id = OLD.group_id;
    END IF;
END;




--Нельзя перемещаться в локацию, в которой вы уже находитесь
CREATE TRIGGER prevent_same_location 
BEFORE INSERT ON movements
FOR EACH ROW
BEGIN
    IF NEW.location1_id = NEW.location2_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Невозможно добавить запись с одинаковыми ID локаций';
    END IF;
END;

--Если у персонажа уже есть группа, то он не может ее менять
CREATE TRIGGER check_group_id 
BEFORE UPDATE ON Human
FOR EACH ROW
BEGIN
    IF NEW.group_id = OLD.group_id AND NEW.group_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Если у персонажа уже есть группа, то он не может ее менять';
    END IF;
END;

--Злодей не может давать дебаффы на задания с боссами(боссы бывают только в сюжетных заданиях)
CREATE TRIGGER check_status_trigger
BEFORE UPDATE ON Action
FOR EACH ROW
BEGIN
  IF NEW.status_id = (SELECT id FROM Action_Status WHERE name = 'сюжетная') THEN
    SET NEW.villain_debuf_id = NULL;
  END IF;
END;