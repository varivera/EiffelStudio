indexing 
	description:
		"Facilities for direct drawing on the screen."
	status: "See notice at end of class"
	keywords: "screen, root, window, visual, top"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SCREEN

inherit
	EV_DRAWABLE
		redefine
			implementation,
			create_implementation
		end

create
	default_create

feature -- Status report

	pointer_position: EV_COORDINATES is
			-- Position of the screen pointer.
		do
			Result := implementation.pointer_position
		ensure
			bridge_ok: Result = implementation.pointer_position
		end 

feature -- Basic operation

	set_pointer_position (x, y: INTEGER) is
			-- Set `pointer_position' to (`x',`y`).		
		do
			implementation.set_pointer_position (x, y)
		ensure
			pointer_position_set:
				pointer_position.x = x and pointer_position.y = y
		end

	fake_pointer_button_press (a_button: INTEGER) is
			-- Simulate the user pressing a `a_button' on the pointing device.
		do
			--| FIXME implementation.
			--|	for X do somthing like
			--| XTestFakeButtonEvent (display, a_button, True, 0)
			--| For windows use SendInput
			--| http://msdn.microsoft.com/library/psdk/winui/keybinpt_7id0.htm
		end

	fake_pointer_button_release (a_button: INTEGER) is
			-- Simulate the user releasing a `a_button' on the pointing device.
		do
			--| FIXME implementation.
			--|	for X do somthing like
			--| XTestFakeButtonEvent (display, a_button, False, 0)
			--| For windows use SendInput
			--| http://msdn.microsoft.com/library/psdk/winui/keybinpt_7id0.htm
		end

	fake_key_press (a_key: EV_KEY) is
			-- Simulate the user pressing a `key'.
		do
			--| FIXME implementation.
			--|	for X do somthing like
			--| XTestFakeKeyvent (display, gtk_code (key), True, 0)
			--| For windows use SendInput
			--| http://msdn.microsoft.com/library/psdk/winui/keybinpt_7id0.htm
		end

	fake_key_release (a_key: EV_KEY) is
			-- Simulate the user releasing a `key'.
		do
			--| FIXME implementation.
			--|	for X do somthing like
			--| XTestFakeKeyvent (display, gtk_code (key), False, 0)
			--| For windows use SendInput
			--| http://msdn.microsoft.com/library/psdk/winui/keybinpt_7id0.htm
		end

feature -- Measurement

	width: INTEGER is
			-- Horizontal size in pixels.
		do
			Result := implementation.width
		ensure
			bridge_ok: Result = implementation.width
			positive: Result > 0
		end

	height: INTEGER is
			-- Vertical size in pixels.
		do
			Result := implementation.height
		ensure
			bridge_ok: Result = implementation.height
			positive: Result > 0
		end

feature {NONE} -- Implementation

	create_implementation is
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EV_SCREEN_IMP} implementation.make (Current)
		end

feature {EV_ANY_I} -- Implementation

	implementation: EV_SCREEN_I
			-- Responsible for interaction with the native graphics toolkit.

--| FIXME turn back on when pointer_position is implemented
--| invariant
--|	pointer_position_not_negative:
--|		pointer_position.x >= 0 and pointer_position.y >= 0

end -- class EV_SCREEN

--!-----------------------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-2000 Interactive Software Engineering Inc.
--! All rights reserved. Duplication and distribution prohibited.
--! May be used only with ISE Eiffel, under terms of user license. 
--! Contact ISE for any other use.
--!
--! Interactive Software Engineering Inc.
--! ISE Building, 2nd floor
--! 270 Storke Road, Goleta, CA 93117 USA
--! Telephone 805-685-1006, Fax 805-685-6869
--! Electronic mail <info@eiffel.com>
--! Customer support e-mail <support@eiffel.com>
--! For latest info see award-winning pages: http://www.eiffel.com
--!-----------------------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.10  2000/04/06 23:26:59  oconnor
--| added implementation comments and new fake event features
--|
--| Revision 1.9  2000/04/06 20:12:30  oconnor
--| added pointer position features
--|
--| Revision 1.8  2000/03/17 01:23:34  oconnor
--| formatting and layout
--|
--| Revision 1.7  2000/03/01 20:28:53  king
--| Corrected export clauses for implementation and create_imp/act_seq
--|
--| Revision 1.6  2000/02/22 18:39:52  oconnor
--| updated copyright date and formatting
--|
--| Revision 1.5  2000/02/14 11:40:53  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.4.6.10  2000/01/28 20:00:22  oconnor
--| released
--|
--| Revision 1.4.6.9  2000/01/27 19:30:59  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.4.6.8  1999/12/17 19:21:05  rogers
--| implementation is now exported to EV_ANY_I.
--|
--| Revision 1.4.6.7  1999/12/16 03:47:51  oconnor
--| added width and height, removed expose action, inablicable
--|
--| Revision 1.4.6.6  1999/12/15 19:17:00  king
--| Removed fixme from interface
--|
--| Revision 1.4.6.5  1999/12/13 19:31:14  oconnor
--| kernel/ev_application.e
--|
--| Revision 1.4.6.4  1999/12/09 23:13:26  brendel
--| Corrected export status of implementation.
--|
--| Revision 1.4.6.3  1999/12/09 19:00:56  brendel
--| Improved cosmetics and indexing clauses.
--|
--| Revision 1.4.6.2  1999/12/04 00:40:00  brendel
--| Added expose_actions.
--|
--| Revision 1.4.6.1  1999/11/24 17:30:57  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.4.2.2  1999/11/02 17:20:13  oconnor
--| Added CVS log, redoing creation sequence
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
