indexing
	description: "Objects that manipulate objects of type EV_TOOLTIPABLE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GB_EV_TOOLTIPABLE

	-- The following properties from EV_TOOLTIPABLE are manipulated by `Current'.
	-- tooltip - Performed on the real object and the display_object.

inherit
	GB_EV_ANY
		undefine
			attribute_editor
		end
		
	GB_EV_TOOLTIPABLE_EDITOR_CONSTRUCTOR
	
	GB_GENERAL_UTILITIES
		undefine
			default_create
		end
		
	GB_XML_UTILITIES
		undefine
			default_create
		end
		
	CDATA_HANDLER
		undefine
			default_create
		end

feature {GB_XML_STORE} -- Output
	
	generate_xml (element: XML_ELEMENT) is
			-- Generate an XML representation of `Current' in `element'.
		do
			if not objects.first.tooltip.is_empty then
				add_element_containing_string (element, Tooltip_string, enclose_in_cdata (objects.first.tooltip))	
			end
		end
		
	modify_from_xml (element: XML_ELEMENT) is
			-- Update all items in `objects' based on information held in `element'.
		local
			full_information: HASH_TABLE [ELEMENT_INFORMATION, STRING]
			element_info: ELEMENT_INFORMATION
			stripped_text: STRING
		do
			full_information := get_unique_full_info (element)
			element_info := full_information @ (Tooltip_string)
			if element_info /= Void and then element_info.data.count /= 0 then
				stripped_text := strip_cdata (element_info.data)
				for_all_objects (agent {EV_TOOLTIPABLE}.set_tooltip (stripped_text))
			end
		end

feature {GB_CODE_GENERATOR} -- Output

	generate_code (element: XML_ELEMENT; info: GB_GENERATED_INFO): STRING is
			-- `Result' is string representation of
			-- settings held in `Current' which is
			-- in a compilable format.
		local
			full_information: HASH_TABLE [ELEMENT_INFORMATION, STRING]
			element_info: ELEMENT_INFORMATION
			escaped_text: STRING
		do
			Result := ""
			full_information := get_unique_full_info (element)
			element_info := full_information @ (Tooltip_string)
			if element_info /= Void and then element_info.data.count /= 0 then
				escaped_text := escape_special_characters (strip_cdata (element_info.data))
				Result := info.name + ".set_tooltip (%"" + escaped_text + "%")"
			end
			Result := strip_leading_indent (Result)
		end

end -- class GB_EV_TOOLTIPABLE
