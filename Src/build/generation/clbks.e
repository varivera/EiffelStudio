

-- Note: Context may be present as key even though they
-- are cut from the interface, but it doesn't matter
-- 'cause it will never be used. In the future, clean
-- up!

class CLBKS 

inherit

	EXTEND_TABLE [CLBK, CONTEXT]
		rename
			make as extend_table_create
		export
			{NONE} all;
			{ANY} has, clear_all
		select
			twin
		end;

	APP_SHARED
		rename
			twin as app_share_twin
		export
			{NONE} all
		end


creation

	make

	
feature 

	eiffel_text (c: CONTEXT): STRING is
--		require
--			Context_has_callbacks: has (c)
		local
			pre_fix: STRING;
			full_name: STRING;
		do
			!!Result.make (0);
			Result.append ("%N%Tset_");
			if not c.is_root then
				full_name := c.full_name;
				full_name.remove_all_occurrences ('.');
				Result.append (full_name);
				Result.append ("_");
			end; 
			Result.append ("callbacks is%N");
			if c.is_root then
				pre_fix := ""
			else
				pre_fix := c.full_name
			end;
			if has (c) then			
				Result.append (item (c).eiffel_text (pre_fix));
			end;
			if c.is_root then
				if not has (c) then
					Result.append ("%T%Tdo%N");
				end;
				Result.append (c.eiffel_callback_calls)
			end;
			Result.append ("%T%Tend;%N");
		end;

	make is
		do
			extend_table_create (10)
		end;

	update is
		local
			state_list: LINKED_LIST [STATE]
		do
			from
				state_list := graph.states;
				state_list.start
			until
				state_list.after
			loop
				process_state (state_list.item);
				state_list.forth
			end;
		end;

	current_state: STATE;

	
feature {NONE}

	process_state (s: STATE) is
		local
			clbk: CLBK;
			old_pos: INTEGER;
			b: BEHAVIOR
		do
			current_state := s;
			from
				old_pos := s.position;
				s.start
			until
				s.off
			loop
				clbk := item (s.input.original_stone);
				b := s.output.original_stone;
				if not b.empty then
					if (clbk = Void) then
						!!clbk.make (s.output);
						put (clbk, s.input.original_stone);
					else
						clbk.update (s.output);
					end;
				end;
				s.forth
			end;
			s.go_i_th (old_pos)
		end;

end
