indexing
	description: "[
			interface ICorDebugEval : IUnknown
				CallFunction
				NewObject
				NewObjectNoConstructor
				NewString
				NewArray
				IsActive
				Abort
				GetResult
				GetThread
				CreateValue
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	ICOR_DEBUG_EVAL

inherit
	ICOR_OBJECT

	EIFNET_ICOR_ELEMENT_TYPES
		export
			{NONE} all
			{ANY} cor_element_type_valid
		undefine
			out
		end

create 
	make_by_pointer
	
feature {ICOR_EXPORTER} -- Access

	call_function (a_func: ICOR_DEBUG_FUNCTION; nb_args: INTEGER; a_args: ARRAY [ICOR_DEBUG_VALUE]) is
			 -- CallFunction sets up a function call.  Note that the given function
			 -- is called directly; there is no virtual dispatch.  
			 -- (Use ICorDebugObjectValue::GetVirtualMethod to do virtual dispatch.)
		require
			func_not_void: a_func /= Void
			args_not_void: a_args /= Void
		local
			l_mp_args: MANAGED_POINTER
			l_pointer_size: INTEGER
			i: INTEGER
			l_arg: ICOR_DEBUG_VALUE
			l_arg_pointer: POINTER
		do

			l_pointer_size := (create {PLATFORM}).Pointer_bytes
			create l_mp_args.make (nb_args * l_pointer_size)
			from
				i := a_args.lower
			until
				i > a_args.upper
			loop
				l_arg := a_args.item (i)
				if l_arg = Void then
					l_arg_pointer := Default_pointer
				else
					l_arg_pointer := l_arg.item
				end				
				l_mp_args.put_pointer (l_arg_pointer, (i - a_args.lower) * l_pointer_size)
				i := i + 1
			end

			last_call_success := cpp_call_function (item, a_func.item, nb_args, l_mp_args.item)

--			print ("ICOR_DEBUG_EVAL.call_function : " +a_func.to_string + "%N%T=> return code = " + last_call_success.out + "%N")
--		ensure
--			success: last_call_success = 0
		end

	is_active: BOOLEAN is
			-- IsActive returns whether or not the Eval has an active computation.
		local
			l_result: INTEGER
		do
			last_call_success := cpp_is_active (item, $l_result)
			Result := l_result /= 0 --| TRUE = 1 , FALSE = 0
		ensure
			success: last_call_success = 0
		end

	abort is
			-- Abort aborts the current computation.  Note that in the case of nested
	 		-- Evals, this may fail unless it is the most recent Eval.

		do
			last_call_success := cpp_abort (item)
--		ensure
--			success: last_call_success = 0
		end

	get_result: ICOR_DEBUG_VALUE is
			-- GetResult returns the result of the evaluation.  This is only
			-- valid after the evaluation is completed.
			--                                                                 
			-- If the evaluation completes normally, the result will be the
			-- return value.  If it terminates with an exception, the result
			-- is the exception thrown. If the evaluation was for a new object,
			-- the return value is the reference to the object.
		local
			p: POINTER
		do
			last_call_success := cpp_get_result (item, $p)
			if p /= default_pointer then
				create Result.make_by_pointer (p)
			end
--		ensure
--			success: last_call_success = 0
		end


	create_value (a_cor_element_type: INTEGER; a_class: ICOR_DEBUG_CLASS): ICOR_DEBUG_VALUE is
			-- CreateValue creates an ICorDebugValue of the given type for the
			-- sole purpose of using it in a function evaluation. These can be
			-- use to pass user constants as parameters. The value has a zero
			-- or NULL initial value. Use ICorDebugValue::SetValue to
			-- set the value.
			--
			-- pElementClass is only required for value classes. Pass NULL
			-- otherwise.
			--
			-- If elementType == ELEMENT_TYPE_CLASS, then you get an
			-- ICorDebugReferenceValue representing the NULL object reference.
			-- You can use this to pass NULL to evals that have object reference
			-- parameters. You cannot set the ICorDebugReferenceValue to
			-- anything... it always remains NULL.
		require
			elt_type_valid: cor_element_type_valid (a_cor_element_type)
--			class_not_void: a_class /= Void
		local
			p: POINTER
			l_class_p: POINTER
		do
			if a_class /= Void then
				l_class_p := a_class.item
			end
			last_call_success := cpp_create_value (item, a_cor_element_type, l_class_p , $p)
			if p /= default_pointer then
				create Result.make_by_pointer (p)
			end
--		ensure
--			success: last_call_success = 0
		end


feature {NONE} -- Implementation

	cpp_call_function (obj: POINTER; a_p_function: POINTER; a_nb: INTEGER; a_pp_args: POINTER): INTEGER is
		external
			"[
				C++ ICorDebugEval signature(ICorDebugFunction*, ULONG32, ICorDebugValue**): EIF_INTEGER 
				use "cli_headers.h"
			]"
		alias
			"CallFunction"
		end		

	cpp_is_active (obj: POINTER; a_pb_active: POINTER): INTEGER is
		external
			"[
				C++ ICorDebugEval signature(BOOL*): EIF_INTEGER 
				use "cli_headers.h"
			]"
		alias
			"IsActive"
		end		

	cpp_abort (obj: POINTER): INTEGER is
		external
			"[
				C++ ICorDebugEval signature(): EIF_INTEGER 
				use "cli_headers.h"
			]"
		alias
			"Abort"
		end		

	cpp_get_result (obj: POINTER; a_p: POINTER): INTEGER is
		external
			"[
				C++ ICorDebugEval signature(ICorDebugValue**): EIF_INTEGER 
				use "cli_headers.h"
			]"
		alias
			"GetResult"
		end		
    
	cpp_create_value (obj: POINTER; a_cor_elt_type: INTEGER; a_class_p: POINTER; a_p: POINTER): INTEGER is
		external
			"[
				C++ ICorDebugEval signature(CorElementType, ICorDebugClass*, ICorDebugValue**): EIF_INTEGER 
				use "cli_headers.h"
			]"
		alias
			"CreateValue"
		end		

end -- class ICOR_DEBUG_EVAL

