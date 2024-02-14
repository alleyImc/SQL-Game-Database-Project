CREATE OR ALTER PROCEDURE  dbo.sp_OyunSatisi (@KullaniciID INT, @UrunID INT)
AS 
BEGIN
	
	BEGIN TRANSACTION
	BEGIN TRY
---�ncelikle Fiyat ve Cuzdan e�le�mesi yap�l�r
---Cuzdanda para var m� kontrolu yap�l�r yoksa RAISERROR('',16,1); yazd�r�l�r
--Cuzdanda para varsa i�lem basarili denir tabloya eklenir ve cuzdan� guncelleme k�sm� triggerda yap�l�r

	DECLARE @UrununFiyati MONEY;
	SELECT @UrununFiyati=Fiyat
	FROM tblKullaniciUrunSatinAlma
	WHERE @UrunID=UrunID;

	DECLARE @MevcutBakiye MONEY;
	SELECT @MevcutBakiye=Cuzdan
	FROM tblKullanici
	WHERE @KullaniciID=ID;

	IF @UrununFiyati>@MevcutBakiye
		BEGIN
			RAISERROR('Yetersiz bakiye. Sat�� tamamlanamad�.',16,1);			
		END
    ELSE BEGIN
	DECLARE @SeriNumarasi VARCHAR(25) = CONVERT(VARCHAR(MAX), NEWID());
		INSERT INTO tblKullaniciUrunSatinAlma VALUES(@SeriNumarasi, GETDATE(), @UrununFiyati, @KullaniciID,@UrunID);
		PRINT 'Sat�� i�lemi ger�ekle�tirildi';
		END
		END TRY
	BEGIN CATCH
		PRINT 'Hata Olu�tu: ' + ERROR_MESSAGE();
	END CATCH
	
	COMMIT TRANSACTION
	END
	
    EXEC dbo.sp_OyunSatisi 1,1 --daha �nce al�nan bir oyun
	EXEC dbo.sp_OyunSatisi 5,1 -- daha �nce al�nmam�� bir oyun
	EXEC dbo.sp_OyunSatisi 555,1