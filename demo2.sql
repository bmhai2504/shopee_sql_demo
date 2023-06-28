use shopee_demo;

# cau 1
insert into category (cateName)
values  ('Thoi Trang Nam'),
        ('Thoi Trang Nu'),
        ('Thiet bi dien tu'),
        ('Laptop'),
        ('Dien thoai');
insert into product (productName, productPrice, cateID)
values  ('Áo Sweater Nam', 139000, 1),
        ('Áo sơ mi ngắn tay', 190000, 1),
        ('Quần đùi thun nam', 150000, 1),
        ('Áo Sơ Mi Nam Dài Tay', 220000, 1),
        ('Áo Polo Basic', 165000, 1),

        ('Chân Váy KaKi', 120000, 2),
        ('Áo Khoác Cardigan', 140000, 2),
        ('Quần Short Nữ', 130000, 2),
        ('Đầm Body Nữ', 120000, 2),
        ('SET PIJAMA', 220000, 2),

        ('Loa bluetooth', 240000, 3),
        ('Android TV Box', 750000, 3),
        ('Tay cầm cho PC Xbox', 380000, 3),
        ('Tai nghe nhét tai không dây BASEUS', 238000, 3),
        ('Dây cáp HDMI', 80000, 3),

        ('Apple Macbook Air', 35000000, 4),
        ('Laptop Dell', 18500000, 4),
        ('Laptop Acer ', 15800000, 4),
        ('Laptop Asus ', 16750000, 4),
        ('Laptop ThinkPad', 19000000, 4),

        ('Dien thoai Apple', 29800000, 5),
        ('Dien thoai Samsung', 21000000, 5),
        ('Dien thoai Oppo', 17500000, 5),
        ('Dien thoai Hwuawei', 20100000, 5),
        ('Dien thoai Xiaomi', 15200000, 5);
insert into variant (variantSize, variantColor, productID)
values ('m', 'white', 1),
       ('l', 'black', 1),
       ('m', 'blue', 2),
       ('l', 'white', 2),
       ('m', 'white', 3),
       ('l', 'pink', 3),

       ('s', 'white', 6),
       ('xs', 'black', 6),
       ('s', 'blue', 7),
       ('xs', 'black', 7),
       ('s', 'pink', 8),
       ('xs', 'gray', 8);
insert into variant (variantColor, productID)
values ('black', 11),
       ('white', 11),
       ('black', 12),
       ('white', 12),
       ('black', 13),
       ('white', 13),

       ('black', 16),
       ('white', 16),
       ('black', 17),
       ('white', 17),
       ('black', 18),
       ('white', 18),

       ('black', 21),
       ('white', 21),
       ('black', 22),
       ('white', 22),
       ('black', 23),
       ('white', 23);
insert into users (userEmail, userPassword)
values ('user1', '123'),
       ('user2', '123'),
       ('user3', '123'),
       ('user4', '123'),
       ('user5', '123');

#cau 2 : show category
select *
from category;

#cau 3 : show product co cate_id = 1
select *
from product
where cateID = 1
order by productPrice asc limit 2 offset 0;

#cau 4 : show product_detail co id = 2
select product.productID, product.productName, product.productPrice, product.cateID, variant.variantSize, variant.variantColor, variant.variantID
from product
inner join variant on product.productID = variant.productID
where product.productID = 16;


#cau 5 : tao carline
insert into cart (total, userID)
    values (0, 1);

delimiter //
create procedure addCartLine (
        IN cart_ID int,
        IN product_ID int,
        IN variant_ID int,
        IN product_Price int,
        IN product_Quantity int
        )
    begin
        insert into cartline(cartID, productID, variantID, productPrice, quantity, subTotal)
            values (cart_ID, product_ID, variant_ID, product_Price, product_quantity, product_Price * product_Quantity);
    end //
    delimiter ;

call addCartLine(1,1, 2, 139000, 2);
call addCartLine(1, 2, 3, 190000, 3);
call addCartLine(1, 11, 14, 240000, 1);
call addCartLine(1, 16, 19, 35000000, 1);


#cau 6
select cart.cartID, cartline.productID, cartline.variantID, cartline.productPrice, cartline.quantity, cartline.subTotal
from cartline
inner join cart on cartline.cartID = cart.cartID;

#cau 7
update cartline
set quantity = 5
where cartlineID = 4;

#cau 8

create table orderdetail (
    orderdetailID int not null auto_increment primary key ,
    orderID int,
    productID int,
    variantID int,
    quantity int,
    foreign key (orderID) references orders (orderID),
    foreign key (productID) references product (productID),
    foreign key (variantID) references variant (variantID)
);

delimiter //
create procedure create_order (
        in user_ID int,
        in address_user varchar(50)
)
begin
    insert into orders (userID, address)
        values (user_ID, address_user);
end;//
    delimiter ;

call create_order(1, "TPHCM");

delimiter //
create procedure create_order_detail (
        in order_ID int,
        in product_ID int,
        in variant_ID int,
        in quantity_detail int
)   begin
    insert into orderdetail (orderID, productID, variantID, quantity)
        values (order_ID, product_ID, variant_ID, quantity_detail);
end;//
delimiter ;

call create_order_detail(1, 1, 1, 3);

delete from cartline;

#cau 9
select u.userEmail AS User_Email, od.quantity * p.productPrice AS Total
from users u
join orders o on u.userID = o.userID
join orderdetail od on o.orderID = od.orderID
join product p on od.productID = p.productID;