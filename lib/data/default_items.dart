import '../models/enums.dart';
import '../models/item_model.dart';

// ✅ const - compile-time sabit
const List<PackingItem> defaultPackingItems = [
  // ─── TEMEL GİYİM ─────────────────────────────────────────
  PackingItem(
      id: 'underwear',
      name: 'İç çamaşırı',
      category: ItemCategory.clothingBasic),
  PackingItem(id: 'socks', name: 'Çorap', category: ItemCategory.clothingBasic),
  PackingItem(
      id: 'pajamas',
      name: 'Pijama takımı',
      category: ItemCategory.clothingBasic),
  PackingItem(
      id: 'slippers', name: 'Terlik', category: ItemCategory.clothingBasic),
  PackingItem(
      id: 'daily_shoes',
      name: 'Günlük ayakkabı',
      category: ItemCategory.clothingBasic),
  PackingItem(
      id: 'sport_shoes',
      name: 'Spor ayakkabı',
      category: ItemCategory.clothingBasic),

  // ─── ERKEK GİYİM ─────────────────────────────────────────
  PackingItem(
      id: 'tshirt_m',
      name: 'Tişört',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'pants_m',
      name: 'Pantolon',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'jeans_m',
      name: 'Kot pantolon',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'shorts_m',
      name: 'Şort',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'shirt_m',
      name: 'Gömlek',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'boxer',
      name: 'Boxer',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'undershirt',
      name: 'Atlet',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'belt',
      name: 'Kemer',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'suit',
      name: 'Takım elbise',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'tie',
      name: 'Kravat',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'jacket_m',
      name: 'Ceket',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'tracksuit_m',
      name: 'Eşofman',
      category: ItemCategory.clothingMale,
      genderVisibility: GenderVisibility.maleAndCouple),

  // ─── KADIN GİYİM ─────────────────────────────────────────
  PackingItem(
      id: 'blouse',
      name: 'Bluz',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'skirt',
      name: 'Etek',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'dress',
      name: 'Elbise',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'leggings',
      name: 'Tayt',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'bra',
      name: 'Sütyen',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'panties',
      name: 'Külot',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'shawl',
      name: 'Şal / eşarp',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'cardigan',
      name: 'Hırka',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'jeans_f',
      name: 'Kot pantolon',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'tracksuit_f',
      name: 'Eşofman',
      category: ItemCategory.clothingFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),

  // ─── KIŞ GİYİM ───────────────────────────────────────────
  PackingItem(
      id: 'coat',
      name: 'Mont / kaban',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter, Season.autumn]),
  PackingItem(
      id: 'sweater',
      name: 'Kazak',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter, Season.autumn]),
  PackingItem(
      id: 'polar',
      name: 'Polar',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'scarf',
      name: 'Atkı',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'beanie',
      name: 'Bere',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'gloves',
      name: 'Eldiven',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'boots',
      name: 'Bot',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter, Season.autumn]),
  PackingItem(
      id: 'thermal_top',
      name: 'Termal içlik üst',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'thermal_bottom',
      name: 'Termal içlik alt',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'wool_socks',
      name: 'Yün çorap',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),
  PackingItem(
      id: 'snow_boots',
      name: 'Kar botu',
      category: ItemCategory.clothingWinter,
      seasons: [Season.winter]),

  // ─── YAZ GİYİM ───────────────────────────────────────────
  PackingItem(
      id: 'sunhat',
      name: 'Güneş şapkası',
      category: ItemCategory.clothingSummer,
      seasons: [Season.summer]),
  PackingItem(
      id: 'swimsuit_m',
      name: 'Mayo (erkek)',
      category: ItemCategory.clothingSummer,
      genderVisibility: GenderVisibility.maleAndCouple,
      seasons: [Season.summer]),
  PackingItem(
      id: 'bikini',
      name: 'Bikini / mayo',
      category: ItemCategory.clothingSummer,
      genderVisibility: GenderVisibility.femaleAndCouple,
      seasons: [Season.summer]),
  PackingItem(
      id: 'beach_dress',
      name: 'Plaj elbisesi',
      category: ItemCategory.clothingSummer,
      genderVisibility: GenderVisibility.femaleAndCouple,
      seasons: [Season.summer]),
  PackingItem(
      id: 'shorts_summer',
      name: 'Şort',
      category: ItemCategory.clothingSummer,
      seasons: [Season.summer]),
  PackingItem(
      id: 'sandals',
      name: 'Sandalet',
      category: ItemCategory.clothingSummer,
      seasons: [Season.summer]),
  PackingItem(
      id: 'water_shoes',
      name: 'Deniz ayakkabısı',
      category: ItemCategory.clothingSummer,
      seasons: [Season.summer]),

  // ─── KİŞİSEL BAKIM ───────────────────────────────────────
  PackingItem(
      id: 'toothbrush',
      name: 'Diş fırçası',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'toothpaste',
      name: 'Diş macunu',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'dental_floss', name: 'Diş ipi', category: ItemCategory.personalCare),
  PackingItem(
      id: 'mouthwash',
      name: 'Ağız gargarası',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'shampoo', name: 'Şampuan', category: ItemCategory.personalCare),
  PackingItem(
      id: 'conditioner',
      name: 'Saç kremi',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'showergel', name: 'Duş jeli', category: ItemCategory.personalCare),
  PackingItem(id: 'soap', name: 'Sabun', category: ItemCategory.personalCare),
  PackingItem(
      id: 'deodorant', name: 'Deodorant', category: ItemCategory.personalCare),
  PackingItem(
      id: 'perfume', name: 'Parfüm', category: ItemCategory.personalCare),
  PackingItem(
      id: 'comb', name: 'Tarak / fırça', category: ItemCategory.personalCare),
  PackingItem(
      id: 'nailclipper',
      name: 'Tırnak makası',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'nailfile',
      name: 'Tırnak törpüsü',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'cottonswab',
      name: 'Kulak çubuğu',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'moisturizer',
      name: 'Nemlendirici',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'lipbalm',
      name: 'Dudak nemlendiricisi',
      category: ItemCategory.personalCare),
  PackingItem(
      id: 'handcream', name: 'El kremi', category: ItemCategory.personalCare),
  PackingItem(
      id: 'tweezers', name: 'Cımbız', category: ItemCategory.personalCare),
  PackingItem(
      id: 'mirror', name: 'Küçük ayna', category: ItemCategory.personalCare),
  PackingItem(id: 'towel', name: 'Havlu', category: ItemCategory.personalCare),
  PackingItem(
      id: 'shower_cap', name: 'Bone', category: ItemCategory.personalCare),

  // ─── ERKEK BAKIM ─────────────────────────────────────────
  PackingItem(
      id: 'razor',
      name: 'Tıraş makinesi / jilet',
      category: ItemCategory.personalCareMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'shavingfoam',
      name: 'Tıraş köpüğü / jeli',
      category: ItemCategory.personalCareMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'aftershave',
      name: 'After shave',
      category: ItemCategory.personalCareMale,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'nosehair',
      name: 'Burun kıl makası',
      category: ItemCategory.personalCareMale,
      genderVisibility: GenderVisibility.maleAndCouple),

  // ─── KADIN BAKIM ─────────────────────────────────────────
  PackingItem(
      id: 'makeupbag',
      name: 'Makyaj çantası',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'foundation',
      name: 'Fondöten',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'powder',
      name: 'Pudra',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'blush',
      name: 'Allık',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'eyeshadow',
      name: 'Far paleti',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'eyeliner',
      name: 'Eyeliner',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'mascara',
      name: 'Maskara',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'browpencil',
      name: 'Kaş kalemi',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'lipstick',
      name: 'Ruj',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'lipliner',
      name: 'Dudak kalemi',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'highlighter',
      name: 'Aydınlatıcı',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'contour',
      name: 'Kontur kiti',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'makeupsponge',
      name: 'Makyaj süngeri',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'brushset',
      name: 'Fırça seti',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'makeupremover',
      name: 'Makyaj temizleyici',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'micellar',
      name: 'Misel su',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'pads',
      name: 'Ped / tampon',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'dailypads',
      name: 'Günlük ped',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'waxstrips',
      name: 'Ağda bandı / tüy dökücü',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'hairstraightener',
      name: 'Saç düzleştirici',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'curlingiron',
      name: 'Saç maşası',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'hairdryer',
      name: 'Saç kurutma makinesi',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'hairties',
      name: 'Saç tokası / lastik',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'headband',
      name: 'Saç bandı',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'nailpolish',
      name: 'Oje',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'acetone',
      name: 'Aseton',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'hairspray',
      name: 'Saç spreyi',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),
  PackingItem(
      id: 'hairmousse',
      name: 'Saç köpüğü',
      category: ItemCategory.personalCareFemale,
      genderVisibility: GenderVisibility.femaleAndCouple),

  // ─── SAĞLIK VE İLAÇ ──────────────────────────────────────
  PackingItem(
      id: 'painkiller', name: 'Ağrı kesici', category: ItemCategory.health),
  PackingItem(
      id: 'antipyretic', name: 'Ateş düşürücü', category: ItemCategory.health),
  PackingItem(id: 'bandaid', name: 'Yara bandı', category: ItemCategory.health),
  PackingItem(
      id: 'antiseptic',
      name: 'Antiseptik / tentürdiyot',
      category: ItemCategory.health),
  PackingItem(
      id: 'woundcream', name: 'Yara merhemi', category: ItemCategory.health),
  PackingItem(id: 'bandage', name: 'Sargı bezi', category: ItemCategory.health),
  PackingItem(
      id: 'stomachmeds', name: 'Mide ilacı', category: ItemCategory.health),
  PackingItem(
      id: 'diarrhea', name: 'İshal ilacı', category: ItemCategory.health),
  PackingItem(
      id: 'laxative', name: 'Kabızlık ilacı', category: ItemCategory.health),
  PackingItem(
      id: 'allergymeds', name: 'Alerji ilacı', category: ItemCategory.health),
  PackingItem(
      id: 'coldmeds',
      name: 'Soğuk algınlığı ilacı',
      category: ItemCategory.health),
  PackingItem(
      id: 'coughsyrup', name: 'Öksürük şurubu', category: ItemCategory.health),
  PackingItem(
      id: 'nasalspray', name: 'Burun spreyi', category: ItemCategory.health),
  PackingItem(
      id: 'throatlozenges',
      name: 'Boğaz pastili',
      category: ItemCategory.health),
  PackingItem(
      id: 'prescriptionmeds',
      name: 'Reçeteli ilaçlar',
      category: ItemCategory.health),
  PackingItem(id: 'vitamins', name: 'Vitamin', category: ItemCategory.health),
  PackingItem(
      id: 'sunscreen', name: 'Güneş kremi', category: ItemCategory.health),
  PackingItem(
      id: 'bugspray', name: 'Böcek kovucu', category: ItemCategory.health),
  PackingItem(
      id: 'bitecream',
      name: 'Böcek ısırığı kremi',
      category: ItemCategory.health),
  PackingItem(
      id: 'motionsickness',
      name: 'Seyahat tutması ilacı',
      category: ItemCategory.health),
  PackingItem(
      id: 'eyedrops', name: 'Göz damlası', category: ItemCategory.health),
  PackingItem(
      id: 'lenssolution',
      name: 'Lens solüsyonu',
      category: ItemCategory.health),
  PackingItem(
      id: 'spareglasses',
      name: 'Yedek gözlük / lens',
      category: ItemCategory.health),
  PackingItem(
      id: 'handsanitizer',
      name: 'El dezenfektanı',
      category: ItemCategory.health),
  PackingItem(id: 'facemask', name: 'Maske', category: ItemCategory.health),
  PackingItem(
      id: 'thermometer', name: 'Termometre', category: ItemCategory.health),

  // ─── ELEKTRONİK ──────────────────────────────────────────
  PackingItem(id: 'phone', name: 'Telefon', category: ItemCategory.electronics),
  PackingItem(
      id: 'phonecharger',
      name: 'Telefon şarj aleti',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'powerbank', name: 'Powerbank', category: ItemCategory.electronics),
  PackingItem(
      id: 'headphones', name: 'Kulaklık', category: ItemCategory.electronics),
  PackingItem(id: 'tablet', name: 'Tablet', category: ItemCategory.electronics),
  PackingItem(
      id: 'tabletcharger',
      name: 'Tablet şarj aleti',
      category: ItemCategory.electronics),
  PackingItem(id: 'laptop', name: 'Laptop', category: ItemCategory.electronics),
  PackingItem(
      id: 'laptopcharger',
      name: 'Laptop şarj aleti',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'camera',
      name: 'Fotoğraf makinesi',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'camerabattery',
      name: 'Kamera pili / şarjı',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'memorycard',
      name: 'Hafıza kartı',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'usbdrive', name: 'USB bellek', category: ItemCategory.electronics),
  PackingItem(
      id: 'usbcable', name: 'USB kablo', category: ItemCategory.electronics),
  PackingItem(
      id: 'adapter',
      name: 'Priz adaptörü / çevirici',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'ereader',
      name: 'E-kitap okuyucu',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'smartwatchcharger',
      name: 'Akıllı saat şarjı',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'speaker',
      name: 'Taşınabilir hoparlör',
      category: ItemCategory.electronics),
  PackingItem(
      id: 'selfiestick',
      name: 'Selfie çubuğu',
      category: ItemCategory.electronics),
  PackingItem(id: 'tripod', name: 'Tripod', category: ItemCategory.electronics),

  // ─── EVRAK VE BELGE ──────────────────────────────────────
  PackingItem(
      id: 'idcard', name: 'Kimlik kartı', category: ItemCategory.documents),
  PackingItem(
      id: 'driverlicense', name: 'Ehliyet', category: ItemCategory.documents),
  PackingItem(
      id: 'tickets', name: 'Biletler', category: ItemCategory.documents),
  PackingItem(
      id: 'hotelreservation',
      name: 'Otel rezervasyonu',
      category: ItemCategory.documents),
  PackingItem(
      id: 'carrental',
      name: 'Araç kiralama belgesi',
      category: ItemCategory.documents),
  PackingItem(
      id: 'insurance',
      name: 'Sigorta poliçesi',
      category: ItemCategory.documents),
  PackingItem(
      id: 'creditcard', name: 'Kredi kartı', category: ItemCategory.documents),
  PackingItem(
      id: 'debitcard', name: 'Banka kartı', category: ItemCategory.documents),
  PackingItem(
      id: 'cash_tl', name: 'Nakit para (TL)', category: ItemCategory.documents),

  // ─── YURT DIŞI BELGELERİ ─────────────────────────────────
  PackingItem(
      id: 'passport',
      name: 'Pasaport',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'visa',
      name: 'Vize belgeleri',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'intldriverlicense',
      name: 'Uluslararası ehliyet',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'travelinsurance',
      name: 'Seyahat sigortası',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'foreigncurrency',
      name: 'Döviz',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'intlcreditcard',
      name: 'Yurt dışı onaylı kredi kartı',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'plugadapter',
      name: 'Priz adaptörü',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'roaminginfo',
      name: 'Roaming paketi bilgisi',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'embassycontact',
      name: 'Büyükelçilik iletişim',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'vaccinecard',
      name: 'Aşı kartı / sertifikası',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),
  PackingItem(
      id: 'photoid',
      name: 'Vesikalık fotoğraf',
      category: ItemCategory.documentsIntl,
      internationalOnly: true),

  // ─── ÖZEL ────────────────────────────────────────────────
  PackingItem(
      id: 'condom',
      name: 'Prezervatif',
      category: ItemCategory.intimate,
      genderVisibility: GenderVisibility.maleAndCouple),
  PackingItem(
      id: 'lubricant',
      name: 'Kayganlaştırıcı',
      category: ItemCategory.intimate,
      genderVisibility: GenderVisibility.coupleOnly),
  PackingItem(
      id: 'birthcontrol',
      name: 'Doğum kontrol hapı',
      category: ItemCategory.intimate,
      genderVisibility: GenderVisibility.femaleAndCouple),

  // ─── YOLCULUK AKSESUAR ───────────────────────────────────
  PackingItem(
      id: 'neckpillow',
      name: 'Boyun yastığı',
      category: ItemCategory.transport),
  PackingItem(
      id: 'sleepmask', name: 'Uyku maskesi', category: ItemCategory.transport),
  PackingItem(
      id: 'earplugs', name: 'Kulak tıkacı', category: ItemCategory.transport),
  PackingItem(
      id: 'travelblanket',
      name: 'Seyahat battaniyesi',
      category: ItemCategory.transport),
  PackingItem(
      id: 'inflatablepillow',
      name: 'Şişirilebilir yastık',
      category: ItemCategory.transport),
  PackingItem(
      id: 'book', name: 'Kitap / dergi', category: ItemCategory.transport),
  PackingItem(
      id: 'puzzle', name: 'Bulmaca / sudoku', category: ItemCategory.transport),
  PackingItem(
      id: 'playingcards',
      name: 'Oyun kartları',
      category: ItemCategory.transport),
  PackingItem(
      id: 'phoneholder',
      name: 'Tablet / telefon tutucu',
      category: ItemCategory.transport),
  PackingItem(
      id: 'carcharger',
      name: 'Araç şarj cihazı',
      category: ItemCategory.transport,
      transports: [Transport.car]),
  PackingItem(
      id: 'carphoneholder',
      name: 'Araç telefon tutacağı',
      category: ItemCategory.transport,
      transports: [Transport.car]),
  PackingItem(
      id: 'navigation',
      name: 'Navigasyon',
      category: ItemCategory.transport,
      transports: [Transport.car]),
  PackingItem(
      id: 'snacks', name: 'Atıştırmalık', category: ItemCategory.transport),
  PackingItem(
      id: 'waterbottle', name: 'Su şişesi', category: ItemCategory.transport),
  PackingItem(id: 'thermos', name: 'Termos', category: ItemCategory.transport),
  PackingItem(
      id: 'baglock', name: 'Çanta kilidi', category: ItemCategory.transport),
  PackingItem(
      id: 'luggagetag',
      name: 'Valiz etiketi',
      category: ItemCategory.transport),

  // ─── PRATİK EŞYALAR ──────────────────────────────────────
  PackingItem(
      id: 'sewingkit',
      name: 'İğne / iplik seti',
      category: ItemCategory.practical),
  PackingItem(
      id: 'safetypin', name: 'Çengelli iğne', category: ItemCategory.practical),
  PackingItem(
      id: 'scissors', name: 'Küçük makas', category: ItemCategory.practical),
  PackingItem(id: 'tape', name: 'Bant', category: ItemCategory.practical),
  PackingItem(
      id: 'plasticbag',
      name: 'Plastik poşet',
      category: ItemCategory.practical),
  PackingItem(
      id: 'zipbag', name: 'Kilitli poşet', category: ItemCategory.practical),
  PackingItem(
      id: 'clothespin',
      name: 'Çamaşır mandası',
      category: ItemCategory.practical),
  PackingItem(
      id: 'clothesline', name: 'Çamaşır ipi', category: ItemCategory.practical),
  PackingItem(
      id: 'stainremover',
      name: 'Leke çıkarıcı',
      category: ItemCategory.practical),
  PackingItem(
      id: 'shoecare',
      name: 'Ayakkabı bakımı / boyası',
      category: ItemCategory.practical),
  PackingItem(
      id: 'umbrella', name: 'Şemsiye', category: ItemCategory.practical),
  PackingItem(
      id: 'raincoat', name: 'Yağmurluk', category: ItemCategory.practical),
  PackingItem(
      id: 'sunglasses',
      name: 'Güneş gözlüğü',
      category: ItemCategory.practical),
  PackingItem(
      id: 'glassescase',
      name: 'Gözlük kılıfı',
      category: ItemCategory.practical),
  PackingItem(
      id: 'flashlight', name: 'El feneri', category: ItemCategory.practical),
  PackingItem(
      id: 'multitool',
      name: 'Çakı / çok amaçlı alet',
      category: ItemCategory.practical),
  PackingItem(
      id: 'lighter', name: 'Çakmak / kibrit', category: ItemCategory.practical),
  PackingItem(id: 'pen', name: 'Kalem', category: ItemCategory.practical),
  PackingItem(
      id: 'notebook', name: 'Not defteri', category: ItemCategory.practical),
  PackingItem(id: 'map', name: 'Harita', category: ItemCategory.practical),
  PackingItem(
      id: 'guidebook', name: 'Rehber kitap', category: ItemCategory.practical),
  PackingItem(id: 'wallet', name: 'Cüzdan', category: ItemCategory.practical),
  PackingItem(
      id: 'beltbag', name: 'Bel çantası', category: ItemCategory.practical),
  PackingItem(
      id: 'daypack',
      name: 'Günlük sırt çantası',
      category: ItemCategory.practical),
  PackingItem(
      id: 'beachbag',
      name: 'Plaj çantası',
      category: ItemCategory.practical,
      seasons: [Season.summer]),
  PackingItem(
      id: 'laundrybag',
      name: 'Kirli çamaşır torbası',
      category: ItemCategory.practical),
  PackingItem(
      id: 'shoebag',
      name: 'Ayakkabı torbası',
      category: ItemCategory.practical),
  PackingItem(
      id: 'toiletrybag',
      name: 'Tuvalet çantası',
      category: ItemCategory.practical),
  PackingItem(
      id: 'whistle',
      name: 'Düdük (acil durum)',
      category: ItemCategory.practical),
];
