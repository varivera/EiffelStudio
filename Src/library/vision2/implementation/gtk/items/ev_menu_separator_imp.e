indexing
	description: "Eiffel Vision menu separator. GTK+ implementation."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MENU_SEPARATOR_IMP

inherit
	EV_MENU_SEPARATOR_I
		redefine
			interface
		end

	EV_MENU_ITEM_IMP
		redefine
			make,
			interface,
			initialize
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a menu.
		do
			base_make (an_interface)
			set_c_object (C.gtk_menu_item_new)
			C.gtk_widget_show (c_object)
		end
	
	initialize is
			-- Do nothing because an empty GtkMenuItem is a separator.
		do
			textable_imp_initialize
			pixmapable_imp_initialize
			initialize_menu_sep_box
			create radio_group_ref
			is_initialized := True
		end

	initialize_menu_sep_box is
			-- Create and initialize menu item box.
			--| This is just to satisfy pixmapable and textable contracts.
		local
			box: POINTER
		do
			box := C.gtk_hbox_new (False, 0)
			C.gtk_widget_hide (box)
			C.gtk_box_pack_start (box, text_label, True, True, 0)
			C.gtk_box_pack_start (box, pixmap_box, True, True, 0)
		end

feature {EV_MENU_ITEM_LIST_IMP} -- Implementation

	radio_group_ref: POINTER_REF

	set_radio_group (p: POINTER) is
			-- Assign `p' to `radio_group'.
		do
			radio_group_ref.set_item (p)
		end

	radio_group: POINTER is
			-- GSList with all radio items of this container.
		do
			Result := radio_group_ref.item
		end

feature {NONE} -- Implementation

	interface: EV_MENU_SEPARATOR

end -- class EV_MENU_SEPARATOR_IMP

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

