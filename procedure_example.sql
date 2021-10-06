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
insert into Orders(cust_id, address_id, purchased_on, total_items_sold, total_price_sold)
select CustomerID, AddressID, now(), sum(s.quantity), sum(s.quantity * p.price_per_item) 
from ShoppingCart as s
join Products as p on s.product_id = p.product_id
where s.cust_id = @CustomerID;

-- create the Order Detail records

-- update products to reflect reduction in inventory

-- delete records from shopping cart

END//

-- change the delimiter back to the normal semi-colon
delimiter ;