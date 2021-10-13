drop table if exists audit_log;

create table audit_log (
	logid bigint primary key auto_increment,
    entry_ts timestamp not null default now(),
    event_msg text not null
);

delimiter //

drop trigger if exists tr_del_customer//

create trigger tr_del_customer
before delete
on Customers
for each row
begin
	insert into audit_log (event_msg)
    values (concat(OLD.first_name, OLD.last_name, ' was removed by ', USER()));
end//

delimiter ;