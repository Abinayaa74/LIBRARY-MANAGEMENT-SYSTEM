--table is created for books
create table books (
book_id number primary key,
title varchar2(100),
author varchar2(50),
publisher varchar2(50),
category varchar2(50),
available_copies number
);

--table is created for members
create table members (
member_id number primary key,
first_name varchar2(50),
last_name varchar2(50),
email varchar2(100),
phone_number varchar2(15),
address varchar2(200)
);
--table is created for transactions
create table borrowing_transactions (
transaction_id number primary key,
member_id number references members(member_id),
book_id number references books(book_id),
borrow_date date,
return_date date,
status varchar2(20)
);
--sequence for transactions
create sequence borrowing_transactions_seq start with 1 increment by 1;

--inserting values for table book
insert into books values (1, 'the great gatsby', 'f. scott fitzgerald', 'scribner', 'fiction', 5);
insert into books values (2, '1984', 'george orwell', 'secker & warburg', 'dystopian', 3);
insert into books values (3, 'to kill a mockingbird', 'harper lee', 'j.b. lippincott & co.', 'fiction', 4);
insert into books values (4, 'moby dick', 'herman melville', 'harper & brothers', 'adventure', 2);
insert into books values (5, 'pride and prejudice', 'jane austen', 't. egerton', 'romance', 6);
--inserting values for table members
insert into members values (1, 'arjun', 'reddy', 'arjun.reddy@example.com', '9876543210', '12 marina beach, chennai');
insert into members values (2, 'lakshmi', 'iyer', 'lakshmi.iyer@example.com', '8765432109', '34 anna nagar, chennai');
insert into members values (3, 'ravi', 'kumar', 'ravi.kumar@example.com', '7654321098', '56 t nagar, chennai');
insert into members values (4, 'sita', 'patel', 'sita.patel@example.com', '6543210987', '78 velachery, chennai');
insert into members values (5, 'vijay', 'singh', 'vijay.singh@example.com', '5432109876', '90 adyar, chennai');

--inserting values for table borrowing_transactions
insert into borrowing_transactions values (1, 1, 1, to_date('2023-07-01', 'yyyy-mm-dd'), null, 'borrowed');
insert into borrowing_transactions values (2, 2, 2, to_date('2023-07-02', 'yyyy-mm-dd'), null, 'borrowed');
insert into borrowing_transactions values (3, 3, 3, to_date('2023-07-03', 'yyyy-mm-dd'), null, 'borrowed');
insert into borrowing_transactions values (4, 4, 4, to_date('2023-07-04', 'yyyy-mm-dd'), null, 'borrowed');
insert into borrowing_transactions values (5, 5, 5, to_date('2023-07-05', 'yyyy-mm-dd'), null, 'borrowed');

--Creating a procedure to handle borrowing a book that can insert, update new information.
create or replace procedure borrow_book (
p_member_id in number,
p_book_id in number
) is
v_available_copies number;
v_transaction_id number;
begin

select available_copies into v_available_copies
from books
where book_id = p_book_id;

if v_available_copies > 0 then
begin
insert into borrowing_transactions (transaction_id, member_id, book_id, borrow_date, status)
values (borrowing_transactions_seq.nextval, p_member_id, p_book_id, sysdate, 'borrowed');
exception
when dup_val_on_index then
raise_application_error(-20001, 'Duplicate transaction_id encountered. Please retry.');
end;


update books
set available_copies = available_copies - 1
where book_id = p_book_id;

commit;
dbms_output.put_line('book borrowed successfully.');
else
dbms_output.put_line('book is not available.');
end if;
exception
when others then
dbms_output.put_line('Error: ' || SQLCODE || ' - ' || SQLERRM);
rollback; 
end;
/
--Creating a procedure to handle returning a book

create or replace procedure return_book (
p_transaction_id in number
) is
v_book_id number;
v_borrow_date date;
v_fine_rupees number; 
begin

update borrowing_transactions
set return_date = sysdate,
status = 'returned'
where transaction_id = p_transaction_id;


select book_id, borrow_date into v_book_id, v_borrow_date
from borrowing_transactions
where transaction_id = p_transaction_id;


v_fine_rupees := greatest(0, sysdate - v_borrow_date - 14) * 50; 


update books
set available_copies = available_copies + 1
where book_id = v_book_id;

commit;
dbms_output.put_line('book returned successfully. fine: ' || v_fine_rupees || ' rupees');
exception
when others then
dbms_output.put_line('Error: ' || SQLCODE || ' - ' || SQLERRM);
rollback; 
end;
/

--Creating a procedure to calculate fines for overdue books 

create or replace procedure calculate_fines_in_rupees is
cursor overdue_books is
select transaction_id, member_id, book_id, borrow_date
from borrowing_transactions
where return_date is null
and borrow_date < sysdate - 14;
v_fine_rupees number;
begin
for rec in overdue_books loop
v_fine_rupees := (sysdate - rec.borrow_date - 14) * 50; 
dbms_output.put_line('transaction id: ' || rec.transaction_id || ', fine in rupees: ' || v_fine_rupees);
end loop;
end;
/
--to view the tables created
select * from  books;

select * from  members;

select * from  borrowing_transactions;

--calling to see the output
begin
borrow_book(1, 1); 
end;
/

begin
return_book(1); 
end;
/


begin
calculate_fines_in_rupees;
end;
/
