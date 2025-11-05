
create database APEX_Gear;
use master

drop database APEX_Gear
USE [APEX_Gear]

GO


-- 2. Create the Products table (Merch, Collectibles - with Wearable flag)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    ImageURL NVARCHAR(255) NOT NULL,
    Category NVARCHAR(50) NOT NULL, -- F1, MotoGP, GT3, Collectible
    IsWearable BIT DEFAULT 0 -- Flag to determine if Size selection is needed (1 = Yes, 0 = No)
);
GO

-- 3. Create the Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 4. Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    ShippingName NVARCHAR(100),
    ShippingAddress NVARCHAR(255),
    ShippingCity NVARCHAR(50),
    ShippingZipCode NVARCHAR(10),
    ShippingPhone NVARCHAR(20),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- 5. Create the Cart table (CRITICAL UPDATE: Added Size column)
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    SessionID VARCHAR(255),
    UserID INT,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Size NVARCHAR(10) NULL, -- S, M, L, XL (NULL for non-wearable items)
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    -- Constraint to ensure unique item per user/session *and* per size
    UNIQUE (UserID, ProductID, Size), 
    UNIQUE (SessionID, ProductID, Size)
);
GO

-- 6. Create the OrderItems table (CRITICAL UPDATE: Added Size column)
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Size NVARCHAR(10) NULL, -- Store the selected size at the time of order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO
delete from  Products;
-- 7. Create the ContactMessages table
CREATE TABLE ContactMessages (
    MessageID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Subject NVARCHAR(255),
    MessageContent NVARCHAR(MAX) NOT NULL,
    ReceivedAt DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0 -- 0=New, 1=Read
);
GO

-- 8. Insert initial product data for APEX Gear
INSERT INTO Products (Name, Description, Price, ImageURL, Category, IsWearable) VALUES
('Red Bull Racing F1 Team Polo', 'Official 2024 Team Polo. Breathable fabric.', 15000.00, 'https://www.xceleratesport.co.za/cdn/shop/files/Red_Bull_Racing_F1_Men_s_2024_Team_Polo_Shirt_-_Navy.png?v=1721349301', 'F1', 1),
('Max Verstappen 1:18 Scale Diecast', 'High detail collectible diecast model.', 25000.00, 'https://m.media-amazon.com/images/I/71uwJugNNxL.jpg', 'Collectible', 0),
('MotoGP Yamaha Petronas Hoodie', 'Comfortable hoodie with team branding.', 18000.00, 'https://m.media-amazon.com/images/I/61zjbbw4jRL.jpg', 'MotoGP', 1),
('GT3 Mercedes-AMG Team Cap', 'Official team issue cap. Adjustable strap.', 6500.00, 'https://shop-int.mercedesamgf1.com/cdn/shop/files/JW6268_1_HARDWARE_Photography_FrontCenterView_grey150125_a9da7295-7500-466a-b4d0-40786425df5e.jpg?v=1761171358&width=1600', 'GT3', 1),
('Ferrari F1 Sainz Replica Helmet', '1:5 scale replica of Carlos Sainz helmet.', 12000.00, 'https://www.carmodelstore.co.uk/cdn/shop/files/PRODUCTLISTINGTEMPLATE_2_9eae6297-b4a0-40d2-8029-a6a477665c81.png?v=1750768764&width=1920', 'Collectible', 0),
('MotoGP Ducati Lenovo Jersey', 'Official replica jersey of the Ducati team.', 16000.00, 'https://paddockclub.co.za/wp-content/uploads/2025/05/DUCATI-FRONT.jpg', 'MotoGP', 1),
(' McLaren F1 Pit Stop Crew T-shirt', 'Wear the crew look. Durable cotton.', 9000.00, 'https://cdn.webshopapp.com/shops/190718/files/477647087/mclaren-team-set-up-t-shirt-automn-glory-2025.jpg', 'F1', 1);
GO
delete from Products where Price=15000.00;
-- 9. Insert Admin Users (Password hash for 'hama' and '3466' - same as original)
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'ABID')
BEGIN
    INSERT INTO Users (Username, Email, PasswordHash) VALUES
    ('HAMAYAL', 'admin@apexgear.com', '$2y$10$tH.g6e0k7J9V4P1M2A5S8B9C6D3E7F4G1H0I2J3K4L5M6N7O8P9Q0R1S2T3U4V5');
END

IF NOT EXISTS (SELECT 2 FROM Users WHERE Username = 'ABID')
BEGIN
    INSERT INTO Users (Username, Email, PasswordHash) 
    VALUES ('ABID', 'abid@apexgear.com', '$2y$10$tH.g6e0k7J9V4P1M2A5S8B9C6D3E7F4G1H0I2J3K4L5M6N7O8P9Q0R1S2T3U4V5');
END
GO

use master;
drop database APEX_Gear;
drop table Products;
select*from Products;
select*from Users;
truncate table Products;