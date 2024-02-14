USE gamedb
GO

-- bu oyuna sahip kullanýcýlar tarafýndan baþarýmlarýn açýlma oranýný verir
CREATE OR ALTER FUNCTION dbo.fncBasarimYuzdesi(@oyunID INT)
RETURNS FLOAT
AS
	BEGIN
        DECLARE @BasarimYuzdesi FLOAT
		
		select @BasarimYuzdesi = avg(convert(float,acilan_basarim_saiyisi)) 
		FROM
		( --belirli oyuna sahip olan kullanýcýlarýn baþarým sayýsý
			SELECT kba.KullaniciID, COUNT(kba.ID) as acilan_basarim_saiyisi
			FROM tblKullaniciBasarimAcma kba
			INNER JOIN tblBasarim B ON kba.BasarimID = B.ID
			INNER JOIN tblUrun U ON U.ID = B.UrunID
		    WHERE U.ID = @oyunID --WHERE U.ID = 1
			GROUP BY kba.KullaniciID --kullanýcýlarýn toplam baþarý sayýlarýna göre gruplar
		) basarimyuzdesi

    RETURN @BasarimYuzdesi
	END
GO


SELECT dbo.fncBasarimYuzdesi('2') AS BASARIM_YUZDESI
GO

