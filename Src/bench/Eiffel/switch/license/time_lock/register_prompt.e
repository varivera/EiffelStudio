indexing 
	description: "REGISTER_PROMPT class created by Resource Bench."

class 
	REGISTER_PROMPT

inherit
	WEL_MODAL_DIALOG
		redefine
			on_ok,
			on_cancel
		end

	APPLICATION_IDS
		export
			{NONE} all
		end

creation
	make

feature {NONE} -- Initialization

	make (a_parent: SHAREWARE_PROMPT; license: LICENSE) is
			-- Create the dialog.
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
		do
			make_by_id (a_parent, Idd_register_constant)
			!! id_ok.make_by_id (Current, Idok)
			!! idc_user.make_by_id (Current, Idc_user_constant)
			!! idc_key.make_by_id (Current, Idc_key_constant)
			!! id_cancel.make_by_id (Current, Idcancel)

			license_info := license
			previous_dialog := a_parent
		end

feature -- Behavior

	on_ok is
		local
			error_box: WEL_MSG_BOX
		do
			license_info.set_username (idc_user.text)
			license_info.set_password (idc_key.text)
			license_info.verify_current_user
			if license_info.licensed then
				previous_dialog.set_registered_user (True)
				destroy
			else
				previous_dialog.set_registered_user (False)
				!! error_box.make
				error_box.error_message_box (Current, "Entered %"username%" and %"key%" are invalids.", "Registration Error")
			end
		end

	on_cancel is
		do
			license_info.set_username (Void)
			license_info.set_password (Void)
			destroy
		end

feature -- Access

	id_ok: WEL_PUSH_BUTTON
	idc_user: WEL_SINGLE_LINE_EDIT
	idc_key: WEL_SINGLE_LINE_EDIT
	id_cancel: WEL_PUSH_BUTTON

	license_info: LICENSE
			-- License information

	previous_dialog: SHAREWARE_PROMPT
			-- Parent of Current.

end -- class REGISTER_PROMPT

--|-------------------------------------------------------------------
--| This class was automatically generated by Resource Bench
--| Copyright (C) 1996-1997, Interactive Software Engineering, Inc.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------
