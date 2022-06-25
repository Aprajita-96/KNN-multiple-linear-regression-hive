set hive.strict.checks.cartesian.product=false;
create table if not exists score (seat int, midterm int, att double, hw double, quiz double, final double, total double)
row format delimited
fields terminated by ','
stored as textfile
tblproperties('skip.header.line.count' = '1');

load data local inpath 'score.csv' overwrite into table score;

Create view if not exists score2 as select hw as x, quiz as z, final as y from score;

create view if not exists products as select pow(z,2) as z2, pow(x,2) as x2, x*y as xy, x*z as xz, z*y as zy from score2;

create view if not exists beta as select (sum(xy)*sum(z2) - sum(zy)*sum(xz))/(sum(x2)*sum(z2)- sum(xz)*sum(xz)) as beta1 , (sum(zy)*sum(x2) - sum(xy)*sum(xz))/(sum(x2)*sum(z2)- sum(xz)*sum(xz)) as beta2 from products;
 
create view if not exists avgs as select avg(x) as xbar , avg(z) as zbar, avg(y) as ybar from score2;

select (ybar-(beta1*xbar)-(beta2*zbar)) as beta0,beta1,beta2 from avgs,beta;