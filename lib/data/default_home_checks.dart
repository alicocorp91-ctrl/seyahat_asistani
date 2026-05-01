import '../models/enums.dart';
import '../models/home_check_model.dart';

const List<HomeCheck> defaultHomeChecks = [
  // ─── ELEKTRİK ────────────────────────────────────────────
  HomeCheck(
      id: 'lights',
      name: 'Tüm ışıkları kapat',
      category: HomeCheckCategory.electric),
  HomeCheck(
      id: 'tv', name: 'TV fişini çek', category: HomeCheckCategory.electric),
  HomeCheck(
      id: 'ac',
      name: 'Klima / ısıtıcı kapat',
      category: HomeCheckCategory.electric,
      isActive: false),
  HomeCheck(
      id: 'plugs',
      name: 'Gereksiz prizleri çek',
      category: HomeCheckCategory.electric),
  HomeCheck(
      id: 'computer',
      name: 'Bilgisayarı kapat',
      category: HomeCheckCategory.electric),
  HomeCheck(
      id: 'chargers',
      name: 'Şarj aletlerini çek',
      category: HomeCheckCategory.electric),
  HomeCheck(
      id: 'washingmachine',
      name: 'Çamaşır / bulaşık makinesi kapalı mı',
      category: HomeCheckCategory.electric),
  HomeCheck(
      id: 'iron', name: 'Ütü kapalı mı', category: HomeCheckCategory.electric),

  // ─── SU VE GAZ ───────────────────────────────────────────
  HomeCheck(
      id: 'mainwater',
      name: 'Ana su vanasını kapat',
      category: HomeCheckCategory.waterGas),
  HomeCheck(
      id: 'faucets',
      name: 'Muslukları kontrol et',
      category: HomeCheckCategory.waterGas),
  HomeCheck(
      id: 'gasvalve',
      name: 'Doğalgaz vanasını kapat',
      category: HomeCheckCategory.waterGas),
  HomeCheck(
      id: 'gastube',
      name: 'Tüp varsa kontrol et',
      category: HomeCheckCategory.waterGas,
      isActive: false),
  HomeCheck(
      id: 'toilet',
      name: 'Klozet sifonu kontrol',
      category: HomeCheckCategory.waterGas),

  // ─── MUTFAK ──────────────────────────────────────────────
  HomeCheck(
      id: 'fridge',
      name: 'Buzdolabı kontrol (bozulacaklar)',
      category: HomeCheckCategory.kitchen),
  HomeCheck(id: 'trash', name: 'Çöpü at', category: HomeCheckCategory.kitchen),
  HomeCheck(
      id: 'recycle',
      name: 'Geri dönüşümü at',
      category: HomeCheckCategory.kitchen,
      isActive: false),
  HomeCheck(
      id: 'dishwasher',
      name: 'Bulaşık makinesini boşalt',
      category: HomeCheckCategory.kitchen),
  HomeCheck(
      id: 'oven',
      name: 'Fırın / ocak kapalı mı',
      category: HomeCheckCategory.kitchen),
  HomeCheck(
      id: 'foodarrange',
      name: 'Yiyecekleri düzenle',
      category: HomeCheckCategory.kitchen,
      isActive: false),

  // ─── GÜVENLİK ────────────────────────────────────────────
  HomeCheck(
      id: 'windows',
      name: 'Tüm pencereleri kapat',
      category: HomeCheckCategory.security),
  HomeCheck(
      id: 'balcony',
      name: 'Balkon kapısını kilitle',
      category: HomeCheckCategory.security),
  HomeCheck(
      id: 'door', name: 'Kapıyı kilitle', category: HomeCheckCategory.security),
  HomeCheck(
      id: 'alarm',
      name: 'Alarm sistemini aktif et',
      category: HomeCheckCategory.security,
      isActive: false),
  HomeCheck(
      id: 'camera',
      name: 'Kamera sistemini kontrol et',
      category: HomeCheckCategory.security,
      isActive: false),
  HomeCheck(
      id: 'sparekey',
      name: 'Yedek anahtarı birine ver',
      category: HomeCheckCategory.security,
      isActive: false),
  HomeCheck(
      id: 'valuables',
      name: 'Değerli eşyaları sakla',
      category: HomeCheckCategory.security,
      isActive: false),
  HomeCheck(
      id: 'mailbox',
      name: 'Posta kutusunu boşalt',
      category: HomeCheckCategory.security,
      isActive: false),

  // ─── DİĞER ───────────────────────────────────────────────
  HomeCheck(
      id: 'plants',
      name: 'Bitkileri sula',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'plantcare',
      name: 'Bitkiler için düzenleme yap',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'pets',
      name: 'Evcil hayvan düzenlemesi',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'mail',
      name: 'Posta / kargo düzenlemesi',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'thermostat',
      name: 'Termostatı ayarla',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'blinds',
      name: 'Panjur / perde kapat',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'timerlamp',
      name: 'Zamanlayıcı lamba kur',
      category: HomeCheckCategory.other,
      isActive: false),
  HomeCheck(
      id: 'neighbor',
      name: 'Komşuyu bilgilendir',
      category: HomeCheckCategory.other,
      isActive: false),
];
