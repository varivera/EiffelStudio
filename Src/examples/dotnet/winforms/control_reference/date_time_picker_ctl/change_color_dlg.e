note
	description: "Dialog box to change different color of the DATE_TIME_PICKER control."
	legal: "See notice at end of class."
	status: "See notice at end of class."

class
	CHANGE_COLOR_DLG

inherit 
	WINFORMS_FORM
		rename
			make as make_form
		redefine
			dispose_boolean
		end

	ANY

create
	make

feature {NONE} -- Initialization

	make (a_dtp: WINFORMS_DATE_TIME_PICKER)
			-- Call `initialize_components'.
		require
			non_void_a_dtp: a_dtp /= Void
		do
			initialize_components
			dtp := a_dtp
			synchronize_panel_colors
		ensure
			dtp_set: dtp = a_dtp
		end

feature -- Access

	components: SYSTEM_DLL_SYSTEM_CONTAINER	
			-- System.ComponentModel.Container

	dtp: WINFORMS_DATE_TIME_PICKER
			-- DateTimePicker 

	color_dialog: WINFORMS_COLOR_DIALOG
			-- System.Windows.Forms.ColorDialog

	label_1, label_2, label_3, label_4, label_5: WINFORMS_LABEL
			-- System.Windows.Forms.Label 

	btn_OK: WINFORMS_BUTTON
			-- System.Windows.Forms.Button 

	pnl_fore_color , pnl_month_background, pnl_title_back_color, pnl_title_fore_color, pnl_trailing_fore_color: WINFORMS_PANEL
			-- System.Windows.Forms.Panel 

	btn_fore_color, btn_month_background, btn_title_back_color, btn_title_fore_color, btn_trailing_fore_color: WINFORMS_BUTTON			
			-- System.Windows.Forms.Button

feature -- Implementation

	initialize_components
			-- Initialize all window components.
		local
			l_point: DRAWING_POINT
			l_size: DRAWING_SIZE
		do
			create components.make
			create btn_trailing_fore_color.make
			create btn_OK.make
			create pnl_month_background.make
			create btn_title_back_color.make
			create pnl_fore_color.make
			create pnl_title_fore_color.make
			create btn_month_background.make
			create pnl_title_back_color.make
			create btn_title_fore_color.make
			create label_5.make
			create btn_fore_color.make
			create pnl_trailing_fore_color.make
			create label_4.make
			create color_dialog.make
			create label_2.make
			create label_3.make
			create label_1.make

			set_text ("Change Color")
			set_maximize_box (False)
			l_size.make (5, 13)
			set_auto_scale_base_size (l_size)
			set_form_border_style ({WINFORMS_FORM_BORDER_STYLE}.fixed_dialog)
			set_minimize_box (False)
			l_size.make (406, 194)
			set_client_size (l_size)

			l_point.make (232, 112)
			btn_trailing_fore_color.set_location (l_point)
			l_size.make (75, 23)
			btn_trailing_fore_color.set_size (l_size)
			btn_trailing_fore_color.set_tab_index (12)
			btn_trailing_fore_color.set_text ("Change")
			btn_trailing_fore_color.add_click (create {EVENT_HANDLER}.make (Current, $on_btn_trailing_fore_color_click))

			l_point.make (320, 160)
			btn_OK.set_location (l_point)
			btn_OK.set_dialog_result ({WINFORMS_DIALOG_RESULT}.OK)
			l_size.make (75, 23)
			btn_OK.set_size (l_size)
			btn_OK.set_tab_index (9)
			btn_OK.set_text ("&OK")

			pnl_month_background.set_border_style ({WINFORMS_BORDER_STYLE}.fixed_3d)
			l_point.make (160, 43)
			pnl_month_background.set_location (l_point)
			l_size.make (48, 16)
			pnl_month_background.set_size (l_size)
			pnl_month_background.set_tab_index (3)
			pnl_month_background.set_text ("panel1")

			l_point.make (232, 64)
			btn_title_back_color.set_location (l_point)
			l_size.make (75, 23)
			btn_title_back_color.set_size (l_size)
			btn_title_back_color.set_tab_index (14)
			btn_title_back_color.set_text ("Change")
			btn_title_back_color.add_click (create {EVENT_HANDLER}.make (Current, $on_btn_title_back_color_click))

			pnl_fore_color.set_border_style ({WINFORMS_BORDER_STYLE}.fixed_3d)
			l_point.make (160, 19)
			pnl_fore_color.set_location (l_point)
			l_size.make (48, 16)
			pnl_fore_color.set_size (l_size)
			pnl_fore_color.set_tab_index (10)
			pnl_fore_color.set_text ("panel1")

			pnl_title_fore_color.set_border_style ({WINFORMS_BORDER_STYLE}.fixed_3d)
			l_point.make (160, 91)
			pnl_title_fore_color.set_location (l_point)
			l_size.make (48, 16)
			pnl_title_fore_color.set_size (l_size)
			pnl_title_fore_color.set_tab_index (1)
			pnl_title_fore_color.set_text ("panel1")

			l_point.make (232, 40)
			btn_month_background.set_location (l_point)
			l_size.make (75, 23)
			btn_month_background.set_size (l_size)
			btn_month_background.set_tab_index (15)
			btn_month_background.set_text ("Change")
			btn_month_background.add_click (create {EVENT_HANDLER}.make (Current, $on_btn_month_background_click))

			pnl_title_back_color.set_border_style ({WINFORMS_BORDER_STYLE}.fixed_3d)
			l_point.make (160, 67)
			pnl_title_back_color.set_location (l_point)
			l_size.make (48, 16)
			pnl_title_back_color.set_size (l_size)
			pnl_title_back_color.set_tab_index (2)
			pnl_title_back_color.set_text ("panel1")

			l_point.make (232, 88)
			btn_title_fore_color.set_location (l_point)
			l_size.make (75, 23)
			btn_title_fore_color.set_size (l_size)
			btn_title_fore_color.set_tab_index (13)
			btn_title_fore_color.set_text ("Change")
			btn_title_fore_color.add_click (create {EVENT_HANDLER}.make (Current, $on_btn_title_fore_color_click))

			l_point.make (16, 115)
			label_5.set_location (l_point)
			label_5.set_text ("Calendar trailing fore color: ")
			l_size.make (136, 16)
			label_5.set_size (l_size)
			label_5.set_tab_index (4)

			l_point.make (232, 16)
			btn_fore_color.set_location (l_point)
			l_size.make (75, 23)
			btn_fore_color.set_size (l_size)
			btn_fore_color.set_tab_index (11)
			btn_fore_color.set_text ("Change")
			btn_fore_color.add_click (create {EVENT_HANDLER}.make (Current, $on_btn_fore_color_click))

			pnl_trailing_fore_color.set_border_style ({WINFORMS_BORDER_STYLE}.fixed_3d)
			l_point.make (160, 115)
			pnl_trailing_fore_color.set_location (l_point)
			l_size.make (48, 16)
			pnl_trailing_fore_color.set_size (l_size)
			pnl_trailing_fore_color.set_tab_index (0)
			pnl_trailing_fore_color.set_text ("panel1")

			l_point.make (16, 91)
			label_4.set_location (l_point)
			label_4.set_text ("Calendar title fore color: ")
			l_size.make (136, 16)
			label_4.set_size (l_size)
			label_4.set_tab_index (5)

			l_point.make (16, 43)
			label_2.set_location (l_point)
			label_2.set_text ("Calendar month background: ")
			l_size.make (144, 16)
			label_2.set_size (l_size)
			label_2.set_tab_index (7)

			l_point.make (16, 67)
			label_3.set_location (l_point)
			label_3.set_text ("Calendar title back color: ")
			l_size.make (136, 16)
			label_3.set_size (l_size)
			label_3.set_tab_index (6)

			l_point.make (16, 19)
			label_1.set_location (l_point)
			label_1.set_text ("Calendar fore color: ")
			l_size.make (136, 16)
			label_1.set_size (l_size)
			label_1.set_tab_index (8)

			controls.add (btn_trailing_fore_color)
			controls.add (btn_title_fore_color)
			controls.add (btn_title_back_color)
			controls.add (btn_month_background)
			controls.add (btn_fore_color)
			controls.add (pnl_trailing_fore_color)
			controls.add (pnl_title_fore_color)
			controls.add (pnl_title_back_color)
			controls.add (pnl_month_background)
			controls.add (pnl_fore_color)
			controls.add (btn_OK)
			controls.add (label_5)
			controls.add (label_4)
			controls.add (label_3)
			controls.add (label_2)
			controls.add (label_1)
		ensure
			non_void_components: components /= Void
			non_void_color_dialog: color_dialog /= Void
			non_void_pnl_month_background: pnl_month_background /= Void
			non_void_pnl_fore_color: pnl_fore_color /= Void
			non_void_pnl_title_fore_color: pnl_title_fore_color /= Void
			non_void_pnl_trailing_fore_color: pnl_trailing_fore_color /= Void
			non_void_pnl_title_back_color: pnl_title_back_color /= Void
			non_void_btn_OK: btn_OK /= Void
			non_void_btn_month_background: btn_month_background /= Void
			non_void_btn_title_back_color: btn_title_back_color /= Void
			non_void_btn_title_fore_color: btn_title_fore_color /= Void
			non_void_btn_fore_color: btn_fore_color /= Void
			non_void_btn_trailing_fore_color: btn_trailing_fore_color /= Void
			non_void_label_1: label_1 /= Void
			non_void_label_2: label_2 /= Void
			non_void_label_3: label_3 /= Void
			non_void_label_4: label_4 /= Void
			non_void_label_5: label_5 /= Void
		end


feature {NONE} -- Implementation

	dispose_boolean (a_disposing: BOOLEAN)
			-- method called when form is disposed.
		local
			retried: BOOLEAN
		do
			if not retried then
				if components /= Void then
					components.dispose	
				end
			end
			Precursor {WINFORMS_FORM}(a_disposing)
		rescue
			retried := true
			retry
		end

	synchronize_panel_colors
			-- Synchronize panel control.
        do
			pnl_fore_color.set_back_color (dtp.calendar_fore_color)
			pnl_month_background.set_back_color (dtp.calendar_month_background)
			pnl_title_back_color.set_back_color (dtp.calendar_title_back_color)
			pnl_title_fore_color.set_back_color (dtp.calendar_title_fore_color)
			pnl_trailing_fore_color.set_back_color (dtp.calendar_trailing_fore_color)
		end

	on_btn_fore_color_click (sender: SYSTEM_OBJECT; args: EVENT_ARGS)
			-- feature performed whent `btn_fore_color' is clicked.
		require
			non_void_sender: sender /= Void
			non_void_args: args /= Void
		local
			res: WINFORMS_DIALOG_RESULT
		do
			color_dialog.set_color (dtp.calendar_fore_color)
			res := color_dialog.show_dialog
			if res = {WINFORMS_DIALOG_RESULT}.OK then
				dtp.set_calendar_fore_color (color_dialog.color)
				synchronize_panel_colors
			end
		end

	on_btn_month_background_click (sender: SYSTEM_OBJECT; args: EVENT_ARGS)
			-- feature performed whent `btn_month_background' is clicked.
		require
			non_void_sender: sender /= Void
			non_void_args: args /= Void
		local
			res: WINFORMS_DIALOG_RESULT
		do
			color_dialog.set_color (dtp.calendar_month_background)
			res := color_dialog.show_dialog
			if res = {WINFORMS_DIALOG_RESULT}.OK then
				dtp.set_calendar_month_background (color_dialog.color)
				synchronize_panel_colors
			end
		end

	on_btn_title_back_color_click (sender: SYSTEM_OBJECT; args: EVENT_ARGS)
			-- feature performed whent `btn_title_back_color' is clicked.
		require
			non_void_sender: sender /= Void
			non_void_args: args /= Void
		local
			res: WINFORMS_DIALOG_RESULT
		do
			color_dialog.set_color (dtp.calendar_title_back_color)
			res := color_dialog.show_dialog
			if res = {WINFORMS_DIALOG_RESULT}.OK then 
				dtp.set_calendar_title_back_color (color_dialog.color)
				synchronize_panel_colors
			end
		end

	on_btn_title_fore_color_click (sender: SYSTEM_OBJECT; args: EVENT_ARGS)
			-- feature performed whent `btn_title_fore_color' is clicked.
		require
			non_void_sender: sender /= Void
			non_void_args: args /= Void
		local
			res: WINFORMS_DIALOG_RESULT
		do
			color_dialog.set_color (dtp.calendar_title_fore_color)
			res := color_dialog.show_dialog
			if res = {WINFORMS_DIALOG_RESULT}.OK then
				dtp.set_calendar_title_fore_color (color_dialog.color)
				synchronize_panel_colors
			end
		end

	on_btn_trailing_fore_color_click (sender: SYSTEM_OBJECT; args: EVENT_ARGS)
			-- feature performed whent `btn_trailing_fore_color' is clicked.
		require
			non_void_sender: sender /= Void
			non_void_args: args /= Void
		local
			res: WINFORMS_DIALOG_RESULT
		do
			color_dialog.set_color (dtp.calendar_trailing_fore_color)
			res := color_dialog.show_dialog
			if res = {WINFORMS_DIALOG_RESULT}.OK then
				dtp.set_calendar_trailing_fore_color (color_dialog.color)
				synchronize_panel_colors
			end
		end

invariant
	non_void_dtp: dtp /= Void
	non_void_components: components /= Void
	non_void_color_dialog: color_dialog /= Void
	non_void_pnl_month_background: pnl_month_background /= Void
	non_void_pnl_fore_color: pnl_fore_color /= Void
	non_void_pnl_title_fore_color: pnl_title_fore_color /= Void
	non_void_pnl_trailing_fore_color: pnl_trailing_fore_color /= Void
	non_void_pnl_title_back_color: pnl_title_back_color /= Void
	non_void_btn_OK: btn_OK /= Void
	non_void_btn_month_background: btn_month_background /= Void
	non_void_btn_title_back_color: btn_title_back_color /= Void
	non_void_btn_title_fore_color: btn_title_fore_color /= Void
	non_void_btn_fore_color: btn_fore_color /= Void
	non_void_btn_trailing_fore_color: btn_trailing_fore_color /= Void
	non_void_label_1: label_1 /= Void
	non_void_label_2: label_2 /= Void
	non_void_label_3: label_3 /= Void
	non_void_label_4: label_4 /= Void
	non_void_label_5: label_5 /= Void

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- Class CHANGE_COLOR_DLG

