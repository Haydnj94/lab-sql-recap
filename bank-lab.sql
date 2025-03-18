use bank;

select client_id, birth_number
from client
limit 10;

select distinct `type`
from trans
;

select account_id, `date`
from `account`
where `date` > 960101
order by `date` 
;

select count(trans_id) as total_transactions
from trans
;

select loan_id, amount, `date`
from loan
where amount > 50000
order by `date` desc;

SELECT c.client_id, a.account_id  
FROM client c  
INNER JOIN account a using(district_id)
;

SELECT t.trans_id, c.client_id
FROM account a  
INNER JOIN client c using(district_id)
inner join trans t using (account_id)
;

select c.client_id, a.account_id, cd.type
from disp d
inner join account a using (account_id)
inner join client c using (client_id)
inner join card cd using (disp_id)
where cd.type = 'classic'
;

select l.*, a.*
from account a
inner join loan l using (account_id)
;

select count(t.trans_id) as total_trans, a.account_id
from account a
inner join trans t using (account_id)
group by  a.account_id
order by total_trans desc
;

select client_id
from `client`
;


select c.client_id
from `client` c
where c.client_id in (select d.client_id
					from disp d
                    where d.account_id in (select l.account_id
										from loan l
                                        where l.amount > 100000)
);


select a.account_id
from account a
where a.account_id in (select t.account_id
					from trans t
                    group by t.account_id
                    having count(t.trans_id) > 10) 
;
				
select c.client_id
from client c
where c.client_id in (select d.client_id
					from disp d
                    where d.disp_id  not in (select cd.disp_id
											from card cd
											));

select a.account_id
from account a
where a.account_id in (select l.account_id
						from loan l
                        order by l.amount desc
						)
                        limit 1
                        ;
                        
select a.account_id
from account a
where a.account_id in (select t.account_id 
						from trans t
                        group by t.account_id 
                        having sum(t.amount) > 500000)
                        ;
                        

             
WITH TransactionCount AS (
    SELECT t.account_id, COUNT(t.trans_id) AS total_transactions
    FROM trans t
    GROUP BY t.account_id
)
SELECT account_id, total_transactions
FROM TransactionCount;

Select trans_id, amount, date, account_id,
	sum(amount) over (
		partition by account_id
        order by date
	) as running_total
from trans;

select account_id, loan_id, amount,
	dense_rank() over (order by amount desc) as `rank`
from loan;

select *
from (select c.client_id, t.trans_id, t.date,
			row_number() over (partition by client_id order by t.date asc) as trans_order
		from client c
		inner join disp d 
		using (client_id)
		inner join trans t
		using (account_id)) as ot
	where trans_order = 1;