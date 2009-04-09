note
	description: "[
		EiffelStudio output routines, used to display various predefined output structures.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_OUTPUT_ROUTINES

inherit
	ES_SHARED_LOCALE_FORMATTER
		export
			{NONE} all
		end

	ES_SHARED_OUTPUTS
		export
			{NONE} all
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

feature -- Output

	append_system_info (a_formatter: TEXT_FORMATTER)
			-- Append to `text' information about `e_system'.
		local
			creation_name: STRING
			root_cluster: CONF_GROUP
			root_class: CLASS_I
			cr_f: E_FEATURE
			l_root: SYSTEM_ROOT
			l_name: STRING_32
			l_target: STRING_32
			l_configuration: STRING_32
			l_location: STRING_32
			l_compilation: STRING_32
			l_multithreaded: STRING_32
			l_count: INTEGER
			l_max_len: INTEGER
		do
			l_name := locale_formatter.translation (lb_name)
			l_target := locale_formatter.translation (lb_target)
			l_configuration := locale_formatter.translation (lb_configuration)
			l_location := locale_formatter.translation (lb_location)
			l_compilation := locale_formatter.translation (lb_compilation)
			l_multithreaded := locale_formatter.translation (lb_multithreaded)
			l_max_len := l_name.count.max (l_target.count).max (l_configuration.count).max (l_location.count).max (
				l_compilation.count).max (l_multithreaded.count) + 1

			a_formatter.process_keyword_text (locale_formatter.translation (lb_system), Void)
			a_formatter.add_new_line
			a_formatter.add_indent
			a_formatter.process_indexing_tag_text (l_name)
			a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
			l_count := l_name.count
			if l_count < l_max_len then
				a_formatter.process_basic_text (create {STRING}.make_filled (' ', l_max_len - l_count))
			end
			a_formatter.process_basic_text (eiffel_system.name)
			a_formatter.add_new_line

			a_formatter.add_indent
			a_formatter.process_indexing_tag_text (l_target)
			a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
			l_count := l_target.count
			if l_count < l_max_len then
				a_formatter.process_basic_text (create {STRING}.make_filled (' ', l_max_len - l_count))
			end
			a_formatter.process_basic_text (eiffel_system.lace.target_name)
			a_formatter.add_new_line

			a_formatter.add_indent
			a_formatter.process_indexing_tag_text (l_configuration)
			a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
			l_count := l_configuration.count
			if l_count < l_max_len then
				a_formatter.process_basic_text (create {STRING}.make_filled (' ', l_max_len - l_count))
			end
			a_formatter.process_basic_text (eiffel_ace.file_name)
			a_formatter.add_new_line

			a_formatter.add_indent
			a_formatter.process_indexing_tag_text (l_location)
			a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
			l_count := l_location.count
			if l_count < l_max_len then
				a_formatter.process_basic_text (create {STRING}.make_filled (' ', l_max_len - l_count))
			end
			a_formatter.process_basic_text (eiffel_project.name)
			a_formatter.add_new_line

			a_formatter.add_indent
			a_formatter.process_indexing_tag_text (l_compilation)
			a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
			l_count := l_compilation.count
			if l_count < l_max_len then
				a_formatter.process_basic_text (create {STRING}.make_filled (' ', l_max_len - l_count))
			end
			a_formatter.process_basic_text (eiffel_ace.system.project_location.target_path)
			a_formatter.add_new_line

			a_formatter.add_indent
			a_formatter.process_indexing_tag_text (l_multithreaded)
			a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
			l_count := l_multithreaded.count
			if l_count < l_max_len then
				a_formatter.process_basic_text (create {STRING}.make_filled (' ', l_max_len - l_count))
			end
			if eiffel_ace.system.has_multithreaded then
				a_formatter.process_basic_text ("enabled")
			else
				a_formatter.process_basic_text ("disabled")
			end
			a_formatter.add_new_line

			a_formatter.add_new_line
			if eiffel_system.workbench.is_already_compiled then
				if not eiffel_system.system.root_creators.is_empty then
					l_root := eiffel_system.system.root_creators.first

					root_class := l_root.root_class
					root_cluster := l_root.cluster
					a_formatter.set_context_group (root_cluster)

					a_formatter.process_keyword_text (locale_formatter.translation (lb_root_class), Void)
					a_formatter.add_new_line
					a_formatter.add_indent
					a_formatter.add_class (root_class)

					if root_cluster /= Void then
						a_formatter.add_space
						a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_l_parenthesis)
						a_formatter.add_group (root_cluster, root_cluster.name)
						a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_r_parenthesis)
					end

					creation_name := l_root.procedure_name
					if root_class.compiled_class /= Void and creation_name /= Void then
						if root_class.compiled_class.has_feature_table then
							cr_f := root_class.compiled_class.feature_with_name (creation_name)
						end
						if cr_f /= Void then
							a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
							a_formatter.add_space
							a_formatter.add_feature (cr_f, creation_name)
						else
							a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
							a_formatter.add_space
							a_formatter.add (creation_name)
						end
					elseif creation_name /= Void then
						a_formatter.process_symbol_text ({SHARED_TEXT_ITEMS}.ti_colon)
						a_formatter.add_space
						a_formatter.add (creation_name)
					end
					a_formatter.add_new_line
				end
			else
				a_formatter.add_comment ("System is not yet compiled.")
				a_formatter.add_new_line
			end
		end

feature {NONE} -- Internationalization

	lb_system: STRING = "System"
	lb_root_class: STRING = "Root Class"
	lb_name: STRING = "name"
	lb_target: STRING = "target"
	lb_configuration: STRING = "configuration"
	lb_location: STRING = "location"
	lb_compilation: STRING = "compilation"
	lb_multithreaded: STRING = "multithreaded"
	lb_enabled: STRING = "enabled"
	lb_disabled: STRING = "disabled"
	lb_system_not_compiled: STRING = "System has not yet compiled."

;note
	copyright:	"Copyright (c) 1984-2009, Eiffel Software"
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
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
