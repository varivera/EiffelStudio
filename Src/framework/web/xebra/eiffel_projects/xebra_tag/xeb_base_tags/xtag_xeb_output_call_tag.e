note
	description: "Summary description for {XTAG_XEB_OUTPUT_CALL_TAG}."
	date: "$Date$"
	revision: "$Revision$"

class
	XTAG_XEB_OUTPUT_CALL_TAG

inherit
	XTAG_TAG_SERIALIZER

create
	make

feature -- Initialization

	make
		do
			make_base
			text := ""
		end

feature -- Access

	text: STRING
			-- The name of the feature to call

feature -- Implementation

	internal_generate (a_render_feature, a_prerender_post_feature, a_prerender_get_feature, a_afterrender_feature: XEL_FEATURE_ELEMENT; variable_table: TABLE [STRING, STRING])
			-- <Precursor>
		do
			a_render_feature.append_expression (Response_variable_append + "(" + Controller_variable + "." + text + ".out)")
		end

	internal_put_attribute (id: STRING; a_attribute: STRING)
			-- <Precursor>
		do
			if id.is_equal ("value") then
				text := a_attribute
			end
		end

end
