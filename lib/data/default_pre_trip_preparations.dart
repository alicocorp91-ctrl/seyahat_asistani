import '../models/pre_trip_preparation_model.dart';
import '../models/enums.dart';

// ✅ const - compile-time sabit
const List<PreTripPreparation> defaultPreTripPreparations = [
  // ─── KİŞİSEL BAKIM ───────────────────────────────────────
  PreTripPreparation(
    id: 'haircut',
    name: 'Saç / sakal tıraşı',
    category: PreTripPreparationCategory.personalCare,
  ),
  PreTripPreparation(
    id: 'nail_cut',
    name: 'Tırnak kesmek',
    category: PreTripPreparationCategory.personalCare,
  ),
  PreTripPreparation(
    id: 'skin_care',
    name: 'Cilt bakımı / ağda',
    category: PreTripPreparationCategory.personalCare,
  ),

  // ─── FİNANS ──────────────────────────────────────────────
  PreTripPreparation(
    id: 'withdraw_money',
    name: 'Para çekmek',
    category: PreTripPreparationCategory.finance,
  ),
  PreTripPreparation(
    id: 'currency_exchange',
    name: 'Döviz dönüşümü (TL → dolar / euro)',
    category: PreTripPreparationCategory.finance,
    isForInternational: true,
  ),

  // ─── ELEKTRONİK ──────────────────────────────────────────
  PreTripPreparation(
    id: 'charge_phone',
    name: 'Telefonu şarj etmek',
    category: PreTripPreparationCategory.electronics,
  ),
  PreTripPreparation(
    id: 'charge_headphones',
    name: 'Bluetooth kulaklığı şarj etmek',
    category: PreTripPreparationCategory.electronics,
  ),
  PreTripPreparation(
    id: 'charge_powerbank',
    name: 'Powerbank\'ı şarj etmek',
    category: PreTripPreparationCategory.electronics,
  ),

  // ─── ALIŞVERİŞ ───────────────────────────────────────────
  PreTripPreparation(
    id: 'grocery_shopping',
    name: 'Market alışverişi',
    category: PreTripPreparationCategory.shopping,
  ),

  // ─── SEYAHAT HAZIRLIĞI ────────────────────────────────────
  PreTripPreparation(
    id: 'download_offline_map',
    name: 'Offline harita indirmek',
    category: PreTripPreparationCategory.travelPrep,
    isForInternational: true,
  ),
  PreTripPreparation(
    id: 'download_videos',
    name: 'Yolda izlemek için video indirmek',
    category: PreTripPreparationCategory.travelPrep,
  ),
];
