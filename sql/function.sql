CREATE OR REPLACE FUNCTION get_main_actions() RETURNS TABLE (
                                                                name VARCHAR,
                                                                location_name VARCHAR,
                                                                debuff_name VARCHAR,
                                                                action_type_name VARCHAR,
                                                                status_name VARCHAR
                                                            ) AS $$
BEGIN
    RETURN QUERY
        SELECT a.name, l.name, vd.name, at.name, ast.name
        FROM action a
                 JOIN location l ON a.location_id = l.id
                 JOIN villain_debuffs vd ON a.villain_debuff_id = vd.id
                 JOIN action_type at ON a.action_type_id = at.id
                 JOIN action_status ast ON a.status_id = ast.id
        WHERE a.status_id = (SELECT id FROM action_status WHERE status_name = 'сюжетная')
                            LIMIT 3;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_secondary_actions() RETURNS TABLE (
                                                                     name VARCHAR,
                                                                     location_name VARCHAR,
                                                                     debuff_name VARCHAR,
                                                                     action_type_name VARCHAR,
                                                                     status_name VARCHAR
                                                                 ) AS $$
BEGIN
    RETURN QUERY
        SELECT a.name, l.name, vd.name, at.name, ast.name
        FROM action a
                 JOIN location l ON a.location_id = l.id
                 JOIN villain_debuffs vd ON a.villain_debuff_id = vd.id
                 JOIN action_type at ON a.action_type_id = at.id
                 JOIN action_status ast ON a.status_id = ast.id
        WHERE a.status_id = (SELECT id FROM action_status WHERE status_name = 'побочная')
                            LIMIT 3;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE finish_action(actionId INT)
AS $$
DECLARE
    actionTypeId INT;
BEGIN
    SELECT id INTO actionTypeId FROM action_type WHERE name = 'выполнена';
    UPDATE action
    SET action_type_id = actionTypeId
    WHERE id = actionId;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_results_with_completed_actions() RETURNS TABLE (result_name VARCHAR, result_description VARCHAR)
AS $$
BEGIN
    RETURN QUERY
        SELECT res.name
        FROM result res
                 INNER JOIN action_to_result atr ON res.id = atr.result_id
                 INNER JOIN action a ON atr.action_id = a.id
                 INNER JOIN action_type at ON a.action_type_id = at.id
        WHERE at.name = 'выполнена';
END;
$$ LANGUAGE plpgsql;