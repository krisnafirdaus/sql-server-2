-- CREATE TABLE Kategori (
--     KategoriID INT PRIMARY KEY IDENTITY(1,1),
--     NamaKategori NVARCHAR(100) NOT NULL,
--     Deskripsi NVARCHAR(500)
-- )

-- CREATE TABLE Supplier (
--     SupplierID INT PRIMARY KEY IDENTITY(1,1),
--     NamaSupplier NVARCHAR(100) NOT NULL,
--     Alamat NVARCHAR(255),
--     NoTelepon NVARCHAR(15),
--     Email VARCHAR(100)
-- )

-- CREATE TABLE Produk (
--     ProdukID INT PRIMARY KEY IDENTITY(1,1),
--     NamaProduk NVARCHAR(100) NOT NULL,
--     Harga DECIMAL(12,2) NOT NULL,
--     Stok INT NOT NULL DEFAULT 0,
--     KategoriID INT,
--     SupplierID INT
-- )

-- SELECT * from sys.tables

-- -- constraint untuk validasi harga
-- ALTER TABLE Produk
-- ADD CONSTRAINT CK_Produk_Harga CHECK (Harga > 0);

-- -- constraint untuk validasi stock
-- ALTER TABLE Produk
-- ADD CONSTRAINT CK_Produk_Stock CHECK (stok >= 0);

-- -- constraint untuk validasi email format
-- ALTER TABLE Supplier
-- ADD CONSTRAINT CK_Supplier_Email CHECK (Email LIKE '%@%.%');


-- -- constraint untuk nomor telepon
-- ALTER TABLE Supplier
-- ADD CONSTRAINT CK_Supplier_NoTelepon CHECK (
--     NoTelepon LIKE '[0-9]%' 
--     AND LEN(NoTelepon) >= 10
--     AND NoTelepon NOT LIKE '%[^0-9]%'
-- );

-- CREATE TABLE Pelanggan (
--     PelangganID INT PRIMARY KEY IDENTITY(1,1),
--     NamaPelanggan NVARCHAR(100) NOT NULL,
--     TanggalLahir DATE,
--     JenisKelamin CHAR(1) CHECK (JenisKelamin IN ('L', 'P')),
--     Email VARCHAR(100) NOT NULL,
--     NoTelepon VARCHAR(15),
--     StatusAktif BIT DEFAULT 1,
--     TanggalDaftar DATETIME DEFAULT GETDATE(),

--     -- consraint untuk memastikan umur minimal 17 tahun
--     CONSTRAINT CK_Pelanggan_Umur CHECK (DATEDIFF(YEAR, TanggalLahir, GETDATE()) >= 17),
--     -- consraint untuk format email
--     CONSTRAINT CK_Pelanggan_Email CHECK (EMAIL LIKE '%@%.%'),
--     -- consraint untuk unique email
--     CONSTRAINT UQ_Pelanggan_Email UNIQUE (EMAIL),
-- );

-- ALTER TABLE Produk
-- ADD CONSTRAINT FK_Produk_Kategori
-- FOREIGN KEY (KategoriID) REFERENCES Kategori(KategoriID)
-- ON UPDATE CASCADE 
-- ON DELETE SET NULL;

-- ALTER TABLE Produk
-- ADD CONSTRAINT FK_Produk_Supplier
-- FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
-- ON UPDATE CASCADE 
-- ON DELETE SET NULL;

-- CREATE TABLE Pesanan (
--     PesananID INT PRIMARY KEY IDENTITY(1,1),
--     PelangganID INT NOT NULL,
--     TanggalPesanan DATETIME DEFAULT GETDATE(),
--     StatusPesanan VARCHAR(20) DEFAULT 'Pending',
--     TotalHarga DECIMAL(15,2) DEFAULT 0,

--     CONSTRAINT FK_Pesanan_Pelanggan
--     FOREIGN KEY (PelangganID) REFERENCES Pelanggan(PelangganID)
--     ON UPDATE CASCADE 
--     ON DELETE CASCADE,
    
--     CONSTRAINT CK_Pesanan_Status
--     CHECK (StatusPesanan IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Canceled')),
    
--     CONSTRAINT CK_Pesanan_TotalHarga
--     Check (TotalHarga >= 0),
-- );

-- CREATE TABLE DetailPesanan (
--     DetailID INT PRIMARY KEY IDENTITY(1,1),
--     PesananID INT NOT NULL,
--     ProdukID INT NOT NULL,
--     Jumlah INT NOT NULL,
--     HargaSatuan DECIMAL(12, 2) NOT NULL,
--     Subtotal AS (jumlah * HargaSatuan) PERSISTED,

--     CONSTRAINT FK_DetailPesanan_Pesanan
--     FOREIGN KEY (PesananID) REFERENCES Pesanan(PesananID)
--     ON UPDATE CASCADE 
--     ON DELETE CASCADE,

--     CONSTRAINT FK_DetailPesanan_Produk
--     FOREIGN KEY (ProdukID) REFERENCES Produk(ProdukID)
--     ON UPDATE CASCADE 
--     ON DELETE NO ACTION,

--     CONSTRAINT FK_DetailPesanan_Jumlah CHECK (Jumlah > 0),
--     CONSTRAINT FK_DetailPesanan_HargaSatuan CHECK (HargaSatuan > 0),

--     -- constraint untuk mencegah duplikasi produk dalam satuan pesanan
--     CONSTRAINT UQ_DetailPesanan_PesananProduk UNIQUE (PesananID, ProdukID),
-- )

-- ALTER TABLE Pelanggan
-- ADD Umur AS (DATEDIFF(YEAR, TanggalLahir, GETDATE()));


-- -- index untuk pencarian berdasarkan nama produk
-- CREATE INDEX IX_Produk_Nama ON Produk(NamaProduk);

-- -- index untuk pencarian berdasarkan kategori
-- CREATE INDEX IX_Produk_Kategori ON Produk(KategoriID);

-- --- composite index untuk pencarian berdasarkan kategori dan harga
-- CREATE INDEX IX_Produk_Kategori_Harga ON Produk(KategoriID, Harga);

-- -- index untuk foreign key (biasanaya otomatis, tapi bisa dibuat manual)
-- CREATE INDEX IX_DetailPesanan_PesananID ON DetailPesanan(PesananID);

--- melihat semua constraint dalam database
-- SELECT 
--     tc.CONSTRAINT_NAME,
--     tc.TABLE_NAME,
--     tc.CONSTRAINT_TYPE,
--     cc.COLUMN_NAME
-- from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
-- LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cc
--     ON tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
-- WHERE tc.TABLE_CATALOG = 'TokoOnlineDB'
-- ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;

-- menonaktifkan sementara
-- ALTER TABLE DetailPesanan NOCHECK CONSTRAINT FK_DetailPesanan_Produk;

-- aktifkan yang telah di nonaktifkan sementara
-- ALTER TABLE DetailPesanan CHECK CONSTRAINT FK_DetailPesanan_Produk;

-- menghapus constraint
-- ALTER TABLE Produk DROP CONSTRAINT CK_Produk_Harga;

-- menambahkan kembali constraint
-- ALTER TABLE Produk ADD CONSTRAINT CK_Produk_Harga CHECK (Harga > 0);

-- DELETE FROM Pesanan WHERE PesananID = 1123;

-- insert sample data
-- INSERT INTO Kategori (NamaKategori, Deskripsi) VALUES
-- ('Elektronik', 'Perangkat elektronik seperti ponsel, laptop, dan televisi'),
-- ('Pakaian', 'Berbagai jenis pakaian untuk pria, wanita, dan anak-anak'),
-- ('Rumah Tangga', 'Peralatan rumah tangga seperti perabotan dan dekorasi'),
-- ('Buku', 'Berbagai genre buku termasuk fiksi, non-fiksi, dan buku anak-anak');

-- INSERT INTO Supplier (NamaSupplier, Alamat, NoTelepon, Email) VALUES
-- ('TechSupply Co.', 'Jl. Teknologi No. 123, Jakarta', '02112345678', 'info@techsupply.co.id'),
-- ('FashionHub', 'Jl. Mode No. 45, Bandung', '02287654321', 'info@fashionhub.co.id'),
-- ('HomeEssentials', 'Jl. Rumah No. 67, Surabaya', '03123456789', 'info@homeessentials.co.id');

-- INSERT INTO Produk (NamaProduk, Harga, Stok, KategoriID, SupplierID) VALUES
-- ('iPhone 13', 999.99, 50, 1, 1),
-- ('Samsung Galaxy S21', 799.99, 30, 1, 1),
-- ('Nike Air Max', 120.00, 80, 2, 2),
-- ('Blender Philips', 49.99, 40, 3, 3),
-- ('Vacuum Cleaner Dyson', 299.99, 20, 3, 3),
-- ('The Great Gatsby', 10.99, 200, 4, NULL),
-- ('1984 by George Orwell', 8.99, 150, 4, NULL);

-- INSERT INTO Pelanggan (NamaPelanggan, TanggalLahir, JenisKelamin, Email, NoTelepon) VALUES
-- ('Andi Wijaya', '1990-05-15', 'L', 'andi.wijaya@example.com', '08123456789'),
-- ('Siti Aminah', '1985-08-22', 'P', 'siti.aminah@example.com', '08234567890'),
-- ('Budi Santoso', '2000-12-30', 'L', 'budi.santoso@example.com', '08345678901');

-- SELECT * FROM Produk;

-- inner join menampilkan produk beserta kategori
-- SELECT p.NamaProduk, p.Harga, k.NamaKategori from Produk p INNER JOIN Kategori k ON p.KategoriID = k.KategoriID;

--- inner join menampilkan produk beserta supplier
-- SELECT p.NamaProduk, p.Harga, s.NamaSupplier, s.NoTelepon from Produk p INNER JOIN Supplier s ON p.SupplierID = s.SupplierID;

-- multiple inner join menampilkan produk denga  kategori dan supplier
-- SELECT p.ProdukID, p.NamaProduk, p.Harga, p.Stok, s.NamaSupplier, k.NamaKategori 
-- from Produk p 
-- INNER JOIN Kategori k ON p.KategoriID = k.KategoriID
-- INNER JOIN Supplier s ON p.SupplierID = s.SupplierID
-- ORDER BY p.NamaProduk;

-- inner join where dan agregasi menampilkan total stock produk per ketegori
-- SELECT 
--     k.NamaKategori, 
--     COUNT(p.ProdukID) as JumlahProduk,
--     SUM(p.Stok) as TotalStok,
--     AVG(p.Harga) as RataRataHarga
-- from Kategori k 
-- INNER JOIN Produk p ON k.KategoriID = p.KategoriID
-- GROUP BY k.KategoriID, k.NamaKategori
-- ORDER BY TotalStok DESC;

-- left join menampilkan semua kategori beserta prduknya (termasuk kategori tanpa produk)
-- SELECT k.NamaKategori, p.NamaProduk, p.harga from Kategori k LEFT JOIN Produk p ON k.KategoriID = p.KategoriID ORDER BY k.NamaKategori, p.NamaProduk;

--left join menampilkan semua kategori beserta prduknya (termasuk produk tanpa kategori)
-- SELECT p.NamaProduk, p.harga, k.NamaKategori from Produk p LEFT JOIN Kategori k ON p.KategoriID = k.KategoriID ORDER BY p.NamaProduk;

-- SELECT * from Kategori;
-- SELECT * from Produk;

-- mencari kategori yang tidak memiliki produk
-- SELECT 
--     k.NamaKategori 
-- FROM Kategori k
-- LEFT JOIN Produk p ON k.KategoriID = p.KategoriID
-- WHERE p.KategoriID is NULL

-- right join (sama seperti LEFT JOIN tapi dibalik)
-- SELECT 
--     s.NamaSupplier, 
--     p.NamaProduk 
-- from Produk p
-- RIGHT JOIN Supplier s ON p.SupplierID = s.SupplierID 
-- ORDER BY s.NamaSupplier;

--full outer join - menampilkan semua data dari kedua table
-- SELECT 
--     p.NamaProduk,
--     k.NamaKategori
-- from Produk p
-- FUll OUTER JOIN Kategori k ON p.KategoriID = k. KategoriID
-- ORDER BY ma
--     p.NamaProduk,
--     k.NamaKategori;
 

-- self join
-- CREATE TABLE Karyawan (
--     KaryawanID INT PRIMARY KEY,
--     NamaKaryawan NVARCHAR(100),
--     ManagerID INT
-- )

-- INSERT INTO Karyawan VALUES
--     (1, 'John Manager', Null),
--     (2, 'Alice Staff', 1),
--     (3, 'Bob Staff', 1),
--     (4, 'Charlie Staff', 2);

-- self join untuk menampilkan karyawan dan managernya 
-- SELECT
--     k.NamaKaryawan AS Karyawan,
--     m.NamaKaryawan AS Manager
-- FROM Karyawan k 
-- LEFT JOIN Karyawan m on k.ManagerID = m.KaryawanID;

-- complex join dengan subquery menampilkan produk dengan harga di atas rata rata per kategori
-- SELECT
--     p.NamaProduk,
--     p.Harga,
--     k.NamaKategori,
--     rata.RataHarga
-- FROM
--     Produk p 
-- INNER JOIN Kategori k ON p.KategoriID = k.KategoriID
-- INNER JOIN (
--     SELECT 
--         KategoriID,
--         AVG(Harga) as RataHarga
--     FROM Produk
--     WHERE KategoriID IS NOT NULL
--     GROUP BY KategoriID
-- ) rata ON p.KategoriID = rata.KategoriID
-- WHERE p.Harga > rata.RataHarga
-- ORDER BY k.NamaKategori, p.Harga DESC;

-- -- laporan lengkap pesangan dengan detail product
-- CREATE TABLE TestPesanan (
--     PesananID INT PRIMARY KEY IDENTITY(1,1),
--     PelangganID INT,
--     TanggalPesanan DATETIME DEFAULT GETDATE()   
-- );

-- CREATE TABLE TestDetailPesanan (
--     DetailID INT PRIMARY KEY IDENTITY(1,1),
--     PesananID INT,
--     ProdukID INT,
--     Jumlah INT,
--     HargaSatuan DECIMAL(12,2),
-- );

-- -- Sample data
-- INSERT INTO TestPesanan (PelangganID) VALUES (1), (2);
-- INSERT INTO TestDetailPesanan (PesananID, ProdukID, Jumlah, HargaSatuan) VALUES 
--     (1, 1, 1, 1500000),
--     (1, 3, 2, 150000),
--     (2, 2, 1, 8000000);

-- select * from  TestPesanan;
-- select * from  TestDetailPesanan;

-- query laporang lengkap
SELECT
    pl.NamaPelanggan,
    ps.PesananID,
    ps.TanggalPesanan,
    pr.NamaProduk,
    k.NamaKategori,
    s.NamaSupplier,
    dp.Jumlah,
    dp.HargaSatuan,
    (dp.Jumlah * HargaSatuan) AS Subtotal
FROM TestPesanan ps
INNER JOIN Pelanggan pl ON ps.PelangganID = pl.PelangganID
INNER JOIN TestDetailPesanan dp ON ps.PesananID = dp.PesananID
INNER JOIN Produk pr ON dp.ProdukID = pr.ProdukID
LEFT JOIN Kategori k ON pr.KategoriID = k.KategoriID
LEFT JOIN Supplier s ON pr.SupplierID = s.SupplierID
ORDER BY ps.PesananID, dp.DetailID;



    