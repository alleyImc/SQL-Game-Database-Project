CREATE OR ALTER PROCEDURE  dbo.sp_OyunSatisi (@KullaniciID INT, @UrunID INT)
AS 
BEGIN
	
	BEGIN TRANSACTION
	BEGIN TRY
---öncelikle Fiyat ve Cuzdan eþleþmesi yapýlýr
---Cuzdanda para var mý kontrolu yapýlýr yoksa RAISERROR('',16,1); yazdýrýlýr
--Cuzdanda para varsa iþlem basarili denir tabloya eklenir ve cuzdaný guncelleme kýsmý triggerda yapýlýr

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
			RAISERROR('Yetersiz bakiye. Satýþ tamamlanamadý.',16,1);			
		END
    ELSE BEGIN
	DECLARE @SeriNumarasi VARCHAR(25) = CONVERT(VARCHAR(MAX), NEWID());
		INSERT INTO tblKullaniciUrunSatinAlma VALUES(@SeriNumarasi, GETDATE(), @UrununFiyati, @KullaniciID,@UrunID);
		PRINT 'Satýþ iþlemi gerçekleþtirildi';
		END
		END TRY
	BEGIN CATCH
		PRINT 'Hata Oluþtu: ' + ERROR_MESSAGE();
	END CATCH
	
	COMMIT TRANSACTION
	END
	
    EXEC dbo.sp_OyunSatisi 1,1 --daha önce alýnan bir oyun
	EXEC dbo.sp_OyunSatisi 5,1 -- daha önce alýnmamýþ bir oyun
	EXEC dbo.sp_OyunSatisi 555,1