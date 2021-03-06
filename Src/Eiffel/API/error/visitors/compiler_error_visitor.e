﻿note
	description: "Visitor for compiler errors."
	todo: "Add processing for all error types."

deferred class
	COMPILER_ERROR_VISITOR

inherit
	ERROR_VISITOR

feature {COMPILER_ERROR} -- Visitor

	process_missing_local_type (e: MISSING_LOCAL_TYPE_ERROR)
			-- Visit `e`.
		deferred
		end

	process_unused_local (e: UNUSED_LOCAL_WARNING)
			-- Visit `e`.
		deferred
		end

	process_array_explicit_type_required_for_conformance (e: VWMA_EXPLICIT_TYPE_REQUIRED_FOR_CONFORMANCE)
			-- Visit `e`.
		deferred
		end

	process_array_explicit_type_required_for_match (e: VWMA_EXPLICIT_TYPE_REQUIRED_FOR_MATCH)
			-- Visit `e`.
		deferred
		end

note
	date: "$Date$"
	revision: "$Revision$"
	copyright: "Copyright (c) 1984-2018, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
