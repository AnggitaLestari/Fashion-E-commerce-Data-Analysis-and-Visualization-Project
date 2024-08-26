select * from items 
select * from sales_records 
select * from users

-- soal no 1 = 
-- Tim Marketing ingin merumuskan promo pada tanggal-tanggal tertentu.
-- Produk apa yang paling banyak terjual, dan tanggal berapa penjualan itu terjadi?

WITH 
penjualan_produk AS (
  SELECT
    items.name AS nama_produk,
    sr.item_id,
    sr.purchased_at
  FROM items
	JOIN sales_records sr ON items.id = sr.item_id
)
-- Mencari produk dgn penjualan tertinggi dan tanggal penjualan terjadi
SELECT
  	item_id,
	nama_produk,
  	COUNT(*) AS qty_penjualan, 
	purchased_at AS tanggal_penjualan
FROM penjualan_produk
GROUP BY nama_produk, item_id, purchased_at
ORDER BY qty_penjualan  DESC
LIMIT 1

-- 

-- soal no 2 = 
-- Tim Marketing ingin memberi hadiah kepada pembeli 
-- yang paling banyak membeli barang dari segi jumlah barangnya.
-- Siapakah pelanggan tersebut?

SELECT 
users.name AS nama_pelanggan, 
count (*) AS total_pembelian_produk 
FROM users 
JOIN sales_records sr ON users.id = sr.user_id 
GROUP BY users.name 
ORDER BY total_pembelian_produk desc  
LIMIT 1


-- soal no 3 = 
-- Tim Keuangan ingin menelaah nominal modal (cost) produk. 
-- Berapa total cost pada pembelian produk 'Jaket Kulit'?

-- CTE mencari item_id dari produk jaket kulit dan costnya 
WITH total_cost_per_produk AS (
  SELECT
    i.id AS item_id,
    i.name AS nama_produk,
    i.cost AS cost
  FROM items i
  WHERE i.name = 'jaket kulit'
),

-- CTE mencari jumlah pembelian jaket kulit dari tabel sales_records
-- item_id jaket kulit = 23 
total_purchases AS (
  SELECT
    sr.item_id,
    COUNT(*) AS jumlah_pembelian
  FROM sales_records sr
  WHERE item_id = '23'		
  GROUP BY sr.item_id
)

-- mencari total cost pada pembelian produk 'Jaket Kulit'
-- Join CTE untuk mengalikan cost dengan jumlah pembelian jaket kulit
SELECT
  tcp.nama_produk,
  tcp.cost,
  tp.jumlah_pembelian,
  tcp.cost * tp.jumlah_pembelian AS total_cost
FROM total_cost_per_produk tcp
JOIN total_purchases tp ON tcp.item_id = tp.item_id

-- 


-- soal no 4 =
-- Tim marketing dan produk ingin mengetahui gambaran pengguna yang aktif berbelanja. 
-- Cari tahu jumlah pengguna aktif dan presentasenya! 
SELECT
-- Menghitung jumlah total pengguna
    COUNT(DISTINCT users.id) AS total_pengguna,
	
-- Menghitung jumlah pengguna aktif
    COUNT(DISTINCT sales_records.user_id) AS pengguna_aktif,
	
-- Menghitung persentase pengguna aktif
    COUNT(DISTINCT sales_records.user_id) * 100.0 / 
	COUNT(DISTINCT users.id) AS pengguna_aktif_persentase	
FROM users
LEFT JOIN sales_records ON users.id = sales_records.user_id


-- 


-- soal no 5 =
-- a. frekuensi rata-rata pembelian pengguna aktif
-- 	frekuensi rata2	pembelian = 1.0 * (jmlh total pembelian di situs) / (jumlah pengguna aktif)

SELECT
-- menghitung jumlah total pembelian 
	COUNT (*) AS total_pembelian,
-- menghitung jumlah pengguna aktif	
	COUNT(DISTINCT sales_records.user_id) 
	AS pengguna_aktif,
-- menghitung frekuensi rata-rata pembelian 
	(1.0 * COUNT(*) / COUNT (DISTINCT sales_records.user_id)) 
	AS frekuensi_pembelian
FROM sales_records


-- b. pengeluaran rata-rata pengguna aktif
-- 	pengeluaran rata2 = 1.0 * (jmlh harga barang yang terjual) / (jumlah pengguna aktif)
WITH
  pengguna_aktif AS (
    SELECT count(DISTINCT user_id)
    FROM sales_records
  ),
  belanja_pelanggan AS (
    SELECT
	  user_id,
      SUM(price) AS total_belanja_pelanggan
    FROM sales_records sr
    JOIN items i
      ON sr.item_id = i.id
    GROUP BY 1
	  order by 1
  ),
  avg_belanja AS (
    SELECT
      1.0 * (SELECT AVG(total_belanja_pelanggan) FROM belanja_pelanggan)/
        (SELECT COUNT(*) FROM pengguna_aktif) as pengeluaran_rata_rata
  )
SELECT *
FROM avg_belanja


-- c. pengeluaran rata-rata per pembelian pengguna aktif
-- 	pengeluaran rata2 per pembelian = 1.0 * (belanja rata2) / (frekuensi rata2 pembelian)

WITH
  pengguna_aktif AS (
    SELECT count(DISTINCT user_id)
    FROM sales_records
  ),
  belanja_pelanggan AS (
    SELECT
	  user_id,
      SUM(price) AS total_belanja_pelanggan
    FROM sales_records sr
    JOIN items i
      ON sr.item_id = i.id
    GROUP BY user_id
	  order by 1
  ),
  avg_belanja AS (
    SELECT
      1.0 * (SELECT AVG(total_belanja_pelanggan) FROM belanja_pelanggan)/
        (SELECT COUNT(*) FROM pengguna_aktif) as pengeluaran_rata_rata
  ),
  frekuensi_rata_rata_pembelian as (
	 SELECT
	  1.0 * count(*) / COUNT (DISTINCT user_id) as frekuensi_pembelian FROM sales_records 
  ),
  avg_belanja_per_pembelian as (
  	  SELECT
  1.0 * (SELECT * from avg_belanja)/(select * from frekuensi_rata_rata_pembelian) as avg_belanja_per_pembelian
  )
	  
SELECT *
FROM avg_belanja_per_pembelian
	  
	  