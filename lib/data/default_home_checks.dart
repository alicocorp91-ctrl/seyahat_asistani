import '../models/enums.dart';
import '../models/home_check_model.dart';

final List<HomeCheck> defaultHomeChecks = [
  // ELEKTRIK
  const HomeCheck(id: 'lights', name: 'Tüm ışıkları kapat', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'tv', name: 'TV fişini çek', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'ac', name: 'Klima ısıtıcı kapat', category: HomeCheckCategory.electric, isActive: false),
  const HomeCheck(id: 'plugs', name: 'Gereksiz prizleri çek', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'computer', name: 'Bilgisayar kapat', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'chargers', name: 'Şarj aletlerini çek', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'washingmachine', name: 'Çamaşır bulaşık makinesi kapalı mı', category: HomeCheckCategory.electric),
  const HomeCheck(id: 'iron', name: 'Ütü kapalı mi', category: HomeCheckCategory.electric),

  // SU VE GAZ
  const HomeCheck(id: 'mainwater', name: 'Ana su vanasını kapat', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'faucets', name: 'Muslukları kontrol et', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'gasvalve', name: 'Doğalgaz vanasını kapat', category: HomeCheckCategory.waterGas),
  const HomeCheck(id: 'gastube', name: 'Tüp varsa kontrol et', category: HomeCheckCategory.waterGas, isActive: false),
  const HomeCheck(id: 'toilet', name: 'Klozet sifonu kontrol', category: HomeCheckCategory.waterGas),

  // MUTFAK
  const HomeCheck(id: 'fridge', name: 'Buzdolabı kontrol bozulacaklar', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'trash', name: 'Çöpü at', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'recycle', name: 'Geri dönüşümü at', category: HomeCheckCategory.kitchen, isActive: false),
  const HomeCheck(id: 'dishwasher', name: 'Bulaşık makinesi boşalt', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'oven', name: 'Fırın ocak kapalı mı', category: HomeCheckCategory.kitchen),
  const HomeCheck(id: 'foodarrange', name: 'Yiyecekleri düzenle', category: HomeCheckCategory.kitchen, isActive: false),

  // GUVENLIK
  const HomeCheck(id: 'windows', name: 'Tüm pencereleri kapat', category: HomeCheckCategory.security),
  const HomeCheck(id: 'balcony', name: 'Balkon kapısını kilitle', category: HomeCheckCategory.security),
  const HomeCheck(id: 'door', name: 'Kapıyı kilitle', category: HomeCheckCategory.security),
  const HomeCheck(id: 'alarm', name: 'Alarm sistemi aktif et', category: HomeCheckCategory.security, isActive: false),
  const HomeCheck(id: 'camera', name: 'Kamera sistemi kontrol', category: HomeCheckCategory.security, isActive: false),
  const HomeCheck(id: 'sparekey', name: 'Yedek anahtarı birine ver', category: HomeCheckCategory.security, isActive: false),
  const HomeCheck(id: 'valuables', name: 'Değerli eşyaları sakla', category: HomeCheckCategory.security, isActive: false),
  const HomeCheck(id: 'mailbox', name: 'Posta kutusunu boşalt', category: HomeCheckCategory.security, isActive: false),

  // DIGER
  const HomeCheck(id: 'plants', name: 'Bitkileri sula', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'plantcare', name: 'Bitkiler için düzenleme yap', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'pets', name: 'Evcil hayvan düzenlemesi', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'mail', name: 'Posta kargo düzenlemesi', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'thermostat', name: 'Termostatı ayarla', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'blinds', name: 'Panjur perde kapat', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'timerlamp', name: 'Zamanlayıcı lamba kur', category: HomeCheckCategory.other, isActive: false),
  const HomeCheck(id: 'neighbor', name: 'Komşuyu bilgilendir', category: HomeCheckCategory.other, isActive: false),
];
