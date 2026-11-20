# Türkçe proje özeti

**Proje türü:** Açık biyolojik verilerin keşifsel hesaplamalı yeniden analizi ve
RNA-seq yeniden üretilebilirlik denetimi. Bu depo kapsamında yeni bir metformin
uygulama deneyi yapılmamıştır.

## İki ayrı hedef

1. GSE107894 MILES verisinde, teknik dizileme kayıtları ile bağımsız biyolojik
   örneklerin farklı analiz edilmesinin DEG sonuçlarına etkisini araştırmak.
2. Fibroblast, kas ve yağ dokusundan daha önce üretilmiş Hallmark GSEA
   tablolarını **keşifsel** olarak karşılaştırmak.

## Kaydedilmiş, kısmi MILES sonuçları

- Kas, biyolojik örnek modeli: **0 / 18.955** FDR<0,05 DEG.
- Yağ, biyolojik örnek modeli: **17 / 21.011** FDR<0,05 DEG.
- Kas, teknik kayıt modeli: **680 / 20.745** DEG (**yalnız tanısal, yalancı
  tekrar riski** nedeniyle biyolojik çıkarımda kullanılamaz).
- Yağ teknik kayıt modeli: **çıktısı yok**.

Yayımlanan makale 647 kas ve 146 yağ DEG bildirmiştir. Bu sayılar arasındaki
uyuşmazlığın nedeni henüz kesin olarak gösterilmemiştir.

## Kritik uyarılar

Bir genin azalan ekspresyonu veya yolaktaki negatif NES değeri, metforminin
zararlı olduğunu göstermez. Üç doku farklı deneylerden geldiğinden doğrudan
doku etkisi veya klinik yan etki iddiası yapılamaz. Eski analizler yalnızca
sonuç tabloları düzeyinde doğrulanmıştır; R/edgeR analizi bu GitHub hazırlığı
sırasında yeniden çalıştırılmamıştır.
