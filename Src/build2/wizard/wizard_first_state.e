indexing
	description	: "Wizard Step."
	author		: "Generated by the Wizard wizard"
	revision	: "1.0.0"

class
	wizard_first_state

inherit
	WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
			build
		end

create
	make

feature -- Basic Operation

	build is 
			-- Build entries.
		local
			vertical_box: EV_VERTICAL_BOX
			horizontal_box: EV_HORIZONTAL_BOX
		do
			create project_directory_field
			create browse_button.make_with_text ("Browse...")
			create horizontal_box
			horizontal_box.set_padding_width (10)
			horizontal_box.extend (project_directory_field)
			horizontal_box.extend (browse_button)
			horizontal_box.disable_item_expand (browse_button)
			
			choice_box.extend (horizontal_box)
			
			--set_updatable_entries(<<>>)
		end

	proceed_with_current_info is
			-- User has clicked next, go to next step.
		do
			Precursor
			proceed_with_new_state(create {WIZARD_SECOND_STATE}.make(wizard_information))
		end

	update_state_information is
			-- Check User Entries
		do
			Precursor
		end

feature {NONE} -- Implementation

	display_state_text is
			-- Set the messages for this state.
		do
			title.set_text ("Add Your Title Here (Step 1).")
			subtitle.set_text ("Add your subtitle here.")
			message.set_text ("Please enter a directory for your project.")
		end
		
	project_directory_field: EV_TEXT_FIELD
	
	project_directory_label: EV_LABEL
		-- Label prompting for directory input.
		
	browse_button: EV_BUTTON
		-- Button which pops up a directory
		-- selection dialog.

end -- class wizard_first_state
