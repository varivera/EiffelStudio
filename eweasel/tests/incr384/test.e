class TEST

inherit
	TEST1 [INTEGER]
		redefine
			try
		end
create
	make

feature
	
	make
		do
			try
		end

	try
		do
			precursor
		end

	weasel (a, b: INTEGER)
		do
			stoat (a, b)
		end
	
	stoat (a, b: INTEGER)
		external "C inline"
		alias "[
			printf("%d %d\n", $a, $b);
			]"
		end
	
end
