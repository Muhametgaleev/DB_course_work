CREATE PROCEDURE get_main_actions()
BEGIN
    SELECT a.name, l.location_name, vd.debuff_name, at.action_type_name, as.status_name
    FROM action a
    JOIN location l ON a.location_id = l.id
    JOIN villain_debuff vd ON a.villain_debuff_id = vd.id
    JOIN action_type at ON a.action_type_id = at.id
    JOIN action_status as ON a.status_id = as.id
    WHERE a.status_id = (SELECT id FROM action_status WHERE status_name = 'сюжетная')
    LIMIT 3;
END;

CREATE PROCEDURE get_secondary_actions()
BEGIN
    SELECT a.name, l.location_name, vd.debuff_name, at.action_type_name, as.status_name
    FROM action a
    JOIN location l ON a.location_id = l.id
    JOIN villain_debuff vd ON a.villain_debuff_id = vd.id
    JOIN action_type at ON a.action_type_id = at.id
    JOIN action_status as ON a.status_id = as.id
    WHERE a.status_id = (SELECT id FROM action_status WHERE status_name = 'побочная')
    LIMIT 3;
END;

CREATE PROCEDURE finish_action(@actionId INT)
BEGIN
    DECLARE @actionTypeId INT;
    SELECT @actionTypeId = id FROM action_type WHERE name = 'выполнена';
    UPDATE action
    SET action_type_id = @actionTypeId
    WHERE id = @actionId;
END;

CREATE PROCEDURE GetResultsWithCompletedActions()
BEGIN
    SELECT r.*
    FROM result r
    INNER JOIN action_to_result atr ON r.id = atr.result_id
    INNER JOIN action a ON atr.action_id = a.id
    INNER JOIN action_type at ON a.action_type_id = at.id
    WHERE at.name = 'выполнена';
END;