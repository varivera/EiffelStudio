-- Error when argument name is also a feature name

class VRFA 

inherit

	EIFFEL_ERROR
		redefine
			build_explain
		end;
	
feature 

	feature_i: FEATURE_I;
			-- Involved feature

	argument_name: ID_AS;
			-- Argument name violating the VRFA rule

	code: STRING is "VRFA";
			-- Error code

	set_feature_i (f: FEATURE_I) is
		do
			feature_i := f;
		end;

	set_argument_name (s: ID_AS) is
			-- Assign `s' to `argument_name'.
		do
			argument_name := s;
		end;

	build_explain (a_clickable: CLICK_WINDOW) is
		do
			a_clickable.put_string ("%T%Tin feature `");
			feature_i.append_clickable_name (a_clickable);
			a_clickable.put_string ("':%N%T%T");
			a_clickable.put_string (argument_name);
			a_clickable.put_string (" is a feature name and cannot%N%
								%%T%Tbe used as an argument name%N");
		end;

end
