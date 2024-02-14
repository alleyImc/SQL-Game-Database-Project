CREATE OR ALTER TRIGGER trg_AyniUrunSatinAlma ON tblKullaniciUrunSatinAlma
AFTER INSERT
AS 
BEGIN

DECLARE @KullaniciID INT, @UrunID INT, @UrununFiyati MONEY;
SELECT @KullaniciID=KullaniciID , @UrunID=UrunID, @UrununFiyati=Fiyat
FROM inserted;

SELECT @UrununFiyati = Fiyat
    FROM tblKullaniciUrunSatinAlma
    WHERE UrunID = @UrunID AND KullaniciID = @KullaniciID;

    -- C�zdan g�ncelleme k�sm�
    UPDATE tblKullanici
    SET Cuzdan = Cuzdan - @UrununFiyati
    WHERE ID = @KullaniciID;
	END