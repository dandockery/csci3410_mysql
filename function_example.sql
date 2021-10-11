delimiter //

drop function if exists Chattahoochee.getPrimaryAddress//

create function Chattahoochee.getPrimaryAddress ( CustomerID INT )
returns INT 
DETERMINISTIC
begin
	select address_id into @addrid
    from Addresses
    where cust_id = CustomerID and is_primary = 1
    LIMIT 1;
    
    return @addrid;
end//

delimiter ;