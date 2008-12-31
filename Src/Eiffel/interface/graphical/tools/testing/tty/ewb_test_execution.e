note
	description: "Summary description for {EWB_TEST_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_TEST_EXECUTION

inherit
	EWB_TEST_CMD
		redefine
			on_processor_launch_error
		end

	TEST_SUITE_OBSERVER
		redefine
			on_test_changed,
			on_processor_error
		end

	EXCEPTION_CODE_MEANING
		export
			{NONE} all
		end

feature -- Access

	name: STRING
		do
			Result := "Execute"
		end

	help_message: STRING_GENERAL
		do
			Result := locale.translation ("run tests")
		end

	abbreviation: CHARACTER
		do
			Result := 'e'
		end

feature {NONE} -- Basic operations

	execute_with_test_suite
			-- <Precursor>
		local
			l_service: TEST_SUITE_S
			l_conf: TEST_EXECUTOR_CONF
		do
			create l_conf.make
			if test_suite.is_service_available then
				l_service := test_suite.service
				l_service.test_suite_connection.connect_events (Current)
				launch_processor (background_executor_type, l_conf, True)
				l_service.test_suite_connection.disconnect_events (Current)
			end
			print_statistics
		end

feature -- Events

	on_processor_launch_error (a_error: like error_message; a_type: !TYPE [TEST_PROCESSOR_I]; a_code: NATURAL_32)
			-- <Precursor>
		do
			print_string (a_error)
			print_string ("%N%N")
		end

	on_test_changed (a_collection: !ACTIVE_COLLECTION_I [!TEST_I]; a_test: !TEST_I)
			-- <Precursor>
		local
			l_outcome_text: like outcome
		do
			if a_test.memento.is_outcome_added then
				print_string (create_identifier (a_test))
				print_string (": ")
				l_outcome_text := outcome (a_test)
				print_string (l_outcome_text)
				print_string ("%N")
				if not a_test.passed then
					print_outcome (a_test.last_outcome)
					print_string ("%N")
				end
			end
		end

	on_processor_error (a_test_suite: !TEST_SUITE_S; a_processor: !TEST_PROCESSOR_I; a_error: !STRING_8; a_token_values: TUPLE)
			-- <Precursor>
		do
			print_string (locale.formatted_string (a_error, a_token_values))
			print_string ("%N")
		end

feature {NONE} -- Implementation

	print_outcome (a_outcome: !EQA_TEST_OUTCOME)
			-- Print outcome information
			--
			-- `a_outcome': Outcome for which information shall be printed.
		local
			l_invocation: ?EQA_TEST_INVOCATION_RESPONSE
		do
			if a_outcome.has_response then
				l_invocation := a_outcome.setup_response
				check l_invocation /= Void end
				print_invocation (l_invocation, "prepare")
				if a_outcome.is_setup_clean then
					l_invocation := a_outcome.test_response
					check l_invocation /= Void end
					print_invocation (l_invocation, "test")
					l_invocation := a_outcome.teardown_response
					check l_invocation /= Void end
					print_invocation (l_invocation, "clean")
				end
			else
				print_string ("%T")
				if a_outcome.is_user_abort then
					print_string (t_user_aborted)
				else
					print_string (t_aborted)
				end
			end
		end

	print_invocation (a_invocation: !EQA_TEST_INVOCATION_RESPONSE; a_name: !STRING)
			-- Print information about a given test invocation
		local
			l_exception: EQA_TEST_INVOCATION_EXCEPTION
		do
			print_string ("     ")
			print_string (a_name)
			if a_invocation.is_exceptional then
				l_exception := a_invocation.exception
				print_string (": exceptional%N")
				print_string ("          code:      ")
				print_string (description_from_code (l_exception.code))
				print_string ("%N          recipient: {")
				print_string (l_exception.class_name)
				print_string ("}.")
				print_string (l_exception.recipient_name)
				print_string ("%N          tag:       ")
				print_multiline_text (l_exception.tag_name, "               ")
				print_string ("          trace:     ")
				print_multiline_text (l_exception.trace, "               ")
			else
				print_string (": normal%N")
			end
			if not a_invocation.output.is_empty then
				print_string ("          output:    ")
				print_multiline_text (a_invocation.output, "               ")
			end
		end

	print_multiline_text (a_text, a_indentation: !STRING)
			-- Print string cotaining new line characters in a human readable format.
			--
			-- If text has not new line characters or only at very beginning and end, the actual content
			-- will be printed on a single line. Otherwise new line will be printed prefixed with a given
			-- indentation. In all cases a new line character will be printed at the end.
			--
			-- `a_text': Text to be printed
			-- `a_indenation': Indentation used before printing text after printing a new line character.
		local
			l_buffer: STRING
			i: INTEGER
			c: CHARACTER
			l_multiline: BOOLEAN
		do
			create l_buffer.make (200)
			from
				i := 1
			until
				i > a_text.count
			loop
				c := a_text.item (i)
				if c /= '%R' then
					if c /= '%N' and not l_buffer.is_empty and then l_buffer.item (l_buffer.count) = '%N' then
						if not l_multiline then
							print ("%N")
						end
						print_string (a_indentation)
						print_string (l_buffer)
						l_buffer.wipe_out
						l_multiline := True
					end
					if c /= '%N' or (l_multiline or not l_buffer.is_empty) then
						l_buffer.append_character (c)
					end
				end
				i := i + 1
			end
			if not l_buffer.is_empty then
				if l_multiline then
					print_string (a_indentation)
				end
				l_buffer.right_adjust
				print_string (l_buffer)
				if l_multiline then
					print_string ("%N")
				end
			end
			print_string ("%N")
		end

feature {NONE} -- Internationalization

	t_aborted: STRING = "no response"
	t_user_aborted: STRING = "user abort"

note
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
