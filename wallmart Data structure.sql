Create Database if not exists WallMart_Sales;
use wallmart_sales;
CREATE TABLE IF NOT EXISTS Sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    prodect_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(10 , 2 ),
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payement VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_marigin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ),
    rating FLOAT(2 , 1 )
);


