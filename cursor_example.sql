# temporarily change the delimiter in order
# to create the procedure
delimiter $$

# remove the procedure if it exists already
# before we call CREATE PROCEDURE on it
drop procedure if exists getProductWebList$$

create procedure getProductWebList ()
begin

# create some local variables
declare finished int default 0;
declare product varchar(50) default "";
declare product_list varchar(1000) default "";

# create our cursor object
declare product_cursor cursor for 
	select prod_name from Products
	order by price_per_item desc;

# this is our exit condition
declare continue handler for not found set finished = 1;

# open up the cursor to populate it
open product_cursor;

# append HTML code for an ordered list
set product_list = '<ol>\n';

# start a loop
fetch_product_name: loop

	# grab the next product from the result set in the cursor
	fetch product_cursor into product;
    
    # check for exit condition
    if finished = 1 then
		leave fetch_product_name;
    end if;
    
    # append our product name to the ordered list between list tags
    set product_list = concat(product_list, '<li>', product, '</li>\n');

end loop fetch_product_name;

# close the ordered list HTML tag
set product_list = concat(product_list, '</ol>\n');

# close out the cursor to free up memory
close product_cursor;

# output the results
select product_list;

end$$

# reset our delimiter back
delimiter ;