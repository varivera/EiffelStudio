
-- Command to update the Eiffel

class UPDATE_PROJECT 

inherit

	SHARED_WORKBENCH;
	PROJECT_CONTEXT;
	ICONED_COMMAND;
	SHARED_DEBUG;
	SHARED_RESCUE_STATUS;
	SHARED_FORMAT_TABLES;
	EXCEPTIONS
		rename
			raise as excep_raise
		end

creation

	make

feature

	make (c: COMPOSITE; a_text_window: TEXT_WINDOW) is
		do
			init (c, a_text_window);
			!!request
		end;

feature {NONE}

	reset_debugger is
		do
			debug_info.wipe_out;
			quit_cmd.exit_now;
			if Run_info.is_running then
				debug_window.clear_window;   
				debug_window.put_string ("System terminated%N");
				debug_window.display;
				run_info.set_is_running (false)
			end
		end;

	not_saved: BOOLEAN is
			-- Has the text of some tool been edited and not saved?
		do
			Result := window_manager.class_win_mgr.changed or
				system_tool.text_window.changed
		end;

	compile (argument: ANY) is
		local
			rescued: BOOLEAN;
			temp: STRING
		do
			if not rescued then
				reset_debugger;
				error_window.clear_window;
				set_global_cursor (watch_cursor);
				project_tool.set_changed (true);
				Workbench.recompile;
				if Workbench.successfull then
					freezing_actions;
					project_tool.set_changed (false);
					project_tool.set_icon_name (System.system_name);
					system.server_controler.wipe_out; -- ???
					save_failed := False;
					save_workbench_file;
					if save_failed then
						!! temp.make (0);
						temp.append ("Could not write to ");
						temp.append (Project_file_name);
						temp.append ("%NPlease check permissions and disk space%
									%%NThen press ");
						temp.append (command_name);
						temp.append (" again%N");
						error_window.put_string (temp);
					else
						finalization_actions (argument);
						launch_c_compilation (argument);
					end;
				end;
				tool_resynchronization (argument)
			else
					-- The project may be corrupted => the project
					-- becomes read-only.
				warner (text_window).gotcha_call (w_Project_may_be_corrupted);
				Project_read_only.set_item (true)
			end;
			error_window.display;
			restore_cursors
		rescue
			if not Rescue_status.fail_on_rescue then
				if original_exception = Io_exception then
						-- We probably don't have the write permissions
						-- on the server files.
					rescued := true;
					retry
				end
			end
		end;

	tool_resynchronization (argument: ANY) is
			-- Resynchronize class, feature and system tools.
			-- Clear the format_context buffers.
		local
			saved_msg, messages: STRING;
		do
				-- `image' is a once function which will be overewritten
				-- during the resynchronization of the class and feature
				-- tools. We need a copy of it to keep track of various
				-- error messages generated by the compilation.
			messages := error_window.image;
			!! saved_msg.make (messages.count);
			saved_msg.append (messages);
			Window_manager.class_win_mgr.synchronize;
			Window_manager.routine_win_mgr.synchronize;
			if system_tool.realized and then system_tool.shown then
				system_tool.set_default_format;
				system_tool.synchronize
			end;
			messages.wipe_out;
			messages.append (saved_msg);

				-- Clear the format_context buffers.
			clear_format_tables
		end;

	launch_c_compilation (argument: ANY) is
		do
			error_window.put_string ("System recompiled%N");
			if System.freezing_occurred then
				error_window.put_string 
					("System had to be frozen to include new externals.%N%
						%Background C compilation launched.%N");
				finish_freezing 
			else
				link_driver
			end;		
		end;

	freezing_actions is
		do
		end;

	finalization_actions (argument: ANY) is
		do
		end;

	confirm_and_compile (argument: ANY) is
		do
			if 
				not Run_info.is_running or else
				(argument /= Void and 
				argument = last_confirmer and end_run_confirmed)
			then
				compile (argument)
			else
				confirmer (text_window).call (Current, 
						"Recompiling project will end current run.%N%
						%Start compilation anyway?", "Compile");
				end_run_confirmed := true
			end
		end;

	end_run_confirmed: BOOLEAN;
			-- Was the last confirmer popped up to confirm the end of run?

	work (argument: ANY) is
			-- Recompile the project.
		local
			fn: STRING;
			f: PLAIN_TEXT_FILE;
			temp: STRING
		do
			if Project_read_only.item then
				warner (text_window).gotcha_call (w_Cannot_compile)
			elseif project_tool.initialized then
				if not_saved and  argument = text_window then
					confirmer (text_window).call (Current, 
						"Some files have not been saved.%N%
						%Start compilation anyway?", "Compile");
					end_run_confirmed := false
				else
					if Lace.file_name /= Void then
						confirm_and_compile (argument);
						project_tool.raise
					elseif argument = Void then
						system_tool.display;	
						load_default_ace;	
					elseif argument = last_warner then
						name_chooser.set_window (text_window);
						name_chooser.call (Current)
					elseif argument = name_chooser then
						fn := clone (name_chooser.selected_file);
						!! f.make (fn);
						if
							f.exists and then f.is_readable and then f.is_plain
						then
							Lace.set_file_name (fn);
							work (Current)
						else
							warner (text_window).custom_call 
								(Current, w_Cannot_read_file_retry (fn), 
								" OK ", Void, "Cancel");
						end
					else
						warner (text_window).custom_call (Current, 
							l_Specify_ace, "Choose", "Template", "Cancel");
					end;
				end
			end;
		end;

	link_driver is
		local
			arg2: STRING;
			cmd_string: STRING;
			uf: RAW_FILE;
		do
			if System.uses_precompiled then
					-- Target
				arg2 := build_path (Workbench_generation_path,
									System.system_name);
				!!uf.make (arg2);
				if not uf.exists then
						-- Request
					!!cmd_string.make (200);
					cmd_string.append
							("$EIFFEL3/bench/spec/$PLATFORM/bin/prelink ");
					cmd_string.append (Precompilation_driver);
					cmd_string.append (" ");
					cmd_string.append (arg2);
					request.set_command_name (cmd_string);
					request.send
				end;
			end;
		end;

	retried: BOOLEAN;
	save_failed: BOOLEAN;

	save_workbench_file is
			-- Save the `.workbench' file.
		local
			file: RAW_FILE
		do
			if not retried then
				System.server_controler.wipe_out;
				!!file.make (Project_file_name);
				file.open_write;
				workbench.basic_store (file);
				file.close;
			else
				retried := False
				if not file.is_closed then
					file.close
				end;
				save_failed := True;
			end
		rescue
			if Rescue_status.is_unexpected_exception then
				retried := True;
				retry
			end
		end;

feature {NONE}

	request: ASYNC_SHELL;

	load_default_ace is
		require
			project_tool.initialized
		local
			file_name: STRING;
		do
				!!file_name.make (50);	
				file_name.append (Default_ace_name);
				system_tool.text_window.show_file_content (file_name);
				system_tool.text_window.set_changed (True)
		end;

	c_code_directory: STRING is
		do
			Result := Workbench_generation_path
		end;

feature

	finish_freezing is
		local
			d: DIRECTORY;
			cmd, cp_cmd: STRING;
		do
			!!cmd.make (50);
			cmd.append ("cd ");
			cmd.append (c_code_directory);
			cmd.append ("; ");
			cmd.append (Finish_freezing_script);
 
			!!d.make (c_code_directory);
			if not d.has_entry (Finish_freezing_script) then
				!!cp_cmd.make (50);
				cp_cmd.append (Copy_cmd);
				cp_cmd.extend (' ');
				cp_cmd.append (freeze_command_name);
				cp_cmd.extend (' ');
				cp_cmd.append (c_code_directory);
				cp_cmd.append ("; ");
				cmd.prepend (cp_cmd);
			end;
			request.set_command_name (cmd);
			request.send;
		end;

	symbol: PIXMAP is
		once
			Result := bm_Update
		end;
 
	
feature {NONE}

	command_name: STRING is do Result := l_Update end;

end
