USE gamedb
GO

--item adý olmicak
--11 oyun gözükecek türkiyedeki fiyatlarýný ve özelliklerini, 
--çýkýþ tarihini(char olarak),ürünün yeni ürün olup olmadýðýný gösterecek
--%baþarýmýný, en pahalý item ,en ucuz item ,ort item .
CREATE OR ALTER VIEW dbo.vOyun AS
	SELECT
		ul.Ad AS UlkeAdi,
		U.Ad AS UrununAdi,
		u.YasSiniri AS OyununYasSiniri,
		GF.Ad AS GelistirenFirmanýnAdi,
		YF.Ad AS YayimlayanFirma,
		dbo.fncBasarimYuzdesi(u.ID) AS basarim_orani,
		Itemfiyatlari.EnPahalItem,
    	Itemfiyatlari.enUcuzItem,
		Itemfiyatlari.OrtalamaFiyat,
		CONVERT(CHAR(10), CikisTarihi, 104) AS CikisTarihi, --oyunun çýkýþ tarihini char olarak deðiþtirir ve tabloya ekler.
		 CASE  
            WHEN DATEDIFF(MONTH, u.cikisTarihi, GETDATE()) <= 1 THEN 'Yeni Oyun!!!'   --oyun çýkalý maximum 1 ay olmuþsa yeni oyun belirtilir
			WHEN u.TurID=2 THEN 'Yazýlýmlarda Son Nokta!!'     --oyun deðilse yazýlým için slogan verir
            ELSE 'Efsane Oyunlar'  --eski/yeni olmayan bir oyunsa efsane oyun olarak iliþkilendirir
        END AS OyunDurumu

	FROM tblUrun u
		INNER JOIN tblFirma GF ON u.GelistirenFirmaID = GF.ID 
		INNER JOIN tblFirma YF ON u.YayimlayanFirmaID = YF.ID
		INNER JOIN tblTur t ON u.TurID = t.ID
		INNER JOIN tblUlkedeUrunBulunma ubul ON u.ID = ubul.UrunID
		INNER JOIN tblUlke ul ON ubul.UlkeID = ul.ID
		INNER JOIN (SELECT	u.ID, 
							MIN(kisa.Fiyat) AS enUcuzItem,  --oyuna iliþkili itemlerin en pahalýsýný,ucuzunu ve ortalamasýný getitir
							MAX(kisa.Fiyat) AS EnPahalItem,
						    AVG(kisa.Fiyat) AS OrtalamaFiyat
							FROM tblUrun u
							LEFT JOIN tblItem i ON u.ID = i.UrunID                       --iteme sahip olmayan ürünler de çýksýn diye left joýn ile baðlandý
							LEFT JOIN tblKullaniciItemSatinAlma kisa ON i.ID = kisa.ItemID	
							GROUP BY u.ID
		           )Itemfiyatlari ON Itemfiyatlari.ID= U.ID
GO
SELECT * FROM vOyun 
WHERE UlkeAdi='TÜRKÝYE';
GO