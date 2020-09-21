CREATE OR REPLACE FUNCTION UpdateAgentPopNames() RETURNS void AS $$
BEGIN
  Declare
  admin_user integer[] DEFAULT  ARRAY[]::INTEGER[];
  agent_pop_ids integer[] DEFAULT  ARRAY[]::INTEGER[];
  _index integer;
  _value integer;
  _count integer; 
  replace_string varchar; 
  BEGIN

    admin_user := (SELECT ARRAY(select account_id from agent_pops group by account_id));

    FOREACH _index IN ARRAY admin_user
    LOOP
      agent_pop_ids := (SELECT ARRAY(Select id from agent_pops where account_id=_index and name IS NULL));
      raise notice 'account id: %', _index;
      _count := 0;

      FOREACH _value IN ARRAY agent_pop_ids
      LOOP
        _count := _count + 1;
        replace_string := (SELECT concat('Custom_Context_Pop_', _count));

        raise notice 'agent_pops id: %', _value;
        update agent_pops set name=replace_string where id=_value;
      END LOOP;
    END LOOP;
  END;
END;
$$ LANGUAGE plpgsql;

SELECT UpdateAgentPopNames();
