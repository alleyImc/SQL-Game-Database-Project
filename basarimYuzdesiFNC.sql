USE gamedb
GO

-- bu oyuna sahip kullan�c�lar taraf�ndan ba�ar�mlar�n a��lma oran�n� verir
CREATE OR ALTER FUNCTION dbo.fncBasarimYuzdesi(@oyunID INT)
RETURNS FLOAT
AS
	BEGIN
        DECLARE @BasarimYuzdesi FLOAT
		
		select @BasarimYuzdesi = avg(convert(float,acilan_basarim_saiyisi)) 
		FROM
		( --belirli oyuna sahip olan kullan�c�lar�n ba�ar�m say�s�
			SELECT kba.KullaniciID, COUNT(kba.ID) as acilan_basarim_saiyisi
			FROM tblKullaniciBasarimAcma kba
			INNER JOIN tblBasarim B ON kba.BasarimID = B.ID
			INNER JOIN tblUrun U ON U.ID = B.UrunID
		    WHERE U.ID = @oyunID --WHERE U.ID = 1
			GROUP BY kba.KullaniciID --kullan�c�lar�n toplam ba�ar� say�lar�na g�re gruplar
		) basarimyuzdesi

    RETURN @BasarimYuzdesi
	END
GO


SELECT dbo.fncBasarimYuzdesi('2') AS BASARIM_YUZDESI
GO

