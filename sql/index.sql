create index action_to_result_id on action_to_result using hash (result_id);
create index action_id_idx on action using btree (status_id);

--чаще всего мы будем искать задание по его статусу (например, сюжет или побочное)
--так же мы будем часто получать результат и нам нужно его эффективно искать