indexing

	description:
		"Binary tree: each node may have a left child and a right child";

	status: "See notice at end of class";
	names: binary_tree, tree, fixed_tree;
	representation: recursive, array;
	access: cursor, membership;
	contents: generic;
	date: "$Date$";
	revision: "$Revision$"

class BINARY_TREE [G] inherit

		CELL [G];

		TREE [G]
			redefine
				parent,
				is_leaf,
				subtree_has,
				subtree_count,
				fill_list,
				child_remove,
				child_after
			end

creation

	make

feature -- Initialization

	make (v: like item) is
			-- Create a root node with value v
		do
			item := v
		ensure
			is_root;
			is_leaf
		end;

feature -- Access

	parent: BINARY_TREE [G];
			-- Parent of current node

	child_index: INTEGER;
			-- Index of cursor position

	left_child: like parent;
			-- Left child, if any

	right_child: like parent;
			-- Right child, if any

	left_item: like item is
			-- Value of left child
		require
			has_left: left_child /= Void
		do
			Result := left_child.item
		end;

	right_item: like item is
			-- Value of right child
		require
			has_right: right_child /= Void
		do
			Result := right_child.item
		end;

	first_child: like parent is
			-- Left child
		do
			Result := left_child
		end;

	last_child: like parent is
			-- Right child
		do
			Result := right_child
		end;

	child: like parent is
			-- Child at cursor position
		do
			inspect
				child_index
			when 1 then
				Result := left_child
			when 2 then
				Result := right_child
			end
		end;

	child_cursor: CURSOR is
			-- Current cursor position
		do
			!ARRAYED_LIST_CURSOR! Result.make (child_index)
		end;

	left_sibling: like parent is
			-- Left neighbor, if any
		do
			if parent.right_child = Current then
				Result := parent.left_child
			end
		end;

	right_sibling: like parent is
			-- Right neighbor, if any
		do
			if parent.left_child = Current then
				Result := parent.right_child
			end
		end;
feature -- Measurement

	arity: INTEGER is
			-- Number of children
		do
			if has_left then
				Result := Result + 1
			end;
			if has_right then
				Result := Result + 1
			end;
		ensure then
			valid_arity: Result <= 2
		end;

feature -- Status report

	child_after: BOOLEAN is
			-- Is there no valid child position to the right of cursor?
		do
			Result := child_index >= arity + 1
		end;

	is_leaf, has_none: BOOLEAN is
			-- Are there no children?
		do
			Result := left_child = Void and right_child = Void
		end;

	has_left: BOOLEAN is
			-- Has current node a left child?
		do
			Result := left_child /= Void
		ensure
			Result = (left_child /= Void)
		end;

	has_right: BOOLEAN is
			-- Has current node a right child?
		do
			Result := right_child /= Void
		ensure
			Result = (right_child /= Void)
		end;

	has_both: BOOLEAN is
			-- Has current node two children?
		do
			Result := left_child /= Void and right_child /= Void
		ensure
			Result = (has_left and has_right)
		end;


feature -- Element change

	put_left_child (n: like parent) is
			-- Set `left_child' to `n'.
		require
			no_parent: n = Void or else n.is_root
		do
			if left_child /= Void then
				left_child.attach_to_parent (Void)
			end;
			if n /= Void then
				n.attach_to_parent (Current);
			end
			left_child := n
		end;

	put_right_child (n: like parent) is
			-- Set `right_child' to `n'.
		require
			no_parent: n = Void or else n.is_root
		do
			if right_child /= Void then
				right_child.attach_to_parent (Void)
			end;
			if n /= Void then
				n.attach_to_parent (Current);
			end
			right_child := n
		end;

	child_put, child_replace (v: like item) is
			-- Put `v' at current child position.
		do
			child.put (v);
		end;

	put_child, replace_child (n: like parent) is
			-- Put `n' at current child position.
		do
			inspect
				child_index
			when 1 then
				left_child := n
			when 2 then
				right_child := n
			end
		end;

feature -- Removal

	remove_left_child is
		do
			if left_child /= Void then
				left_child.attach_to_parent (Void)
			end;
			left_child := Void
		ensure
			not has_left
		end;

	remove_right_child is
		do
			if right_child /= Void then
				right_child.attach_to_parent (Void)
			end;
			right_child := Void
		ensure
			not has_right
		end;

	child_remove is
		do
			inspect
		 		child_index
			when 1 then
				left_child.attach_to_parent (Void);
				left_child := Void
			when 2 then
				right_child.attach_to_parent (Void);
				right_child := Void
			end
		end;

	prune (n: like parent) is
		do
			if left_child = n then
				remove_left_child
			elseif right_child = n then
				remove_right_child
			end
		end;

feature	-- Cursor movement

	child_go_to (p: CURSOR) is
			-- Move cursor to child remembered by `p'.
		do
			--child_index := p.child_index
		end;

	child_start is
			-- Move to first child.
		do
			child_index := 1
		end;

	child_finish is
			-- Move cursor to last child.
		do
			child_index := 2
		end;

	child_forth is
			-- Move cursor to next child.
		do
			child_index := child_index + 1
		end;

	child_back is
			-- Move cursor to previous child.
		do
			child_index := child_index - 1
		end;

	child_go_i_th (i: INTEGER) is
			-- Move cursor to `i'-th child.
		do
			child_index := i
		end;

feature -- Duplication

	duplicate (n: INTEGER): like Current is
			-- Copy of sub-tree beginning at cursor position and
			-- having min (`n', `arity' - `child_index' + 1)
			-- children.
		do
			Result := new_tree;
			if child_index <= 1 and child_index + n >= 1 and has_left then
				Result.put_left_child (left_child.duplicate_all)
			end;
			if child_index <= 2 and child_index + n >= 2 and has_right then
				Result.put_right_child (right_child.duplicate_all)
			end
		end;

	duplicate_all: like Current is
		do
			Result := new_tree;
			if has_left then
				Result.put_left_child (left_child.duplicate_all)
			end;
			if has_right then
				Result.put_right_child (right_child.duplicate_all)
			end;
		end;

feature {BINARY_TREE} -- Implementation

	fill_list (al: ARRAYED_LIST [G]) is
			-- Fill `al' with all the children's items.
		do
			if left_child /= Void then
				al.extend (left_child.item);
				left_child.fill_list (al)
			end;
			if right_child /= Void then
				al.extend (right_child.item);
				right_child.fill_list (al)
			end
		end;

feature {NONE} -- Implementation

	subtree_has (v: G): BOOLEAN is
		do
			if left_child /= Void then
				Result := left_child.has (v)
			end;
			if right_child /= Void and not Result then
				Result := right_child.has (v)
			end
		end;

	subtree_count: INTEGER is
		do
			if left_child /= Void then
				Result := left_child.count
			end;
			if right_child /= Void then
				Result := Result + right_child.count
			end
		end;

	fill_subtree (other: BINARY_TREE [G]) is
		do
			if not other.is_leaf then
				put_left_child (other.left_child.duplicate_all);
			end;
			if other.arity >= 2 then
				put_right_child (other.right_child.duplicate_all);
			end;
		end;

	new_tree: like Current is
		do
			!!Result.make (item)
		end;

	child_capacity: INTEGER is 2;

invariant

	child_capacity = 2

end -- class BINARY_TREE


--|----------------------------------------------------------------
--| EiffelBase: Library of reusable components for Eiffel.
--| Copyright (C) 1986-1998 Interactive Software Engineering (ISE).
--| For ISE customers the original versions are an ISE product
--| covered by the ISE Eiffel license and support agreements.
--| EiffelBase may now be used by anyone as FREE SOFTWARE to
--| develop any product, public-domain or commercial, without
--| payment to ISE, under the terms of the ISE Free Eiffel Library
--| License (IFELL) at http://eiffel.com/products/base/license.html.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://eiffel.com
--|----------------------------------------------------------------

