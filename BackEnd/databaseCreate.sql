CREATE TABLE Users (
    ID int PRIMARY KEY IDENTITY(1,1),
    userName nvarchar(50),
    mail nvarchar(50),
    password nvarchar(50),
    userType nvarchar(1), -- f çiftçi, v veteriner,s tedarikçi, a admin
    name nvarchar(50),
    surname nvarchar(50),
    telno nvarchar(10),
    farmName nvarchar(50),
    farmAdres nvarchar(250),
    area nvarchar(1) -- m marmara, e ege, k karadeniz
);

-- FeedType tablosu oluşturma
CREATE TABLE FeedTypes (
    ID int PRIMARY KEY IDENTITY(1,1),
    name nvarchar(50),
    price float
);

-- Feed tablosu oluşturma
CREATE TABLE feedRequests (
    ID int PRIMARY KEY IDENTITY(1,1),
    userID int,
    feedTypeID int,
    amount float,
    status nvarchar(1), -- r talep, s tedarikde, d teslim edildi, c iptal edildi
    requestResponsible int,
    requestDate date,
    deliveryDate date,
    FOREIGN KEY (userID) REFERENCES Users(ID),
    FOREIGN KEY (feedTypeID) REFERENCES FeedTypes(ID),
    FOREIGN KEY (requestResponsible) REFERENCES Users(ID)
);

-- MedicineType tablosu oluşturma
CREATE TABLE MedicineTypes (
    ID int PRIMARY KEY IDENTITY(1,1),
    name nvarchar(50),
    price float
);

-- Medicine tablosu oluşturma
CREATE TABLE medicineRequests (
   ID int PRIMARY KEY IDENTITY(1,1),
    userID int,
    medicineTypeID int,
    amount float,
    status nvarchar(1), -- r talep, s tedarikde, d teslim edildi, c iptal edildi
    requestResponsible int,
    requestDate date,
    deliveryDate date,
    FOREIGN KEY (userID) REFERENCES Users(ID),
    FOREIGN KEY (medicineTypeID) REFERENCES MedicineTypes(ID),
    FOREIGN KEY (requestResponsible) REFERENCES Users(ID)
);

-- Veterinarian tablosu oluşturma
CREATE TABLE veterinarianRequests (
    ID int PRIMARY KEY IDENTITY(1,1),
    userID int,
    status nvarchar(1), -- a aktif, p pasif
    diagnosis nvarchar(50),
    situation nvarchar(1), -- a aktif, p pasif 
    requestResponsible int,
    requestDate date,
    FOREIGN KEY (userID) REFERENCES Users(ID),
    FOREIGN KEY (requestResponsible) REFERENCES Users(ID)
);

INSERT INTO MedicineTypes (name, price)
VALUES (N'Antibyotik 1000 mg', 50.00),
       (N'Vomitus Suppresant 50 mg', 30.00),
       (N'Paracetamol 500 mg', 20.00),
       (N'Ivermectin 1%', 80.00),
       (N'Dewormer 500 mg', 40.00),
	   (N'Penicillin 500 mg', 25.00),
	   (N'Doxycycline 100 mg', 40.00),
       (N'Metronidazole 500 mg', 30.00),
       (N'Amoxicillin 875 mg', 35.00),
       (N'Cephalexin 500 mg', 20.00);

INSERT INTO FeedTypes (name, price)
VALUES (N'Yonca', 10.00),
       (N'Küspe', 5.00),
       (N'Kuru Ot', 3.00),
       (N'Kuru Yonca', 15.00),
       (N'Kuru Küspe', 10.00),
       (N'Kuru Ot', 5.00),
       (N'Kuru Yonca', 20.00);

INSERT INTO Users (userName, mail, password, userType, name, surname, telno, farmName, farmAdres, area)
VALUES 
('arkara', 'artun@email.com', '123456', 'f', 'Artun', 'Kara', '5551234567', 'Artunun Çiftliği', 'Kocaeli, Türkiye', 'm'),
('ekayhan', 'emirhan@email.com', '123456', 's', 'Emirhan', 'Kayhan', '5535061234', 'Kayhanlar A.Ş.', 'Kocaeli, Türkiye', 'm'),
('bfahri', 'baris@email.com', '123456', 'v', 'Barış Fahri', 'Kahrıman', '5456793456', 'Veteriner Barış', 'Kocaeli, Türkiye', 'm');


INSERT INTO feedRequests (userID, feedTypeID, amount, status, requestResponsible, requestDate, deliveryDate)
VALUES 
(1, 1, 100, 'r', NULL, '2024-05-05', NULL),
(1, 3, 50, 's', 2, '2024-05-03', '2024-06-04'),
(1, 2, 75, 'r', NULL, '2024-05-04', NULL),
(1, 5, 200, 'r', NULL, '2024-05-03', NULL),
(1, 4, 30, 'd', 2, '2024-05-04', '2024-05-05'),
(1, 3, 30, 'c', 2, '2024-05-04', NULL);

INSERT INTO medicineRequests (userID, medicineTypeID, amount, status, requestResponsible, requestDate, deliveryDate)
VALUES 
(1, 1, 5, 'r', NULL, '2024-05-05', NULL),
(1, 3, 10, 's', 2, '2024-05-03', '2024-06-04'),
(1, 2, 15, 's', 2, '2024-05-04', '2024-06-12'),
(1, 5, 20, 'r', NULL, '2024-05-03', NULL),
(1, 7, 8, 'd', 2, '2024-05-04', '2024-05-05'),
(1, 9, 12, 'c', 2, '2024-05-05', NULL);

INSERT INTO veterinarianRequests (userID, status, diagnosis, situation, requestResponsible, requestDate)
VALUES 
(1, 'a', NULL, 'e', NULL, '2024-05-05'),
(1, 'a', NULL, 'n', NULL, '2024-05-05'),
(1, 'p', 'Kuduz Aşısı', 'e', 3, '2024-05-03'),
(1, 'p', 'Parazit Temizliği', 'n', 3, '2024-05-04'),
(1, 'p', 'Kulak Enfeksiyonu', 'n', 3, '2024-05-03'),
(1, 'p', 'Yaralanma', 'e', 3, '2024-05-04');