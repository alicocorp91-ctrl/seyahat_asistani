import '../models/pre_trip_preparation_model.dart';
import '../models/enums.dart';

const List<PreTripPreparation> defaultPreTripPreparations = [
  // Kişisel Bakım
  PreTripPreparation(id: 'haircut', name: 'Saç-sakal traşı', category: PreTripPreparationCategory.personalCare),
  PreTripPreparation(id: 'nail_cut', name: 'Tırnak kesmek', category: PreTripPreparationCategory.personalCare),
  PreTripPreparation(id: 'skin_care', name: 'Cilt bakımı / ağda', category: PreTripPreparationCategory.personalCare),

  // Finans
  PreTripPreparation(id: 'withdraw_money', name: 'Para çekmek', category: PreTripPreparationCategory.finance),
  PreTripPreparation(id: 'currency_exchange', name: 'Döviz dönüşümü (TL\'yi dolar veya euroya çevirme)', category: PreTripPreparationCategory.finance, isForInternational: true),

  // Elektronik
  PreTripPreparation(id: 'charge_phone', name: 'Telefon şarj etme', category: PreTripPreparationCategory.electronics),
  PreTripPreparation(id: 'charge_headphones', name: 'Bluetooth kulaklık şarj etme', category: PreTripPreparationCategory.electronics),
  PreTripPreparation(id: 'charge_powerbank', name: 'Powerbank şarj etme', category: PreTripPreparationCategory.electronics),

  // Alışveriş
  PreTripPreparation(id: 'grocery_shopping', name: 'Market alışverişi', category: PreTripPreparationCategory.shopping),

  // Seyahat Hazırlığı
  PreTripPreparation(id: 'download_offline_map', name: 'Offline harita indirme', category: PreTripPreparationCategory.travelPrep, isForInternational: true),
  PreTripPreparation(id: 'download_videos', name: 'Yolda izlemek için video indirme', category: PreTripPreparationCategory.travelPrep),
];