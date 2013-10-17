note
	description: "Extends the object-relational mapping layer with collection support."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_HANDLER [COLLECTION_TYPE ]--> ITERABLE [detachable ANY]]

inherit

	PS_EIFFELSTORE_EXPORT

feature {PS_EIFFELSTORE_EXPORT} -- Status report

	can_handle (a_collection: ANY): BOOLEAN
			-- Can `Current' handle the collection `a_collection'?
		do
			Result := attached {COLLECTION_TYPE} a_collection
		end

	can_handle_type (type: PS_TYPE_METADATA): BOOLEAN
			-- Can `Current' handle the collection type `a_type'?
		do
			Result := type.reflection.type_conforms_to (type.type.type_id, ({detachable COLLECTION_TYPE}).type_id)
		end

	is_relationally_mapped (collection: PS_TYPE_METADATA; owner_type: PS_TYPE_METADATA): BOOLEAN
			-- Is `collection' mapped as a 1:N or M:N Relation between two objects?
		deferred
		end

	is_mapped_as_1_to_N (collection: PS_TYPE_METADATA; owner_type: PS_TYPE_METADATA): BOOLEAN
			-- Is `collection' mapped as a 1:N - Relation in the database?
		deferred
		ensure
			false_if_not_relational: not is_relationally_mapped (collection, owner_type) implies not Result
		end

feature {PS_EIFFELSTORE_EXPORT} -- Object graph creation

	create_collection_part (collection: ANY; metadata: PS_TYPE_METADATA; persistent: BOOLEAN; owner: PS_OBJECT_GRAPH_PART): PS_OBJECT_GRAPH_PART
			-- Create a new OBJECT_GRAPH_PART for `collection'.
		require
			can_handle_collection: can_handle (collection)
			owner_normal_object_if_relational: (owner.is_representing_object and then is_relationally_mapped (metadata, owner.metadata)) implies attached {PS_SINGLE_OBJECT_PART} owner
		do
				-- Create relational or object collection based on `is_relationally_mapped'
			if owner.is_representing_object and then is_relationally_mapped (metadata, owner.metadata) then
				check attached {PS_SINGLE_OBJECT_PART} owner as good_owner then
					create {PS_RELATIONAL_COLLECTION_PART} Result.make (collection, metadata, good_owner, persistent, is_mapped_as_1_to_N (metadata, owner.metadata), Current, owner.root)
				end
			else
				create {PS_OBJECT_COLLECTION_PART} Result.make (collection, metadata, persistent, Current, owner.root)
			end
		ensure
			collection_set: Result.represented_object = collection
			metadata_set: Result.metadata = metadata
			persitent_set: Result.is_persistent = persistent
			owner_set: attached {PS_RELATIONAL_COLLECTION_PART} Result as res implies res.reference_owner = owner
		end

	create_items (collection: PS_COLLECTION_PART; object_graph_factory: FUNCTION[ANY, TUPLE[detachable ANY], PS_OBJECT_GRAPH_PART]): LINKED_LIST[PS_OBJECT_GRAPH_PART]
		do
			create Result.make
			check attached {ITERABLE[detachable ANY]} collection.represented_object as real_collection then

				across
					real_collection as cursor
				loop
					Result.extend (object_graph_factory.item ([cursor.item]))
				end

			end
		end


	add_information (object_collection: PS_OBJECT_COLLECTION_PART)
			-- Add some additional information to `object_collection'.
		deferred
		end

feature {PS_EIFFELSTORE_EXPORT} -- Object retrieval

	build_collection (collection_type: PS_TYPE_METADATA; objects: LIST [detachable ANY]; additional_information: PS_RETRIEVED_OBJECT_COLLECTION): COLLECTION_TYPE
			-- Build a collection object of type `collection_type' with items `objects', using `additional_information' that contains information generated during the last insert.
		require
			can_handle_type: can_handle_type (collection_type)
		deferred
		end

	build_relational_collection (collection_type: PS_TYPE_METADATA; objects: LIST [detachable ANY]): COLLECTION_TYPE
			-- Build a collection object of type `collection_type' with items `objects'.
		require
			can_handle_type: can_handle_type (collection_type)
		deferred
		end

end