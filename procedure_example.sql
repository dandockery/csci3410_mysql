use Chattahoochee;

-- temporarily change the delimiter to something else
delimiter //

-- this procedure will perform 4 statements to process
-- items in the shopping cart 
CREATE PROCEDURE processShoppingCart (
	IN CustomerID INT, 
	IN AddressID INT
)
BEGIN

-- create the Order record
insert into Orders (cust_id, address_id, purchased_on, total_items_sold, total_price_sold)
select CustomerID, AddressID, now(), sum(s.quantity), sum(s.quantity * p.price_per_item) 
from ShoppingCart as s
join Products as p on s.product_id = p.product_id
where s.cust_id = CustomerID and s.saved_for_later = 0;

-- grab the identity of the last insert
set @order_id = last_insert_id();

-- create the Order Detail records
insert into OrderDetails (order_id, prod_id, quantity_purchased, price_per_item)
select @order_id, p.product_id, s.quantity, p.price_per_item
from ShoppingCart as s
join Products as p on s.product_id = p.product_id
where s.cust_id = CustomerID and s.saved_for_later = 0;

-- update products to reflect reduction in inventory
update Products as p
join ShoppingCart as s on p.product_id = s.product_id
set p.qty_on_hand = p.qty_on_hand - s.quantity
where s.cust_id = CustomerID and s.saved_for_later = 0;

-- delete records from shopping cart
delete from ShoppingCart
where cust_id = CustomerID and saved_for_later = 0;

END//

-- change the delimiter back to the normal semi-colon
delimiter ;