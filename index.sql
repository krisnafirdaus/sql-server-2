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

SELECT * from sys.tables

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
SELECT 
    tc.CONSTRAINT_NAME,
    tc.TABLE_NAME,
    tc.CONSTRAINT_TYPE,
    cc.COLUMN_NAME
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cc
    ON tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
WHERE tc.TABLE_CATALOG = 'TokoOnlineDB'
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;


-- menonaktifkan sementara
-- ALTER TABLE DetailPesanan NOCHECK CONSTRAINT FK_DetailPesanan_Produk;

-- aktifkan yang telah di nonaktifkan sementara
-- ALTER TABLE DetailPesanan CHECK CONSTRAINT FK_DetailPesanan_Produk;

-- menghapus constraint
-- ALTER TABLE Produk DROP CONSTRAINT CK_Produk_Harga;

-- menambahkan kembali constraint
-- ALTER TABLE Produk ADD CONSTRAINT CK_Produk_Harga CHECK (Harga > 0);