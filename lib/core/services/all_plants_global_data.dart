import 'package:organicplants/models/all_plants_model.dart';

List<AllPlantsModel> allPlantsGlobal = [];
// Plant category-based lists
List<AllPlantsModel> indoorPlants = [];
List<AllPlantsModel> outdoorPlants = [];
List<AllPlantsModel> medicinalPlants = [];
List<AllPlantsModel> herbsPlants = [];
List<AllPlantsModel> floweringPlants = [];
List<AllPlantsModel> bonsaiPlants = [];
List<AllPlantsModel> succulentsCactiPlants = [];

// Tag-based (attribute) lists
List<AllPlantsModel> petFriendlyPlants = [];
List<AllPlantsModel> lowMaintenancePlants = [];
List<AllPlantsModel> airPurifyingPlants = [];
List<AllPlantsModel> sunLovingPlants = [];

List<AllPlantsModel> getPlantsByCategory(String category) {
  return allPlantsGlobal
      .where((plant) => plant.category!.toLowerCase() == category.toLowerCase())
      .toList();
}

List<AllPlantsModel> getPlantsByTag(String tag) {
  return allPlantsGlobal
      .where(
        (plant) => plant.tags!.any((t) => t.toLowerCase() == tag.toLowerCase()),
      )
      .toList();
}

final List<Map<String, String>> onboardingData = [
  {
    'image':
        'https://res.cloudinary.com/daqvdhmw8/raw/upload/v1753080767/plant_wcdbra.json',
    'title': 'A plant for Every Space',
    'description':
        'Explore a wide selection of indoor and outdoor plants. Hand-picked for style, wellness, and every kind of space.',
  },
  {
    'image':
        'https://res.cloudinary.com/daqvdhmw8/raw/upload/v1753080769/plantCaring_uvelpl.json',
    'title': 'Easy Tips for Happy Plants',
    'description':
        'Get clear care tips and gentle reminders. So your plants stay happy and healthy, no matter your experience level.',
  },
  {
    'image':
        'https://res.cloudinary.com/daqvdhmw8/raw/upload/v1753080770/delivery_ckz91e.json',
    'title': 'Packed with Love, Delivered Safe',
    'description':
        'We use eco-friendly packaging and thoughtful handling to make sure your plant arrives safe, sound, and ready to grow.',
  },
  {
    'image':
        'https://res.cloudinary.com/daqvdhmw8/raw/upload/v1753080771/community_u0eb6i.json',
    'title': 'Grow Together with Plant Lovers',
    'description':
        'Share your journey, swap tips, and connect with a supportive community of fellow plant parents.',
  },
];

final List<Map<String, String>> banners = [
  {
    'imagePath':
        'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080639/air_purifier_banner_yklsf9.png',
    'title': 'Air Purifying Plants',
    'subtitle': 'Breathe cleaner air with natural filters',
    'filterTag': 'Air_Purifying',
  },
  {
    'imagePath':
        'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080642/low_maintenance_banner_mbj05x.png',
    'title': 'Low Maintenance Plants',
    'subtitle': 'Perfect for beginners and busy lives',
    'filterTag': 'Low_Maintenance',
  },
  {
    'imagePath':
        'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080638/pet_friendly_banner_ofwoml.png',
    'title': 'Pet-Friendly Plants',
    'subtitle': 'Safe greenery for your furry friends',
    'filterTag': 'Pet_Friendly',
  },
  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080642/sun_loving_banner_cwhzti.png",
    "title": "Sun Loving Plants",
    "subtitle": "Thrive in bright, sunny spaces",
    "filterTag": "Sun_Loving",
  },
];

final List<Map<String, String>> categories = [
  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080701/indoor_sgfwbt.png",
    "title": "Indoor Plants",
    "filterTag": "Indoor plant",
  },

  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080694/medicinal_qyioe3.png",
    "title": "Medicinal Plants",
    "filterTag": "Medicinal plants",
  },
  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080692/herbs_ozfrtz.png",
    "title": "Herbs Plants",
    "filterTag": "Herbs plant",
  },
  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080692/flowering_tkvayo.png",
    "title": "Flowering Plants",
    "filterTag": "Flowering plant",
  },

  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080696/bonsai_o4mnjk.png",
    "title": "Bonsai Plants",
    "filterTag": "Bonsai plant",
  },
  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080703/succulent_awhu4k.png",
    "title": "Succulents Plants",
    "filterTag": "Succulents & Cacti Plants",
  },
  {
    "imagePath":
        "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080694/outdoor_pyj2t5.png",
    'title': "Outdoor Plants",
    "filterTag": "Outdoor plant",
  },
];

class AllPlantsGlobalData {
  static List<AllPlantsModel> plantsList = [];
  static Map<String, AllPlantsModel> plantsMap = {};

  static void initialize(List<AllPlantsModel> plants) {
    plantsList.clear();
    plantsList.addAll(plants);
    plantsMap.clear();
    plantsMap.addEntries(
      plants.where((p) => p.id != null).map((p) => MapEntry(p.id!, p)),
    );
  }

  static AllPlantsModel? getById(String plantId) => plantsMap[plantId];

  static List<AllPlantsModel> get all => List.unmodifiable(plantsList);
}
