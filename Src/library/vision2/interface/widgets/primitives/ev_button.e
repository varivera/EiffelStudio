indexing

	description: 
	"EiffelVision button. Basic GUI push button. This is also a% 
	%base class for other buttons classes"
	status: "See notice at end of class"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class 
	EV_BUTTON

inherit
	EV_PRIMITIVE
		redefine
			make, implementation
		end
		
	EV_BAR_ITEM
	
	EV_TEXT_CONTAINER
		redefine
			implementation
		end

	EV_FONTABLE
		redefine
			implementation
		end

creation
	make, make_with_text

	
feature {NONE} -- Initialization

	make_with_text (par: EV_CONTAINER; txt: STRING) is
			-- Button with 'par' as parent and 'txt' as 
			-- text label
		do
			!EV_BUTTON_IMP!implementation.make_with_text (par, txt)
			widget_make (par)
		end			
	
feature -- Access

--	pixmap: PIXMAP
			-- Pixmap inside button
	
	
feature -- Event - command association
	
	add_click_command ( command: EV_COMMAND; 
			    arguments: EV_ARGUMENTS) is
			-- Add 'command' to the list of commands to be
			-- executed when the button is pressed
		require
			valid_command: command /= Void
		do
			implementation.add_click_command ( command, 
							   arguments )
		end	
	
feature {NONE} -- Implementation

	implementation: EV_BUTTON_I
			-- Implementation of button
	
end -- class EV_BUTTON


--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-1998 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------



