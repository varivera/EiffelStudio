indexing
	description: "Dotnet debug value associated with NativeArray value"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EIFNET_DEBUG_NATIVE_ARRAY_VALUE

inherit

	ABSTRACT_SPECIAL_VALUE

	COMPILER_EXPORTER
		undefine
			is_equal
		end

	ICOR_EXPORTER
		export
			{NONE} all
		undefine
			is_equal
		end		

	DEBUG_VALUE_EXPORTER
		export
			{NONE} all
		undefine
			is_equal
		end				

	SHARED_EIFNET_DEBUG_VALUE_FACTORY
		export
			{NONE} all
		undefine
			is_equal
		end		

create {CALL_STACK_ELEMENT, DEBUG_VALUE_EXPORTER}
	make --, make_attribute
	
feature {NONE} -- Initialization

	make (v: like value; f: like icd_frame) is
			-- 	Set `value' to `v'.
		require
			v_not_void: v /= Void
		do
			set_default_name
			value := v
			icd_frame := f

			create value_info.make (value)

			is_null := value_info.is_null
			if not is_null then
				address := value_info.address_as_hex_string
			end

			array_value := value_info.interface_debug_array_value
			if array_value /= Void then
				capacity := array_value.get_count
			end
--			create items.make
		ensure
			value_set: value = v
		end

--	make_attribute (attr_name: like name; a_class: like e_class; v: like value) is
--			-- Set `attr_name' to `name' and `value' to `v'.
--		require
--			not_attr_name_void: attr_name /= Void
--			v_not_void: v /= Void
--		do
--			name := attr_name
--			if a_class /= Void then
--				e_class := a_class
--				is_attribute := True
--			end
--			value := v
--		ensure
--			value_set: value = v
--		end

feature -- Access

	icd_frame: ICOR_DEBUG_FRAME

	value: ICOR_DEBUG_VALUE
			-- Value of object.

	array_value: ICOR_DEBUG_ARRAY_VALUE

	value_info: EIFNET_DEBUG_VALUE_INFO
			-- Value info of object.

	dynamic_class: CLASS_C is
			-- Find corresponding CLASS_C to type represented by `value'.
		once
			Result := Eiffel_system.system.native_array_class.compiled_class
		ensure then
			non_void_result: Result /= Void
		end

	string_value: STRING is
			-- If `Current' represents a string then return its value.
			-- Else return Void.
			-- but in dotnet, STRING are not represented as SPECIAL[CHARACTER]
		do
		end

	dump_value: DUMP_VALUE is
			-- Dump_value corresponding to `Current'.
		local
			l_str: STRING
		do
			create l_str.make (40)
			if address /= Void then
				l_str.append (dynamic_class.name_in_upper)
				l_str.append (Left_square_bracket)
				l_str.append (address)
				l_str.append (Right_square_bracket)
			else
				l_str.append (NONE_representation)
			end

			create Result.make_object (address, dynamic_class)
		end

feature -- Output

	append_type_and_value (st: STRUCTURED_TEXT) is 
		do 
			st.add_string (type_and_value)
		end;

feature {ABSTRACT_DEBUG_VALUE} -- Output
		
	append_value (st: STRUCTURED_TEXT) is 
			-- Append only the value of Current to `st'.
		do 
			st.add_string (output_value)
		end;
		
feature -- Output	

	children: LIST [ABSTRACT_DEBUG_VALUE] is
			-- List of all sub-items of `Current'. May be void if there are no children.
			-- Generated on demand.
		do
			Result := items
			if Result = Void then
				create items.make
				fill_items (Min_slice_ref.item, (capacity - 1).min (Max_slice_ref.item))
				Result := items
			end
		end

	fill_items (a_slice_min, a_slice_max: INTEGER) is
			-- Get Items for attributes
		require
			items_not_void: items /= Void
			a_slice_min <= a_slice_max
		local
			l_elt: ICOR_DEBUG_VALUE
			l_att_debug_value: ABSTRACT_DEBUG_VALUE
			i: INTEGER
		do			
			set_sp_bounds (a_slice_min, (capacity - 1).min (a_slice_max))
			from
				i := sp_lower
			until
				i > sp_upper
			loop
				l_elt := array_value.get_element_at_position (i)
				if l_elt /= Void then
					l_att_debug_value := Eifnet_debug_value_factory.debug_value_from (l_elt, icd_frame)
					l_att_debug_value.set_name (i.out)
					items.extend (l_att_debug_value)
				end
				i := i + 1
			end
		end

end -- class EIFNET_DEBUG_NATIVE_ARRAY_VALUE

