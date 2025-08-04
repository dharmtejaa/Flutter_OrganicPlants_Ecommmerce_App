// ignore: dangling_library_doc_comments
/// id : "bonsai_ficus_001"
/// common_name : "Ficus"
/// scientific_name : "Ficus retusa"
/// category : "Bonsai Plant"
/// tags : ["indoor","pet_friendly","beginner_friendly","low_maintenance","bonsai"]
/// attributes : {"is_air_purifying":true,"is_low_maintenance":true,"is_foliage":true,"is_pet_friendly":true,"is_beginner_friendly":true,"is_flowering":false,"is_sun_loving":true,"is_shadow_loving":false,"is_edible":false}
/// images : [{"url":"https://imgs.search.brave.com/fk5nbSlAeQGLh3g3eIoAz8Gu_p_1Q4WQumWeDDT5CKI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hYmFu/YWhvbWVzLmNvbS9j/ZG4vc2hvcC9maWxl/cy9ncmFmdGVkLWZp/Y3VzLWJvbnNhaS1w/bGFudC1pbi1rYW1y/YWstcG90LXdpdGgt/ZmlndXJpbmUtZm9y/LWhvbWUtZGVjb3It/Mi5qcGc_dj0xNzM1/ODMxNzA0JndpZHRo/PTUzMw","alt_text":"Ficus Bonsai tree with dense green foliage","type":"main"},{"url":"https://imgs.search.brave.com/Q5_jfpFVN7GefkTxsVfbjsVnKnYiAmMS6EF0hGdZxBM/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/aWtlYS5jb20vdXMv/ZW4vaW1hZ2VzL3By/b2R1Y3RzL2ZpY3Vz/LXBsYW50LXdpdGgt/cG90LWJvbnNhaS1h/c3NvcnRlZC1jb2xv/cnNfXzA4MDQxMzdf/cGU3NjkwNzhfczUu/anBnP2Y9cw","alt_text":"Another view of Ficus Bonsai tree with dense green foliage","type":"side"}]
/// prices : {"original_price":1199,"offer_price":959}
/// rating : 4.5
/// in_stock : true
/// plant_quick_guide : {"height":"1-2 feet","width":"1-1.5 feet","sunlight":["Indirect Light"],"growth_rate":"Moderate"}
/// description : {"intro":"The Ficus Bonsai is one of the most popular indoor bonsai plants, known for its easy care and attractive appearance.","water":"Water thoroughly when the top inch of soil is dry.","pet_friendly":"Yes, Ficus is non-toxic to pets.","beginner_friendly":"Yes, Ficus Bonsai is beginner-friendly and easy to maintain."}
/// how_to_plant : "Plant in a well-draining bonsai soil mix and ensure it gets bright, indirect light."
/// care_guide : {"watering":{"frequency":"Once a week","description":"Water when the top inch of soil feels dry. Avoid over-watering."},"light":{"description":"Needs bright, indirect light for best growth.","type":"Indirect Light"},"fertilizer":{"description":"Feed once a month with a balanced liquid fertilizer.","type":"Balanced Fertilizer"},"temperature":{"range":"18-24°C","description":"Prefers warm temperatures and should not be exposed to drafts."},"humidity":{"level":"Moderate","description":"Moderate humidity is ideal, but it can tolerate drier conditions."}}
/// toxicity : "Non-toxic to pets."
/// season : "All year"
/// flowering : false
/// placement : "Indoor"
/// soil_type : "Bonsai soil mix"
/// lifecycle_stage : "Mature"
/// recommended_pot_size : "8-inch diameter"
/// benefits : ["Easy to care for","Great for beginners","Beautiful indoor decor"]
/// faqs : [{"question":"How often should I water my Ficus Bonsai?","answer":"Water when the top inch of soil is dry to the touch."},{"question":"Can Ficus Bonsai grow in low light?","answer":"Ficus prefers bright, indirect light, but it can tolerate lower light conditions."},{"question":"Are Ficus Bonsai pet-friendly?","answer":"Yes, Ficus Bonsai is safe for pets."},{"question":"Is Ficus Bonsai easy to care for?","answer":"Yes, Ficus Bonsai is considered one of the easiest bonsai plants to care for."}]

class AllPlantsModel {
  AllPlantsModel({
    String? id,
    String? commonName,
    String? scientificName,
    String? category,
    List<String>? tags,
    Attributes? attributes,
    List<Images>? images,
    Prices? prices,
    num? rating,
    bool? inStock,
    PlantQuickGuide? plantQuickGuide,
    Description? description,
    String? howToPlant,
    CareGuide? careGuide,
    String? toxicity,
    String? season,
    bool? flowering,
    String? placement,
    String? soilType,
    String? lifecycleStage,
    String? recommendedPotSize,
    List<String>? benefits,
    List<Faqs>? faqs,
  }) {
    _id = id;
    _commonName = commonName;
    _scientificName = scientificName;
    _category = category;
    _tags = tags;
    _attributes = attributes;
    _images = images;
    _prices = prices;
    _rating = rating;
    _inStock = inStock;
    _plantQuickGuide = plantQuickGuide;
    _description = description;
    _howToPlant = howToPlant;
    _careGuide = careGuide;
    _toxicity = toxicity;
    _season = season;
    _flowering = flowering;
    _placement = placement;
    _soilType = soilType;
    _lifecycleStage = lifecycleStage;
    _recommendedPotSize = recommendedPotSize;
    _benefits = benefits;
    _faqs = faqs;
  }

  AllPlantsModel.fromJson(dynamic json) {
    _id = json['id'];
    _commonName = json['common_name'];
    _scientificName = json['scientific_name'];
    _category = json['category'];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _attributes =
        json['attributes'] != null
            ? Attributes.fromJson(json['attributes'])
            : null;
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
    _prices = json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    _rating = json['rating'];
    _inStock = json['in_stock'];
    _plantQuickGuide =
        json['plant_quick_guide'] != null
            ? PlantQuickGuide.fromJson(json['plant_quick_guide'])
            : null;
    _description =
        json['description'] != null
            ? Description.fromJson(json['description'])
            : null;
    _howToPlant = json['how_to_plant'];
    _careGuide =
        json['care_guide'] != null
            ? CareGuide.fromJson(json['care_guide'])
            : null;
    _toxicity = json['toxicity'];
    _season = json['season'];
    _flowering = json['flowering'];
    _placement = json['placement'];
    _soilType = json['soil_type'];
    _lifecycleStage = json['lifecycle_stage'];
    _recommendedPotSize = json['recommended_pot_size'];
    _benefits = json['benefits'] != null ? json['benefits'].cast<String>() : [];
    if (json['faqs'] != null) {
      _faqs = [];
      json['faqs'].forEach((v) {
        _faqs?.add(Faqs.fromJson(v));
      });
    }
  }
  String? _id;
  String? _commonName;
  String? _scientificName;
  String? _category;
  List<String>? _tags;
  Attributes? _attributes;
  List<Images>? _images;
  Prices? _prices;
  num? _rating;
  bool? _inStock;
  PlantQuickGuide? _plantQuickGuide;
  Description? _description;
  String? _howToPlant;
  CareGuide? _careGuide;
  String? _toxicity;
  String? _season;
  bool? _flowering;
  String? _placement;
  String? _soilType;
  String? _lifecycleStage;
  String? _recommendedPotSize;
  List<String>? _benefits;
  List<Faqs>? _faqs;
  AllPlantsModel copyWith({
    String? id,
    String? commonName,
    String? scientificName,
    String? category,
    List<String>? tags,
    Attributes? attributes,
    List<Images>? images,
    Prices? prices,
    num? rating,
    bool? inStock,
    PlantQuickGuide? plantQuickGuide,
    Description? description,
    String? howToPlant,
    CareGuide? careGuide,
    String? toxicity,
    String? season,
    bool? flowering,
    String? placement,
    String? soilType,
    String? lifecycleStage,
    String? recommendedPotSize,
    List<String>? benefits,
    List<Faqs>? faqs,
  }) => AllPlantsModel(
    id: id ?? _id,
    commonName: commonName ?? _commonName,
    scientificName: scientificName ?? _scientificName,
    category: category ?? _category,
    tags: tags ?? _tags,
    attributes: attributes ?? _attributes,
    images: images ?? _images,
    prices: prices ?? _prices,
    rating: rating ?? _rating,
    inStock: inStock ?? _inStock,
    plantQuickGuide: plantQuickGuide ?? _plantQuickGuide,
    description: description ?? _description,
    howToPlant: howToPlant ?? _howToPlant,
    careGuide: careGuide ?? _careGuide,
    toxicity: toxicity ?? _toxicity,
    season: season ?? _season,
    flowering: flowering ?? _flowering,
    placement: placement ?? _placement,
    soilType: soilType ?? _soilType,
    lifecycleStage: lifecycleStage ?? _lifecycleStage,
    recommendedPotSize: recommendedPotSize ?? _recommendedPotSize,
    benefits: benefits ?? _benefits,
    faqs: faqs ?? _faqs,
  );
  String? get id => _id;
  String? get commonName => _commonName;
  String? get scientificName => _scientificName;
  String? get category => _category;
  List<String>? get tags => _tags;
  Attributes? get attributes => _attributes;
  List<Images>? get images => _images;
  Prices? get prices => _prices;
  num? get rating => _rating;
  bool? get inStock => _inStock;
  PlantQuickGuide? get plantQuickGuide => _plantQuickGuide;
  Description? get description => _description;
  String? get howToPlant => _howToPlant;
  CareGuide? get careGuide => _careGuide;
  String? get toxicity => _toxicity;
  String? get season => _season;
  bool? get flowering => _flowering;
  String? get placement => _placement;
  String? get soilType => _soilType;
  String? get lifecycleStage => _lifecycleStage;
  String? get recommendedPotSize => _recommendedPotSize;
  List<String>? get benefits => _benefits;
  List<Faqs>? get faqs => _faqs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['common_name'] = _commonName;
    map['scientific_name'] = _scientificName;
    map['category'] = _category;
    map['tags'] = _tags;
    if (_attributes != null) {
      map['attributes'] = _attributes?.toJson();
    }
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    if (_prices != null) {
      map['prices'] = _prices?.toJson();
    }
    map['rating'] = _rating;
    map['in_stock'] = _inStock;
    if (_plantQuickGuide != null) {
      map['plant_quick_guide'] = _plantQuickGuide?.toJson();
    }
    if (_description != null) {
      map['description'] = _description?.toJson();
    }
    map['how_to_plant'] = _howToPlant;
    if (_careGuide != null) {
      map['care_guide'] = _careGuide?.toJson();
    }
    map['toxicity'] = _toxicity;
    map['season'] = _season;
    map['flowering'] = _flowering;
    map['placement'] = _placement;
    map['soil_type'] = _soilType;
    map['lifecycle_stage'] = _lifecycleStage;
    map['recommended_pot_size'] = _recommendedPotSize;
    map['benefits'] = _benefits;
    if (_faqs != null) {
      map['faqs'] = _faqs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// question : "How often should I water my Ficus Bonsai?"
/// answer : "Water when the top inch of soil is dry to the touch."

class Faqs {
  Faqs({String? question, String? answer}) {
    _question = question;
    _answer = answer;
  }

  Faqs.fromJson(dynamic json) {
    _question = json['question'];
    _answer = json['answer'];
  }
  String? _question;
  String? _answer;
  Faqs copyWith({String? question, String? answer}) =>
      Faqs(question: question ?? _question, answer: answer ?? _answer);
  String? get question => _question;
  String? get answer => _answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = _question;
    map['answer'] = _answer;
    return map;
  }
}

/// watering : {"frequency":"Once a week","description":"Water when the top inch of soil feels dry. Avoid over-watering."}
/// light : {"description":"Needs bright, indirect light for best growth.","type":"Indirect Light"}
/// fertilizer : {"description":"Feed once a month with a balanced liquid fertilizer.","type":"Balanced Fertilizer"}
/// temperature : {"range":"18-24°C","description":"Prefers warm temperatures and should not be exposed to drafts."}
/// humidity : {"level":"Moderate","description":"Moderate humidity is ideal, but it can tolerate drier conditions."}

class CareGuide {
  CareGuide({
    Watering? watering,
    Light? light,
    Fertilizer? fertilizer,
    Temperature? temperature,
    Humidity? humidity,
  }) {
    _watering = watering;
    _light = light;
    _fertilizer = fertilizer;
    _temperature = temperature;
    _humidity = humidity;
  }

  CareGuide.fromJson(dynamic json) {
    _watering =
        json['watering'] != null ? Watering.fromJson(json['watering']) : null;
    _light = json['light'] != null ? Light.fromJson(json['light']) : null;
    _fertilizer =
        json['fertilizer'] != null
            ? Fertilizer.fromJson(json['fertilizer'])
            : null;
    _temperature =
        json['temperature'] != null
            ? Temperature.fromJson(json['temperature'])
            : null;
    _humidity =
        json['humidity'] != null ? Humidity.fromJson(json['humidity']) : null;
  }
  Watering? _watering;
  Light? _light;
  Fertilizer? _fertilizer;
  Temperature? _temperature;
  Humidity? _humidity;
  CareGuide copyWith({
    Watering? watering,
    Light? light,
    Fertilizer? fertilizer,
    Temperature? temperature,
    Humidity? humidity,
  }) => CareGuide(
    watering: watering ?? _watering,
    light: light ?? _light,
    fertilizer: fertilizer ?? _fertilizer,
    temperature: temperature ?? _temperature,
    humidity: humidity ?? _humidity,
  );
  Watering? get watering => _watering;
  Light? get light => _light;
  Fertilizer? get fertilizer => _fertilizer;
  Temperature? get temperature => _temperature;
  Humidity? get humidity => _humidity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_watering != null) {
      map['watering'] = _watering?.toJson();
    }
    if (_light != null) {
      map['light'] = _light?.toJson();
    }
    if (_fertilizer != null) {
      map['fertilizer'] = _fertilizer?.toJson();
    }
    if (_temperature != null) {
      map['temperature'] = _temperature?.toJson();
    }
    if (_humidity != null) {
      map['humidity'] = _humidity?.toJson();
    }
    return map;
  }
}

/// level : "Moderate"
/// description : "Moderate humidity is ideal, but it can tolerate drier conditions."

class Humidity {
  Humidity({String? level, String? description}) {
    _level = level;
    _description = description;
  }

  Humidity.fromJson(dynamic json) {
    _level = json['level'];
    _description = json['description'];
  }
  String? _level;
  String? _description;
  Humidity copyWith({String? level, String? description}) => Humidity(
    level: level ?? _level,
    description: description ?? _description,
  );
  String? get level => _level;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['level'] = _level;
    map['description'] = _description;
    return map;
  }
}

/// range : "18-24°C"
/// description : "Prefers warm temperatures and should not be exposed to drafts."

class Temperature {
  Temperature({String? range, String? description}) {
    _range = range;
    _description = description;
  }

  Temperature.fromJson(dynamic json) {
    _range = json['range'];
    _description = json['description'];
  }
  String? _range;
  String? _description;
  Temperature copyWith({String? range, String? description}) => Temperature(
    range: range ?? _range,
    description: description ?? _description,
  );
  String? get range => _range;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['range'] = _range;
    map['description'] = _description;
    return map;
  }
}

/// description : "Feed once a month with a balanced liquid fertilizer."
/// type : "Balanced Fertilizer"

class Fertilizer {
  Fertilizer({String? description, String? type}) {
    _description = description;
    _type = type;
  }

  Fertilizer.fromJson(dynamic json) {
    _description = json['description'];
    _type = json['type'];
  }
  String? _description;
  String? _type;
  Fertilizer copyWith({String? description, String? type}) =>
      Fertilizer(description: description ?? _description, type: type ?? _type);
  String? get description => _description;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['type'] = _type;
    return map;
  }
}

/// description : "Needs bright, indirect light for best growth."
/// type : "Indirect Light"

class Light {
  Light({String? description, String? type}) {
    _description = description;
    _type = type;
  }

  Light.fromJson(dynamic json) {
    _description = json['description'];
    _type = json['type'];
  }
  String? _description;
  String? _type;
  Light copyWith({String? description, String? type}) =>
      Light(description: description ?? _description, type: type ?? _type);
  String? get description => _description;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['type'] = _type;
    return map;
  }
}

/// frequency : "Once a week"
/// description : "Water when the top inch of soil feels dry. Avoid over-watering."

class Watering {
  Watering({String? frequency, String? description}) {
    _frequency = frequency;
    _description = description;
  }

  Watering.fromJson(dynamic json) {
    _frequency = json['frequency'];
    _description = json['description'];
  }
  String? _frequency;
  String? _description;
  Watering copyWith({String? frequency, String? description}) => Watering(
    frequency: frequency ?? _frequency,
    description: description ?? _description,
  );
  String? get frequency => _frequency;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['frequency'] = _frequency;
    map['description'] = _description;
    return map;
  }
}

/// intro : "The Ficus Bonsai is one of the most popular indoor bonsai plants, known for its easy care and attractive appearance."
/// water : "Water thoroughly when the top inch of soil is dry."
/// pet_friendly : "Yes, Ficus is non-toxic to pets."
/// beginner_friendly : "Yes, Ficus Bonsai is beginner-friendly and easy to maintain."

class Description {
  Description({
    String? intro,
    String? water,
    String? petFriendly,
    String? beginnerFriendly,
  }) {
    _intro = intro;
    _water = water;
    _petFriendly = petFriendly;
    _beginnerFriendly = beginnerFriendly;
  }

  Description.fromJson(dynamic json) {
    _intro = json['intro'];
    _water = json['water'];
    _petFriendly = json['pet_friendly'];
    _beginnerFriendly = json['beginner_friendly'];
  }
  String? _intro;
  String? _water;
  String? _petFriendly;
  String? _beginnerFriendly;
  Description copyWith({
    String? intro,
    String? water,
    String? petFriendly,
    String? beginnerFriendly,
  }) => Description(
    intro: intro ?? _intro,
    water: water ?? _water,
    petFriendly: petFriendly ?? _petFriendly,
    beginnerFriendly: beginnerFriendly ?? _beginnerFriendly,
  );
  String? get intro => _intro;
  String? get water => _water;
  String? get petFriendly => _petFriendly;
  String? get beginnerFriendly => _beginnerFriendly;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['intro'] = _intro;
    map['water'] = _water;
    map['pet_friendly'] = _petFriendly;
    map['beginner_friendly'] = _beginnerFriendly;
    return map;
  }
}

/// height : "1-2 feet"
/// width : "1-1.5 feet"
/// sunlight : ["Indirect Light"]
/// growth_rate : "Moderate"

class PlantQuickGuide {
  PlantQuickGuide({
    String? height,
    String? width,
    List<String>? sunlight,
    String? growthRate,
  }) {
    _height = height;
    _width = width;
    _sunlight = sunlight;
    _growthRate = growthRate;
  }

  PlantQuickGuide.fromJson(dynamic json) {
    _height = json['height'];
    _width = json['width'];
    _sunlight =
        json['sunlight'] is List
            ? List<String>.from(json['sunlight'])
            : [json['sunlight'].toString()];
    _growthRate = json['growth_rate'];
  }

  String? _height;
  String? _width;
  List<String>? _sunlight;
  String? _growthRate;
  PlantQuickGuide copyWith({
    String? height,
    String? width,
    List<String>? sunlight,
    String? growthRate,
  }) => PlantQuickGuide(
    height: height ?? _height,
    width: width ?? _width,
    sunlight: sunlight ?? _sunlight,
    growthRate: growthRate ?? _growthRate,
  );
  String? get height => _height;
  String? get width => _width;
  List<String>? get sunlight => _sunlight;
  String? get growthRate => _growthRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = _height;
    map['width'] = _width;
    map['sunlight'] = _sunlight;
    map['growth_rate'] = _growthRate;
    return map;
  }
}

/// original_price : 1199
/// offer_price : 959

class Prices {
  Prices({num? originalPrice, num? offerPrice}) {
    _originalPrice = originalPrice;
    _offerPrice = offerPrice;
  }

  Prices.fromJson(dynamic json) {
    _originalPrice = json['original_price'];
    _offerPrice = json['offer_price'];
  }
  num? _originalPrice;
  num? _offerPrice;
  Prices copyWith({num? originalPrice, num? offerPrice}) => Prices(
    originalPrice: originalPrice ?? _originalPrice,
    offerPrice: offerPrice ?? _offerPrice,
  );
  num? get originalPrice => _originalPrice;
  num? get offerPrice => _offerPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['original_price'] = _originalPrice;
    map['offer_price'] = _offerPrice;
    return map;
  }
}

/// url : "https://imgs.search.brave.com/fk5nbSlAeQGLh3g3eIoAz8Gu_p_1Q4WQumWeDDT5CKI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hYmFu/YWhvbWVzLmNvbS9j/ZG4vc2hvcC9maWxl/cy9ncmFmdGVkLWZp/Y3VzLWJvbnNhaS1w/bGFudC1pbi1rYW1y/YWstcG90LXdpdGgt/ZmlndXJpbmUtZm9y/LWhvbWUtZGVjb3It/Mi5qcGc_dj0xNzM1/ODMxNzA0JndpZHRo/PTUzMw"
/// alt_text : "Ficus Bonsai tree with dense green foliage"
/// type : "main"

class Images {
  Images({String? url, String? altText, String? type}) {
    _url = url;
    _altText = altText;
    _type = type;
  }

  Images.fromJson(dynamic json) {
    _url = json['url'];
    _altText = json['alt_text'];
    _type = json['type'];
  }
  String? _url;
  String? _altText;
  String? _type;
  Images copyWith({String? url, String? altText, String? type}) => Images(
    url: url ?? _url,
    altText: altText ?? _altText,
    type: type ?? _type,
  );
  String? get url => _url;
  String? get altText => _altText;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['alt_text'] = _altText;
    map['type'] = _type;
    return map;
  }
}

/// is_air_purifying : true
/// is_low_maintenance : true
/// is_foliage : true
/// is_pet_friendly : true
/// is_beginner_friendly : true
/// is_flowering : false
/// is_sun_loving : true
/// is_shadow_loving : false
/// is_edible : false

class Attributes {
  Attributes({
    bool? isAirPurifying,
    bool? isLowMaintenance,
    bool? isFoliage,
    bool? isPetFriendly,
    bool? isBeginnerFriendly,
    bool? isFlowering,
    bool? isSunLoving,
    bool? isShadowLoving,
    bool? isEdible,
  }) {
    _isAirPurifying = isAirPurifying;
    _isLowMaintenance = isLowMaintenance;
    _isFoliage = isFoliage;
    _isPetFriendly = isPetFriendly;
    _isBeginnerFriendly = isBeginnerFriendly;
    _isFlowering = isFlowering;
    _isSunLoving = isSunLoving;
    _isShadowLoving = isShadowLoving;
    _isEdible = isEdible;
  }

  Attributes.fromJson(dynamic json) {
    _isAirPurifying = json['is_air_purifying'];
    _isLowMaintenance = json['is_low_maintenance'];
    _isFoliage = json['is_foliage'];
    _isPetFriendly = json['is_pet_friendly'];
    _isBeginnerFriendly = json['is_beginner_friendly'];
    _isFlowering = json['is_flowering'];
    _isSunLoving = json['is_sun_loving'];
    _isShadowLoving = json['is_shadow_loving'];
    _isEdible = json['is_edible'];
  }
  bool? _isAirPurifying;
  bool? _isLowMaintenance;
  bool? _isFoliage;
  bool? _isPetFriendly;
  bool? _isBeginnerFriendly;
  bool? _isFlowering;
  bool? _isSunLoving;
  bool? _isShadowLoving;
  bool? _isEdible;
  Attributes copyWith({
    bool? isAirPurifying,
    bool? isLowMaintenance,
    bool? isFoliage,
    bool? isPetFriendly,
    bool? isBeginnerFriendly,
    bool? isFlowering,
    bool? isSunLoving,
    bool? isShadowLoving,
    bool? isEdible,
  }) => Attributes(
    isAirPurifying: isAirPurifying ?? _isAirPurifying,
    isLowMaintenance: isLowMaintenance ?? _isLowMaintenance,
    isFoliage: isFoliage ?? _isFoliage,
    isPetFriendly: isPetFriendly ?? _isPetFriendly,
    isBeginnerFriendly: isBeginnerFriendly ?? _isBeginnerFriendly,
    isFlowering: isFlowering ?? _isFlowering,
    isSunLoving: isSunLoving ?? _isSunLoving,
    isShadowLoving: isShadowLoving ?? _isShadowLoving,
    isEdible: isEdible ?? _isEdible,
  );
  bool? get isAirPurifying => _isAirPurifying;
  bool? get isLowMaintenance => _isLowMaintenance;
  bool? get isFoliage => _isFoliage;
  bool? get isPetFriendly => _isPetFriendly;
  bool? get isBeginnerFriendly => _isBeginnerFriendly;
  bool? get isFlowering => _isFlowering;
  bool? get isSunLoving => _isSunLoving;
  bool? get isShadowLoving => _isShadowLoving;
  bool? get isEdible => _isEdible;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_air_purifying'] = _isAirPurifying;
    map['is_low_maintenance'] = _isLowMaintenance;
    map['is_foliage'] = _isFoliage;
    map['is_pet_friendly'] = _isPetFriendly;
    map['is_beginner_friendly'] = _isBeginnerFriendly;
    map['is_flowering'] = _isFlowering;
    map['is_sun_loving'] = _isSunLoving;
    map['is_shadow_loving'] = _isShadowLoving;
    map['is_edible'] = _isEdible;
    return map;
  }
}
