indexing
	description	: "Wizard Step."
	author		: "Generated by the Wizard wizard"
	revision	: "1.0.0"

class
	WIZARD_SECOND_STATE

inherit
	WIZARD_INTERMEDIARY_STATE_WINDOW	
		redefine
			update_state_information,
			proceed_with_current_info,
			build
		end
		
	GB_SHARED_SYSTEM_STATUS
	
	GB_NAMING_UTILITIES
	
	GB_CONSTANTS
	
	EIFFEL_RESERVED_WORDS

create
	make

feature -- Basic Operation

	build is 
			-- Build entries.
		do
			if project_settings.complete_project then
				create project_name.make (Current)
				project_name.set_label_string_and_size ("Project name", 50)
				create application_class_name.make (Current)
				application_class_name.set_label_string_and_size ("Application class name", 50)
				project_name.set_text (project_settings.project_name)
				application_class_name.set_text (project_settings.application_class_name)
				project_name.generate
				application_class_name.generate
				
				choice_box.extend (project_name.widget)
				choice_box.extend (application_class_name.widget)
			end
			create window_class_name.make (Current)
			window_class_name.set_label_string_and_size ("Window class name", 50)
			window_class_name.set_text (project_settings.main_window_class_name)
			window_class_name.generate
			choice_box.extend (window_class_name.widget)
			

			set_updatable_entries(<<>>)
		end

	proceed_with_current_info is
			-- User has clicked next, go to next step.
		local
			application_name_lower, class_name_lower, project_name_lower,
			invalid_text, warning_message: STRING
		do
			Precursor
			validate
			if validate_successful then
				proceed_with_new_state(create {WIZARD_THIRD_STATE}.make(wizard_information))	
			else
				proceed_with_new_state (create {GB_BUILD_CLASS_NAMES_ERROR_STATE}.make (wizard_information))
			end
		end
		
	validate_successful: BOOLEAN
		-- Was the last call to `validate', successful?
		
	validate is
			-- Validate input fields of `Current'.
		local
			application_name_lower, class_name_lower, project_name_lower: STRING
		do
				-- Check for invalid eiffel names as language specification.
			validate_successful := True
			class_name_lower := window_class_name.text.as_lower
			
			
				-- If we are the project wizard, we need to check all three entries,
				-- otherwise, we only validate the class name
			if project_settings.complete_project then
				project_name_lower := project_name.text.as_lower
				application_name_lower := application_class_name.text.as_lower
					-- Check for valid names/and or reserved words used.
				if not valid_class_name (application_name_lower) or
					not valid_class_name (class_name_lower) or
					not valid_class_name (project_name_lower) or
					reserved_words.has (application_name_lower) or
					reserved_words.has (class_name_lower) or
					reserved_words.has (project_name_lower) then
					
					validate_successful := False
				end
	
					-- Check for conflicting names.
				if application_name_lower.is_equal (class_name_lower) or 
					application_name_lower.is_equal (class_name_lower + class_implementation_extension.as_lower) then
					validate_successful := False
				end
			else
				if not valid_class_name (class_name_lower) or reserved_words.has (class_name_lower) then
					validate_successful := False
				end
			end
		end

	update_state_information is
			-- Check User Entries
		do
			--Precursor
			Entries_checked := True
				-- If we are just creating a class, we do not care about these classes.
			if project_settings.complete_project then
				project_settings.set_project_name (project_name.text)
				project_settings.set_application_class_name (application_class_name.text)
			end
			project_settings.set_main_window_class_name (window_class_name.text)
		end

feature {NONE} -- Implementation

	display_state_text is
			-- Set the messages for this state.
		do
			title.set_text ("Add Your Title Here (Step 3).")
			subtitle.set_text ("Add your subtitle here.")
			message.set_text ("Please enter the following system information.")
		end
		
	project_name: WIZARD_SMART_TEXT_FIELD
	
	application_class_name: WIZARD_SMART_TEXT_FIELD
	
	window_class_name: WIZARD_SMART_TEXT_FIELD

	project_settings: GB_PROJECT_SETTINGS is
			--
		do
			Result := system_status.current_project_settings
		end
		
end -- class WIZARD_SECOND_STATE
