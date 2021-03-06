﻿note
	description	: "Popup"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	POPUP_NOT_FOUND

inherit
	EV_DIALOG
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- <Precursor>
		do
			create ok_button.make_with_text ("OK")
			ok_button.set_minimum_size (75, 24)
		end

	initialize
			-- Populate the dialog box.
		local
			main_horizontal_box: EV_HORIZONTAL_BOX
			left_vertical_box: EV_VERTICAL_BOX
			right_vertical_box: EV_VERTICAL_BOX
			buttons_box: EV_HORIZONTAL_BOX
			ev_cell: EV_CELL
		do
			Precursor

				--| Add the pixmap to the dialog box.
				--|
				--| We do not use `{EV_STOCK_PIXMAPS}.Information_pixmap'
				--| directly because a given pixmap can only have one
				--| parent. `Information_pixmap' may have alredy been put
				--| into another container.
			create pixmap
			pixmap.copy ((create {EV_STOCK_PIXMAPS}).Information_pixmap)
			pixmap.set_minimum_size (pixmap.width, pixmap.height)

			create message_label
			message_label.align_text_left

			ok_button.select_actions.extend (agent destroy)

			create buttons_box
			buttons_box.extend (create {EV_CELL}) -- Fill in empty space on left
			buttons_box.extend (ok_button)
			buttons_box.disable_item_expand (ok_button)

			create left_vertical_box
			left_vertical_box.set_border_width (7)
			left_vertical_box.extend (pixmap)
			left_vertical_box.disable_item_expand (pixmap)
			left_vertical_box.extend (create {EV_CELL})

			create right_vertical_box
			right_vertical_box.set_padding (7)
			right_vertical_box.extend (message_label)
			right_vertical_box.extend (buttons_box)
			right_vertical_box.disable_item_expand (buttons_box)

			create main_horizontal_box
			main_horizontal_box.set_border_width (7)
			create ev_cell
			ev_cell.set_minimum_width (21)
			main_horizontal_box.extend (ev_cell)
			main_horizontal_box.disable_item_expand (ev_cell)
			main_horizontal_box.extend (left_vertical_box)
			main_horizontal_box.disable_item_expand (left_vertical_box)
			create ev_cell
			ev_cell.set_minimum_width (28)
			main_horizontal_box.extend (ev_cell)
			main_horizontal_box.disable_item_expand (ev_cell)
			main_horizontal_box.extend (right_vertical_box)
			extend (main_horizontal_box)

			set_default_push_button (ok_button)
			set_default_cancel_button (ok_button)

			set_title (Default_title)
			set_message (Default_message)
			set_size (250, 100)
		end

feature -- Access

	message: STRING
			-- Message displayed in the dialog box.
		do
			Result := message_label.text
		end

feature -- Element change

	set_message (a_message: STRING)
		do
			message_label.set_text (a_message)
		end

feature {NONE} -- Implementation

	message_label: EV_LABEL
			-- Label situated on the top of the dialog,
			-- contains the message.

	pixmap: EV_PIXMAP
			-- Pixmap display on the left of the dialog.

	ok_button: EV_BUTTON
			-- "OK" button.

feature {NONE} -- Implementation / Constants

	Default_title: STRING = "Class not found"
			-- Default title for the dialog window.

	Default_message: STRING =
		"Class not found in Eiffel Assembly Cache.";

note
	copyright:	"Copyright (c) 1984-2018, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
