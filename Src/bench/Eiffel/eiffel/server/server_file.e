-- File for server

class SERVER_FILE

inherit
	IDABLE

	PROJECT_CONTEXT

	SHARED_SCONTROL

	SHARED_EIFFEL_PROJECT

creation
	make

feature -- Initialization

	make (i: FILE_ID) is
			-- Initialization
		require
			positive_argument: i /= Void
		local
			f_name: FILE_NAME
			d_name: DIRECTORY_NAME
			temp: STRING
			d: DIRECTORY
		do
			!!d_name.make_from_string (Compilation_path)
			!!temp.make (5)
			temp.extend ('S')
			temp.append_integer (i.packet_number)
			d_name.extend (temp)
			!!d.make (d_name)
			if not d.exists then
				d.create_dir
			end
			!!f_name.make_from_string (d_name)
			f_name.set_file_name (i.file_name)
			file_make (f_name)
			if not Eiffel_project.is_read_only then
					--| Re-finalization after a crash: the COMP
					--| directory doesn't grow and grow and grow
				clear_content
			end
			id := i
debug ("SERVER")
	io.error.put_string ("Creating file ")
	io.error.put_string (i.file_name)
	io.error.new_line
end
		end

feature -- Initialization

	file_make (fn: STRING) is
			-- Create file object with `fn' as file name.
		require
			string_exists: fn /= Void
			string_not_empty: not fn.empty
		do
			name := fn
		ensure
			file_named: name.is_equal (fn)
			file_closed: not is_open
		end

feature -- Access

	name: STRING
			-- File name

	file_pointer: POINTER
			-- File pointer as required in C

	id: FILE_ID
			-- Id of the file

	occurence: INTEGER
			-- Occurence of the file in the server control

	number_of_objects: INTEGER
			-- Number of objects stored in this file including dead
			-- objects

	is_open: BOOLEAN
			-- Is the current file open ?

	descriptor: INTEGER is
			-- File descriptor as used by the operating system.
		require
			file_opened: is_open
		do
			Result := file_fd (file_pointer)
		end

	set_id (i: FILE_ID) is
			-- Assign `i' to `id'.
		do
			id := i
		end

	add_occurence is
			-- Add one occurence.
		do
			occurence := occurence + 1
			number_of_objects := number_of_objects + 1
		end

	remove_occurence is
			-- Remove one occurence and remove current file from
			-- the server controler if null occurence
			--|Note: If occurrence goes down to 0 the file
			--|is not removed from disk straight away, since that
			--|might render a Project irretrievable after an interrupted
			--|compilation. Instead, the file will be removed at the end of a succesful
			--|compilation by the server controller.
		require
			positive_occurence: occurence > 0
		do
			occurence := occurence - 1
			if occurence = 0 then
				Server_controler.forget_file (Current)
			end
		ensure
			occurence = 0 implies (not is_open)
		end

feature -- Status setting
		
	open is
			-- Open file in read mode if precompiled
			-- in read-write otherwise.
		require
			is_closed: not is_open
		local
			external_name: ANY
		do
			external_name := name.to_c
			if Eiffel_project.is_read_only or else precompiled then
					-- Open the file in `Read' mode only.
				file_pointer := file_open ($external_name, 0)
			else
					-- Open the file in `Read-Write' mode.
				file_pointer := file_open ($external_name, 3)
			end
			is_open := True
debug ("SERVER")
	io.error.put_string ("Opening file ")
	io.error.put_string (id.file_name)
	io.error.new_line
end
		ensure
			opened: is_open
		end

	server_open_write is
			-- Open file in append mode only for doing `store_append' in
			-- COMPILER_SERVER
		require
			is_closed: not is_open
		local
			external_name: ANY
		do
			external_name := name.to_c
			file_pointer := file_open ($external_name, 5)
			is_open := True
		ensure
			opened: is_open
		end

	last_offset: INTEGER is
			-- Return the size of the file without checking it exists.
		require
			file_exists: exists
		do
			if not is_open then
				set_buffer
				Result := buffered_file_info.size
			else
				Result := file_size (file_pointer)
			end
		end

	close is
			-- Close server file
		require
			is_open: is_open
		do
			file_close (file_pointer)
			is_open := False
debug ("SERVER")
	io.error.put_string ("Closing file ")
	io.error.put_string (id.file_name)
	io.error.new_line
end
		ensure
			is_closed: not is_open
		end

	clear_content is
			-- Clear the content of a file by opening it
			-- in write-only mode and closing it.
		require
			exists: exists
		local
			external_name: ANY
		do
			external_name := name.to_c
			file_pointer := file_open ($external_name, 1)
			close
		end

	update_path is
			-- Update the file path of Current 
			-- server file. (It might have changed 
			-- between compilations)
		local
			fname: FILE_NAME
			temp: STRING
		do
			!!fname.make_from_string (id.directory_path)
			!!temp.make (5)
			temp.extend ('S')
			temp.append_integer (id.packet_number)
			fname.extend (temp)
			fname.set_file_name (id.file_name)
			name := fname
		end

feature -- Status report

	exists: BOOLEAN is
			-- Does physical file exist?
			-- (Uses effective UID.)
		local
			external_name: ANY
		do
			external_name := name.to_c
			Result := file_exists ($external_name)
		end

	is_readable: BOOLEAN is
			-- Is file readable?
			-- (Checks permission for effective UID.)
		do
			set_buffer
			Result := buffered_file_info.is_readable
		end

	is_writable: BOOLEAN is
			-- Is file writable?
			-- (Checks write permission for effective UID.)
		do
			set_buffer
			Result := buffered_file_info.is_writable
		end

	is_readable_and_writable: BOOLEAN is
			-- Is file readable?
			-- (Checks permission for effective UID.)
		do
			set_buffer
			Result := buffered_file_info.is_readable and buffered_file_info.is_writable
		end

	precompiled: BOOLEAN is
			-- Does the Current server file contain
			-- precompiled information?
		do
			Result := id.is_precompiled
		end

	need_purging: BOOLEAN is
			-- Does the file need purging?
		do
			Result := not (precompiled) and then
				(occurence = 0 or else
				occurence / number_of_objects < .25)
debug ("SERVER")
	trace
	io.error.putstring ("Need purging: ")
	io.error.putbool (Result)
	io.error.new_line
end
		end

feature -- Removal

	delete is
			-- Remove link with physical file.
			-- File does not physically disappear from the disk
			-- until no more processes reference it.
			-- I/O operations on it are still possible.
			-- A directory must be empty to be deleted.
		require
			exists: exists
		local
			external_name: ANY
		do
			external_name := name.to_c
			file_unlink ($external_name)
		end

feature -- Debug

	trace is
		do
			io.error.putstring ("File E")
			io.error.putint (id.id)
			io.error.putstring ("%Nnb objects: ")
			io.error.putint (number_of_objects)
			io.error.putstring ("%Noccurence: ")
			io.error.putint (occurence)
			io.error.putstring ("%Nsize: ")
			io.error.putint (last_offset)
			io.error.putstring ("%Nneed_purging: ")
			io.error.putbool (need_purging)
			io.error.new_line
		end

feature {NONE} -- Implementation

	buffered_file_info: UNIX_FILE_INFO is
			-- Information about the file.
		once
			!! Result.make
		end

	set_buffer is
			-- Resynchronizes information on file
		require
			file_exists: exists
		do
			buffered_file_info.update (name)
		end

	file_open (f_name: POINTER; how: INTEGER): POINTER is
			-- File pointer for file `f_name', in mode `how'.
		external
			"C | %"eif_file.h%""
		alias
			"file_binary_open"
		end

	file_close (file: POINTER) is
			-- Close `file'.
		external
			"C (FILE *) | %"eif_file.h%""
		end

	file_unlink (fname: POINTER) is
			-- Delete file `fname'.
		external
			"C | %"eif_file.h%""
		end

	file_fd (file: POINTER): INTEGER is
			-- Operating system's file descriptor
		external
			"C (FILE *): EIF_INTEGER | %"eif_file.h%""
		end

	file_exists (f_name: POINTER): BOOLEAN is
			-- Does `f_name' exist.
		external
			"C | %"eif_file.h%""
		end

	file_size (file: POINTER): INTEGER is
			-- Size of `file'
		external
			"C (FILE *): EIF_INTEGER | %"eif_file.h%""
		end

end -- class SERVER_FILE
