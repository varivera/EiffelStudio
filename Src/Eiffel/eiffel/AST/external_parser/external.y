%{
note
	description: "External parsers"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class EXTERNAL_PARSER

inherit

	EXTERNAL_PARSER_SKELETON

	EXTERNAL_FACTORY
		export
			{NONE} all
		end

create
	make

%}

%start		External_declaration

%token	TE_COLON, TE_LPARAN, TE_RPARAN, TE_COMMA, TE_BUILT_IN
%token	TE_ADDRESS, TE_BLOCKING, TE_STAR, TE_LT, TE_GT, TE_DQUOTE
%token	TE_ACCESS, TE_C_LANGUAGE, TE_CPP_LANGUAGE, TE_INLINE
%token	TE_DELETE, TE_DLL_LANGUAGE, TE_DLLWIN_LANGUAGE, TE_ENUM
%token	TE_GET_PROPERTY, TE_IL_LANGUAGE, TE_MACRO, TE_FIELD
%token	TE_JAVA_LANGUAGE, TE_DEFERRED, TE_OPERATOR, TE_INTEGER
%token	TE_SET_FIELD, TE_SET_PROPERTY, TE_SIGNATURE, TE_STATIC, TE_CREATOR
%token	TE_STATIC_FIELD, TE_SET_STATIC_FIELD, TE_STRUCT, TE_TYPE
%token	TE_CONST, TE_SIGNED, TE_UNSIGNED, TE_USE, TE_ID, TE_FILE_ID

%type <EXTERNAL_EXTENSION_AS>	External_declaration C_specification CPP_specification
								DLL_specification DLLwin_specification IL_specification
								CPP_specific
%type <SIGNATURE_AS>			Signature_opt Signature
%type <EXTERNAL_TYPE_AS>		Return_opt Type_identifier Type_access_opt
%type <ID_AS>					Identifier File_identifier Dll_identifier
%type <BOOLEAN>					Address_opt
%type <INTEGER>					Pointer_opt	DLL_index
%type <USE_LIST_AS>				Use_opt, Use, Use_list
%type <INTEGER>					Il_language
%type <BOOLEAN>					Blocking_opt

%type <ARRAYED_LIST [EXTERNAL_TYPE_AS]>		Arguments_opt Arguments Arguments_list_opt Arguments_list

%%


-- Root rule


External_declaration:
		TE_C_LANGUAGE Blocking_opt C_specification
			{
				root_node := $3
				root_node.set_is_blocking_call ($2)
			}
	|	TE_CPP_LANGUAGE Blocking_opt CPP_specification
			{
				root_node := $3
				root_node.set_is_blocking_call ($2)
			}
	|	Blocking_opt DLL_specification
			{
				root_node := $2
				root_node.set_is_blocking_call ($1)
			}
	|	Blocking_opt DLLwin_specification
			{
				root_node := $2
				root_node.set_is_blocking_call ($1)
			}
	|	TE_BUILT_IN TE_STATIC
			{
				create {BUILT_IN_EXTENSION_AS} root_node.initialize (True)
			}

	|	TE_STATIC TE_BUILT_IN
			{
				create {BUILT_IN_EXTENSION_AS} root_node.initialize (True)
			}

	|	TE_BUILT_IN
			{
				create {BUILT_IN_EXTENSION_AS} root_node.initialize (False)
			}
	|	IL_specification
			{
				root_node := $1
			}
	;

Blocking_opt: -- Empty
			{
				$$ := False
			}
	|	TE_BLOCKING
			{
				$$ := True
			}
	;

C_specification:
		Signature_opt Use_opt
			{
				create {C_EXTENSION_AS} $$.initialize ($1, $2)
			}
	|	TE_STRUCT Type_identifier TE_ACCESS Identifier Type_access_opt Use
			{
					-- False because this is a C construct
				create {STRUCT_EXTENSION_AS} $$.initialize (False, $2, $4, $5, $6)
			}
	|	TE_MACRO Signature_opt Use
			{
					-- False because this is a C construct
				create {MACRO_EXTENSION_AS} $$.initialize (False, $2, $3)
			}
	|	TE_INLINE Use_opt
			{
				create {INLINE_EXTENSION_AS} $$.initialize (False, $2)
			}
	;

CPP_specification:
		CPP_specific
			{
				$$ := $1
			}
	|	TE_STRUCT Type_identifier TE_ACCESS Identifier Type_access_opt Use
			{
					-- True because this is a C++ construct
				create {STRUCT_EXTENSION_AS} $$.initialize (True, $2, $4, $5, $6)
			}
	|	TE_MACRO Signature_opt Use
			{
					-- True because this is a C++ construct
				create {MACRO_EXTENSION_AS} $$.initialize (True, $2, $3)
			}
	|	TE_INLINE Use_opt
			{
				create {INLINE_EXTENSION_AS} $$.initialize (True, $2)
			}
	;

CPP_specific:
		Identifier Signature_opt Use
			{
				create {CPP_EXTENSION_AS} $$.initialize (standard, $1, $2, $3)
			}
	|	TE_CREATOR Identifier Signature_opt Use
			{
				create {CPP_EXTENSION_AS} $$.initialize (creator, $2, $3, $4)
			}
	|	TE_DELETE Identifier Signature_opt Use
			{
				create {CPP_EXTENSION_AS} $$.initialize (delete, $2, $3, $4)
			}
	|	TE_STATIC Identifier Signature_opt Use
			{
				create {CPP_EXTENSION_AS} $$.initialize (static, $2, $3, $4)
			}
	;

DLL_specification:	TE_DLL_LANGUAGE Dll_identifier DLL_index Signature_opt Use_opt
			{
				create {DLL_EXTENSION_AS} $$.initialize ({EXTERNAL_CONSTANTS}.dll32_type,
					$2, $3, $4, $5)
			}
	;

DLLwin_specification: TE_DLLWIN_LANGUAGE Dll_identifier DLL_index Signature_opt Use_opt
			{
				create {DLL_EXTENSION_AS} $$.initialize ({EXTERNAL_CONSTANTS}.dllwin32_type,
					$2, $3, $4, $5)
			}
	;

DLL_index:	-- Empty
		  {$$ := -1}
	|	TE_INTEGER
		{ $$ := token_buffer.to_integer}
	;

IL_specification:
		Il_language Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, normal_type, $2, $4)
			}
	|	Il_language TE_DEFERRED Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, deferred_type, $3, $5)
			}
	|	Il_language TE_CREATOR Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, creator_type, $3, $5)
			}
	|	Il_language TE_FIELD Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, field_type, $3, $5)
			}
	|	Il_language TE_STATIC_FIELD Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, static_field_type, $3, $5)
			}
	|	Il_language TE_ENUM Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, enum_field_type, $3, $5)
			}
	|	Il_language TE_SET_STATIC_FIELD Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, set_static_field_type, $3, $5)
			}
	|	Il_language TE_SET_FIELD Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, set_field_type, $3, $5)
			}
	|	Il_language TE_STATIC Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, static_type, $3, $5)
			}
	|	Il_language TE_GET_PROPERTY Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, get_property_type, $3, $5)
			}
	|	Il_language TE_SET_PROPERTY Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, set_property_type, $3, $5)
			}
	|	Il_language TE_OPERATOR Signature_opt TE_USE Identifier
			{
				create {IL_EXTENSION_AS} $$.initialize ($1, operator_type, $3, $5)
			}
	;

Il_language:
		TE_IL_LANGUAGE
			{
				$$ := msil_language
			}
	|	TE_JAVA_LANGUAGE
			{
				$$ := java_language
			}
	;

Signature_opt: -- Empty
	|	Signature
		{$$ := $1}
	;

Signature:
		TE_SIGNATURE Arguments_opt Return_opt
			{
				create $$.initialize ($2, $3)
			}
	;

Arguments_opt:	-- Empty
			-- {$$ := Void}
	|	Arguments
			{$$ := $1}
	;

Arguments:
		TE_LPARAN Arguments_list_opt TE_RPARAN
			{$$ := $2}
	;

Arguments_list_opt:	-- Empty
			-- {$$ := Void}
	|	Arguments_list
			{$$ := $1}
	;

Arguments_list:	Type_identifier
		{
			create {ARRAYED_LIST [EXTERNAL_TYPE_AS]} $$.make (Argument_list_initial_size)
			$$.extend ($1)
		} 
	|	Arguments_list TE_COMMA Type_identifier
		{
			$$ := $1
			$$.extend ($3)
		}
	;

Return_opt:	-- Empty
			-- {$$ := Void}
	|	TE_COLON Type_identifier
			{$$ := $2}
	;

Type_identifier:
		Identifier Pointer_opt Address_opt
			{
					-- False because no `struct' keyword.
					-- Void because no `const', `signed', `unsigned' keyword.
				$$ := new_external_type_as ($1, Void, False, $2, $3)
			}
	|	TE_STRUCT Identifier Pointer_opt Address_opt
			{
					-- True because `struct' keyword.
					-- Void because no `const', `signed', `unsigned' keyword.
				$$ := new_external_type_as ($2, Void, True, $3, $4)
			}
	|	TE_SIGNED Identifier Pointer_opt Address_opt
			{
					-- False because no `struct' keyword.
				$$ := new_external_type_as ($2, signed_prefix, False, $3, $4)
			}
	|	TE_UNSIGNED Identifier Pointer_opt Address_opt
			{
					-- False because no `struct' keyword.
				$$ := new_external_type_as ($2, unsigned_prefix, False, $3, $4)
			}
	|	TE_CONST Identifier Pointer_opt Address_opt
			{
					-- False because no `struct' keyword.
				$$ := new_external_type_as ($2, const_prefix, False, $3, $4)
			}
	|	TE_CONST TE_STRUCT Identifier Pointer_opt Address_opt
			{
					-- True because `struct' keyword.
				$$ := new_external_type_as ($3, const_prefix, True, $4, $5)
			}
	|	TE_CONST TE_SIGNED Identifier Pointer_opt Address_opt
			{
					-- False because no `struct' keyword.
				$$ := new_external_type_as ($3, const_signed_prefix, False, $4, $5)
			}
	|	TE_CONST TE_UNSIGNED Identifier Pointer_opt Address_opt
			{
					-- False because no `struct' keyword.
				$$ := new_external_type_as ($3, const_unsigned_prefix, False, $4, $5)
			}
	;

Type_access_opt:	-- Empty
	|	TE_TYPE Type_identifier 
		{
			$$ := $2
		}
	;

Pointer_opt:	-- Empty
		{$$ := 0}
	|	Pointer_opt TE_STAR
		{$$ := $1 + 1}
	;

Address_opt:	-- Empty
		{$$ := False}
	|	TE_ADDRESS
		{$$ := True}
	;

Use_opt:	-- Empty
			-- {$$ := Void}
	|	Use
			{$$ := $1}
	;

Use:
		TE_USE Use_list
			{$$ := $2}
	;

Use_list: File_Identifier
		{
			create {USE_LIST_AS} $$.make (Argument_list_initial_size)
			$$.extend ($1)
		} 
	|	Use_list TE_COMMA File_identifier
		{
			$$ := $1
			$$.extend ($3)
		}
	;

File_identifier:
		TE_DQUOTE TE_ID TE_DQUOTE
		{
			$$ := new_double_quote_id_as (token_buffer)
		}
	|	TE_DQUOTE TE_FILE_ID TE_DQUOTE
		{
			$$ := new_double_quote_id_as (token_buffer)
		}

	|	TE_LT TE_ID TE_GT
		{
			$$ := new_system_id_as (token_buffer)
		}
	|	TE_LT TE_FILE_ID TE_GT
		{
			$$ := new_system_id_as (token_buffer)
		}
	|	TE_ID
		{
			$$ := new_double_quote_id_as (token_buffer)
		}
	;

Dll_identifier: 
		TE_DQUOTE TE_ID TE_DQUOTE
		{
			$$ := new_double_quote_id_as (token_buffer)
		}
	|	TE_DQUOTE TE_FILE_ID TE_DQUOTE
		{
			$$ := new_double_quote_id_as (token_buffer)
		}
	|	TE_FILE_ID
		{
			$$ := new_double_quote_id_as (token_buffer)
		}
	|	TE_ID
		{
			$$ := new_double_quote_id_as (token_buffer)
		}
	;

Identifier:	TE_ID
		{ create $$.initialize (token_buffer) }
	;

%%

feature {NONE} -- Constants

	const_prefix: STRING is "const "
	const_signed_prefix: STRING is "const signed "
	const_unsigned_prefix: STRING is "const unsigned "
	signed_prefix: STRING is "signed "
	unsigned_prefix: STRING is "unsigned ";
			-- Available prefix to C/C++ basic types.

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EIFFEL_PARSER
