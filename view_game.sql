USE gamedb
GO

--item ad� olmicak
--11 oyun g�z�kecek t�rkiyedeki fiyatlar�n� ve �zelliklerini, 
--��k�� tarihini(char olarak),�r�n�n yeni �r�n olup olmad���n� g�sterecek
--%ba�ar�m�n�, en pahal� item ,en ucuz item ,ort item .
CREATE OR ALTER VIEW dbo.vOyun AS
	SELECT
		ul.Ad AS UlkeAdi,
		U.Ad AS UrununAdi,
		u.YasSiniri AS OyununYasSiniri,
		GF.Ad AS GelistirenFirman�nAdi,
		YF.Ad AS YayimlayanFirma,
		dbo.fncBasarimYuzdesi(u.ID) AS basarim_orani,
		Itemfiyatlari.EnPahalItem,
    	Itemfiyatlari.enUcuzItem,
		Itemfiyatlari.OrtalamaFiyat,
		CONVERT(CHAR(10), CikisTarihi, 104) AS CikisTarihi, --oyunun ��k�� tarihini char olarak de�i�tirir ve tabloya ekler.
		 CASE  
            WHEN DATEDIFF(MONTH, u.cikisTarihi, GETDATE()) <= 1 THEN 'Yeni Oyun!!!'   --oyun ��kal� maximum 1 ay olmu�sa yeni oyun belirtilir
			WHEN u.TurID=2 THEN 'Yaz�l�mlarda Son Nokta!!'     --oyun de�ilse yaz�l�m i�in slogan verir
            ELSE 'Efsane Oyunlar'  --eski/yeni olmayan bir oyunsa efsane oyun olarak ili�kilendirir
        END AS OyunDurumu

	FROM tblUrun u
		INNER JOIN tblFirma GF ON u.GelistirenFirmaID = GF.ID 
		INNER JOIN tblFirma YF ON u.YayimlayanFirmaID = YF.ID
		INNER JOIN tblTur t ON u.TurID = t.ID
		INNER JOIN tblUlkedeUrunBulunma ubul ON u.ID = ubul.UrunID
		INNER JOIN tblUlke ul ON ubul.UlkeID = ul.ID
		INNER JOIN (SELECT	u.ID, 
							MIN(kisa.Fiyat) AS enUcuzItem,  --oyuna ili�kili itemlerin en pahal�s�n�,ucuzunu ve ortalamas�n� getitir
							MAX(kisa.Fiyat) AS EnPahalItem,
						    AVG(kisa.Fiyat) AS OrtalamaFiyat
							FROM tblUrun u
							LEFT JOIN tblItem i ON u.ID = i.UrunID                       --iteme sahip olmayan �r�nler de ��ks�n diye left jo�n ile ba�land�
							LEFT JOIN tblKullaniciItemSatinAlma kisa ON i.ID = kisa.ItemID	
							GROUP BY u.ID
		           )Itemfiyatlari ON Itemfiyatlari.ID= U.ID
GO
SELECT * FROM vOyun 
WHERE UlkeAdi='T�RK�YE';
GO