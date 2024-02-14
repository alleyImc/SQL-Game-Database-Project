USE gamedb
GO

CREATE OR ALTER FUNCTION fncCurrencyExchange(@UrunId INT , @UlkeAdi VARCHAR(50))
RETURNS MONEY
AS
BEGIN
    DECLARE @FiyatTL MONEY

    SELECT @FiyatTL = UB.Fiyat * UL.GuncelKur
    FROM tblUrun AS U
    INNER JOIN tblUlkedeUrunBulunma AS UB ON UB.UrunID = U.ID
    INNER JOIN tblUlke AS UL ON UL.ID = UB.UlkeID
    WHERE U.ID = @UrunId AND UL.Ad = @UlkeAdi

    RETURN @FiyatTL
END
GO

SELECT dbo.fncCurrencyExchange(1, 'TÜRKÝYE') AS 'kur Sonucu Fiyat';