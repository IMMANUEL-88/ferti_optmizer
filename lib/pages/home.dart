import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:agri_connect/popups/fullscreen_loaders.dart';
import 'package:agri_connect/utils/weatherContainer.dart';
import 'package:http/http.dart' as http;
import 'package:agri_connect/API/mlApi.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:agri_connect/models/nutritionData_model.dart';
import 'package:agri_connect/models/sensorData_model.dart';
import 'package:agri_connect/utils/analysis_box.dart';
import 'package:agri_connect/utils/appbar.dart';
import 'package:agri_connect/utils/home_container.dart';
import 'package:agri_connect/utils/npk_box.dart';
import 'package:agri_connect/utils/sensor_data_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/weather_model.dart';
import '../API/weather_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  String appBarTittle = '';
  bool showAvg = false;
  final PageController _pageController = PageController();
  final PageController _pageController2 = PageController();
  late Future<List<SensorDataModel>> _sensorDataFuture;
  List<SensorDataModel>? _sensorDataList;
  late Future<List<NutritionDataModel>> _nutritionDataFuture;
  List<NutritionDataModel>? _nutritionDataList;
  double _rotationAngle = 0.0;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  String _response = '';
  String _selectedLanguage = 'English';
  Timer? _timer;
  Random _random = Random();
  DateTime _lastSensorUpdate = DateTime.now();
  late Timer _uiUpdateTimer;
  bool _shouldUpdateGemini = true;
  int _geminiRetryCount = 0;
  static const int _maxGeminiRetries = 3;

  // Simulated sensor data
  double _simulatedSoilMoisture = 0;
  double _simulatedTemperature = 0;
  double _simulatedHumidity = 0;
  double _simulatedNitrogen = 0;
  double _simulatedPhosphorous = 0;
  double _simulatedPotassium = 0;

  // Motor control
  late AnimationController _motorController;
  String? motorStatus = 'OFF'; // Default motor status
  bool _shouldUseGeminiAPI = false;

  // Weather service API key
  final _weatherService = WeatherService('90bf9ca3170d2fbeddd2548cddcb6c33');
  Weather? _weather;

  //forecast
  Map<String, dynamic>? data;
  List<dynamic>? hourlyTimes;
  List<dynamic>? hourlyTemperatures;
  List<dynamic>? hourlyHumidities;
  List<dynamic>? hourlyCode;
  String? timezone;
  String? formattedDate;
  String? greeting;
  String? formattedTime;
  String? SM_analysis;
  String? H_analysis;
  String? T_analysis;

  String? N_analysis;
  String? P_analysis;
  String? K_analysis;

  //Soil Condition
  String question1 = '';
  String question2 = '';
  String question3 = '';

  //Soil Nutrition
  String question4 = '';
  String question5 = '';
  String question6 = '';

  String _selectedField = 'Field 1';
  final Map<String, Map<String, dynamic>> _fieldLocations = {
    'Field 1': {
      'name': 'Tirunelveli',
      'latitude': 8.708664,
      'longitude': 77.786011,
      'isUserLocation': false,
    },
    'Field 2': {
      'name': 'Coimbatore',
      'latitude': 11.0168,
      'longitude': 76.9558,
      'isUserLocation': false,
    },
    'Field 3': {
      'name': 'Madurai',
      'latitude': 9.9252,
      'longitude': 78.1198,
      'isUserLocation': false,
    },
  };

  void _generateSimulatedData() {
    setState(() {
      // Small incremental changes (1-5% of range)
      _simulatedSoilMoisture =
          (_simulatedSoilMoisture + (_random.nextDouble() * 40 - 20))
              .clamp(200.0, 1000.0);
      _simulatedTemperature =
          (_simulatedTemperature + (_random.nextDouble() * 2 - 1))
              .clamp(20.0, 40.0);
      _simulatedHumidity =
          (_simulatedHumidity + (_random.nextDouble() * 5 - 2.5))
              .clamp(30.0, 100.0);
      _simulatedNitrogen = double.parse(
        (_simulatedNitrogen + (_random.nextDouble() * 4 - 2))
            .clamp(10.0, 100.0)
            .toStringAsFixed(1),
      );

      _simulatedPhosphorous = double.parse(
        (_simulatedPhosphorous + (_random.nextDouble() * 4 - 2))
            .clamp(10.0, 100.0)
            .toStringAsFixed(1),
      );

      _simulatedPotassium = double.parse(
        (_simulatedPotassium + (_random.nextDouble() * 4 - 2))
            .clamp(10.0, 100.0)
            .toStringAsFixed(1),
      );

      _lastSensorUpdate = DateTime.now();
    });

    // Only update Gemini questions every 5 minutes
    if (_shouldUpdateGemini) {
      question1 =
          'Generate a concise 12-word response explaining what a soil moisture level of ${_simulatedSoilMoisture.round()} means,(use this to analyse the moisture level: very dry:801 - 1024, dry:601 - 800, moist:401 - 600, wet:201 - 400, waterlogged:0 - 200 (note dont show this in response).';
      question2 =
          'Generate a concise 12-word response explaining what a humidity level of ${_simulatedHumidity.round()} means,';
      question3 =
          'Generate a concise 12-word response explaining what a temperature level of ${_simulatedTemperature.round()}degree celsius means,';
      question4 =
          'Generate a concise 12-word response explaining what a Nitrogen level of ${_simulatedNitrogen.round()} means, (croptype: Barley, soiltype: Loamy).';
      question5 =
          'Generate a concise 12-word response explaining what a Phosphorous level of ${_simulatedPhosphorous.round()} means, (croptype: Barley, soiltype: Loamy).';
      question6 =
          'Generate a concise 12-word response explaining what a Potassium level of ${_simulatedPotassium.round()} means, (croptype: Barley, soiltype: Loamy).';

      getRecommendation();
      _shouldUpdateGemini = false;
    }
  }

  void _startSensorDataTimer() {
    // Generate initial data
    _generateSimulatedData();

    // Update UI every 10 seconds with small changes
    _uiUpdateTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _generateSimulatedData();
      _fetchSensorData();
      _fetchNutritionData();
    });

    // Update Gemini every 5 minutes
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _shouldUpdateGemini = true;
    });
  }

  // Fetch weather data
  Future<void> _fetchWeather() async {
    try {
      final location = _fieldLocations[_selectedField]!;
      Weather? weather;

      if (location['isUserLocation'] == true && location['latitude'] != null) {
        weather = await _weatherService
            .getWeatherByCoordinates(
                location['latitude'], location['longitude'])
            .timeout(const Duration(seconds: 10));
      } else {
        // For non-user locations or when user location isn't available yet
        weather = await _weatherService
            .getWeather(location['name'])
            .timeout(const Duration(seconds: 10));
      }

      if (weather == null) {
        throw Exception('Weather data is null');
      }

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');

      // Set default weather data to prevent UI issues
      setState(() {
        _weather = Weather(
          cityName: _fieldLocations[_selectedField]!['name'],
          temperature: 25.0,
          mainCondition: 'Clear',
        );
      });
    }
  }

  // Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/animations/loader4.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/animations/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/animations/rain.json';
      case 'thunderstorm':
        return 'assets/animations/thunder.json';
      case 'clear':
        return 'assets/animations/sunny.json';
      default:
        return 'assets/animations/sunny.json';
    }
  }

  Future<List<SensorDataModel>> _fetchSensorData() async {
    // Return simulated data instead of API call
    final simulatedData = SensorDataModel(
      sensorId: 'simulated',
      soilMoisture: _simulatedSoilMoisture,
      temperature: _simulatedTemperature,
      humidity: _simulatedHumidity,
      timestamp: _lastSensorUpdate,
      fieldId: '69',
    );

    setState(() {
      _sensorDataList = [simulatedData];
      _sensorDataFuture = Future.value([simulatedData]);
    });

    return [simulatedData];
  }

  Future<List<NutritionDataModel>> _fetchNutritionData() async {
    final simulatedData = NutritionDataModel(
        id: 'simulated',
        fieldId: '69',
        soilType: 'Loamy',
        phLevel: 6,
        nitrogen: _simulatedNitrogen,
        phosphorus: _simulatedPhosphorous,
        potassium: _simulatedPotassium,
        otherNutrients: {'Calcium': 3.0},
        last_fertilizer: _nutritionDataList?.first.last_fertilizer ??
            'Urea', // Preserve existing value
        timestamp: _lastSensorUpdate,
        cropType: 'Paddy');

    setState(() {
      _nutritionDataList = [simulatedData];
      _nutritionDataFuture = Future.value([simulatedData]);
    });

    return [simulatedData];
  }

  void fetchData() async {
    try {
      final location = _fieldLocations[_selectedField]!;

      Uri url;
      if (location['latitude'] != null && location['longitude'] != null) {
        url = Uri.parse(
            'https://api.open-meteo.com/v1/forecast?latitude=${location['latitude']}&longitude=${location['longitude']}&current=temperature_2m,relative_humidity_2m&hourly=temperature_2m,relative_humidity_2m,weather_code');
      } else {
        // Fallback to default coordinates if none available
        url = Uri.parse(
            'https://api.open-meteo.com/v1/forecast?latitude=13.0827&longitude=80.2707&current=temperature_2m,relative_humidity_2m&hourly=temperature_2m,relative_humidity_2m,weather_code');
      }

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          hourlyTimes = data!['hourly']['time'].sublist(0, 24);
          hourlyCode = data!['hourly']['weather_code'].sublist(0, 24);
          hourlyTemperatures = data!['hourly']['temperature_2m'].sublist(0, 24);
          hourlyHumidities =
              data!['hourly']['relative_humidity_2m'].sublist(0, 24);
          timezone = data!['timezone'];

          DateTime currentTime = DateTime.parse(data!['current']['time']);
          int currentHour = currentTime.hour;
          if (currentHour < 12) {
            greeting = 'Good Morning';
          } else if (currentHour < 17) {
            greeting = 'Good Afternoon';
          } else {
            greeting = 'Good Evening';
          }

          formattedDate = DateFormat('EEEE d').format(currentTime);
          formattedTime = DateFormat('h:mm a').format(currentTime);
        });
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load forecast data for $_selectedField'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Set default forecast data
      setState(() {
        hourlyTimes = List.generate(24, (i) => '${i}:00');
        hourlyTemperatures = List.generate(24, (i) => 25.0 + i % 3);
        hourlyHumidities = List.generate(24, (i) => 50 + i % 10);
        hourlyCode = List.generate(24, (i) => 0);
        greeting = 'Good Day';
        formattedDate = DateFormat('EEEE d').format(DateTime.now());
        formattedTime = DateFormat('h:mm a').format(DateTime.now());
      });
    }
  }

  Future<void> getRecommendation() async {
    if (!_shouldUseGeminiAPI) {
      // Set default values when Gemini is disabled
      setState(() {
        SM_analysis = "Soil moisture analysis disabled";
        H_analysis = "Humidity analysis disabled";
        T_analysis = "Temperature analysis disabled";
        N_analysis = "Nitrogen analysis disabled";
        P_analysis = "Phosphorous analysis disabled";
        K_analysis = "Potassium analysis disabled";
      });
      return;
    }

    _geminiRetryCount = 0; // Reset retry counter

    Future<String?> safeAskGemini(String question) async {
      while (_geminiRetryCount < _maxGeminiRetries) {
        try {
          final response =
              await Gemini().makeApiRequestForRecommendations(question);
          if (response != null && response.isNotEmpty) {
            return response;
          }
        } catch (error) {
          print('Gemini API attempt ${_geminiRetryCount + 1} failed: $error');
        }
        _geminiRetryCount++;
        if (_geminiRetryCount < _maxGeminiRetries) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      return "Analysis temporarily unavailable. Please try again later.";
    }

    SM_analysis = await safeAskGemini(question1);
    H_analysis = await safeAskGemini(question2);
    T_analysis = await safeAskGemini(question3);
    N_analysis = await safeAskGemini(question4);
    P_analysis = await safeAskGemini(question5);
    K_analysis = await safeAskGemini(question6);

    setState(() {}); // Trigger UI update
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      // Position position = await Geolocator.getCurrentPosition();
      // setState(() {
      //   _fieldLocations['Field 1']!['latitude'] = position.latitude;
      //   _fieldLocations['Field 1']!['longitude'] = position.longitude;
      //   _fieldLocations['Field 1']!['name'] = 'Your Location';
      // });

      // if (_selectedField == 'Field 1') {
      //   _fetchWeather();
      //   fetchData();
      // }
    } catch (e) {
      print("Error getting location: $e");
      // Fallback to a default location if user location can't be obtained
      _fieldLocations['Field 1']!['latitude'] = 13.0827;
      _fieldLocations['Field 1']!['longitude'] = 80.2707;
      _fieldLocations['Field 1']!['name'] = 'Default Location';
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation().then((_) {
      _fetchWeather();
      fetchData();
    });
    _simulatedSoilMoisture = 500.0;
    _simulatedTemperature = 25.0;
    _simulatedHumidity = 50.0;
    _simulatedNitrogen = 50.0;
    _simulatedPhosphorous = 50.0;
    _simulatedPotassium = 50.0;
    _startSensorDataTimer();
    _nutritionDataFuture = _fetchNutritionData();
    _sensorDataFuture = _fetchSensorData();
    _fetchWeather();
    fetchData();

    _motorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    Irrigation().fetchMotorStatus().then((status) {
      setState(() {
        motorStatus = status;
        if (motorStatus == 'ON') {
          _motorController.repeat();
        } else {
          _motorController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _uiUpdateTimer.cancel();
    _timer?.cancel();
    _pageController.dispose();
    _pageController2.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _motorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = EHelperFunctions.screenHeight(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: EAppBar(
          title: Text(
            'Home',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          leadingIcon: Icons.keyboard_arrow_down_rounded,
          leadingIconColor: Colors.white,
          leadingIconSize: 30,
          leadingOnPressed: () {
            showMenu(
              color: Colors.white54,
              context: context,
              position: const RelativeRect.fromLTRB(0, 56.0, 0, 0),
              items: _fieldLocations.entries.map((entry) {
                final fieldKey = entry.key;
                final fieldData = entry.value;
                final locationName = fieldData['name'];
                return PopupMenuItem(
                  value: fieldKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fieldKey,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(locationName, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  onTap: () async {
                    EFullScreenLoader.openLoadingDialog(
                        "Loading Data...", context);
                    await Future.delayed(const Duration(seconds: 3));
                    setState(() {
                      _selectedField = fieldKey;
                      if (fieldKey == 'Field 1') {
                        // Refresh user location when selecting Field 1
                        _getUserLocation().then((_) {
                          _fetchWeather();
                          fetchData();
                        });
                      } else {
                        _fetchWeather();
                        fetchData();
                      }
                    });
                    EFullScreenLoader.stopLoading(context);
                  },
                );
              }).toList(),
            );
          },
          precedingIcon: Icons.settings,
          precedingIconColor: Colors.white,
          precedingOnPressed: () {
            context.push('/settings');
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              _rotationAngle += 1.0;
            });
            _showModalBottomSheet(context);
          },
          backgroundColor: Colors.white,
          child: AnimatedRotation(
            turns: _rotationAngle,
            duration: const Duration(seconds: 1),
            child: const FaIcon(
              FontAwesomeIcons.hurricane,
              size: 40.0,
              color: Colors.green,
            ),
          ),
        ),
        body: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                expandedHeight: screenHeight * 0.55,
                backgroundColor: const Color(0xFF4CAF50),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    var opacity = (top - 80) / 250;

                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      EHelperFunctions.screenHeight(context) *
                                          0.15,
                                ),
                                Center(
                                  child: _weather == null
                                      ? const SizedBox(child: Text(""))
                                      : Text(
                                          _weather?.cityName ??
                                              "Loading city...",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                ),
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    SizedBox(
                                        height: EHelperFunctions.screenHeight(
                                                context) *
                                            0.08,
                                        width: EHelperFunctions.screenHeight(
                                                context) *
                                            0.08,
                                        child: Lottie.asset(getWeatherAnimation(
                                            _weather?.mainCondition))),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 64),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: _weather == null
                                                ? const SizedBox(
                                                    child: Text(""))
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${_weather?.temperature.round()}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 44,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      const Text(
                                                        '°C',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          Text(
                                            _weather?.mainCondition ?? "",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Last updated indicator
                Text(
                  'Last updated: ${DateFormat('h:mm a').format(_lastSensorUpdate)}',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // --Section 1--
                GestureDetector(
                  onLongPress: () async {
                    await _fetchNutritionData();
                  },
                  child: ReusableContainer(
                    height: 280,
                    width: double.infinity,
                    child: FutureBuilder<List<SensorDataModel>>(
                      future: _sensorDataFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SensorDataModel>> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final sensorDataList = snapshot.data!;
                          final averages =
                              SensorDataModel.calculateDailyAverages(
                                  sensorDataList);

                          return Padding(
                            padding: const EdgeInsets.all(ESizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sensor Readings',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'More Details',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: ESizes.spaceBtwItems),
                                SensorData(
                                  sensorIcon: Icons.water_drop,
                                  iconColor: Colors.white70,
                                  sensorName: "Soil Moisture",
                                  sensorActualValue: sensorDataList.isNotEmpty
                                      ? sensorDataList.last.soilMoisture
                                      : 0,
                                  sensorAvgValue:
                                      averages['avgSoilMoisture'] ?? 0,
                                ),
                                const SizedBox(height: ESizes.md),
                                SensorData(
                                  sensorIcon: Icons.thermostat,
                                  iconColor: Colors.white70,
                                  sensorName: "Temperature",
                                  sensorActualValue: sensorDataList.isNotEmpty
                                      ? sensorDataList.last.temperature
                                      : 0,
                                  sensorAvgValue:
                                      averages['avgTemperature'] ?? 0,
                                ),
                                const SizedBox(height: ESizes.md),
                                SensorData(
                                  sensorIcon: Icons.water_damage,
                                  iconColor: Colors.white70,
                                  sensorName: "Humidity",
                                  sensorActualValue: sensorDataList.isNotEmpty
                                      ? sensorDataList.last.humidity
                                      : 0,
                                  sensorAvgValue: averages['avgHumidity'] ?? 0,
                                ),
                                const SizedBox(height: ESizes.spaceBtwSections),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 55,
                                      width: 300,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.push('/analytics');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text(
                                          'Analytics',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(ESizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sensor Readings',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'More Details',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: ESizes.spaceBtwItems),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SensorData(
                                      sensorIcon: Icons.water_drop,
                                      iconColor: Colors.white70,
                                      sensorName: "Soil Moisture",
                                    ),
                                    Row(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.green[300]!,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Text(' / '),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.green[300]!,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: ESizes.md),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SensorData(
                                      sensorIcon: Icons.thermostat,
                                      iconColor: Colors.white70,
                                      sensorName: "Temperature",
                                    ),
                                    Row(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.green[300]!,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Text(' / '),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.green[300]!,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: ESizes.md),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SensorData(
                                      sensorIcon: Icons.water_damage,
                                      iconColor: Colors.white70,
                                      sensorName: "Humidity",
                                    ),
                                    Row(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.green[300]!,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Text(' / '),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[400]!,
                                          highlightColor: Colors.green[300]!,
                                          child: Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: ESizes.spaceBtwSections),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 55,
                                      width: 300,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.push('/analytics');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text(
                                          'Analytics',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --Section 2--
                SizedBox(
                  height: 130,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            List<Widget> analysisBoxes = [
                              Analysis_box(
                                icon: Icons.water_drop,
                                title: 'Soil moisture looks like',
                                subTitle: SM_analysis ?? "Loading analysis...",
                              ),
                              Analysis_box(
                                icon: Icons.thermostat,
                                title: 'Temperature looks like',
                                subTitle: T_analysis ?? "Loading analysis...",
                              ),
                              Analysis_box(
                                icon: Icons.water_damage,
                                title: 'Humidity looks like',
                                subTitle: H_analysis ?? "Loading analysis...",
                              ),
                            ];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: analysisBoxes[index],
                            );
                          },
                          physics: const BouncingScrollPhysics(),
                          pageSnapping: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --Section 3--
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/weekScreen');
                          },
                          child: const Row(
                            children: [
                              Text(
                                'More Details',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: ESizes.sm),
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(24, (index) {
                                return Row(
                                  children: [
                                    WeatherIcon(
                                      weatherCode: (hourlyCode != null &&
                                              hourlyCode!.isNotEmpty)
                                          ? hourlyCode![index]
                                          : 0,
                                      time:
                                          '${index == 0 ? 12 : index > 12 ? index - 12 : index}:00 ${index < 12 ? 'AM' : 'PM'}',
                                      temp: (hourlyTemperatures != null &&
                                              hourlyTemperatures!.isNotEmpty)
                                          ? hourlyTemperatures![index]
                                          : null,
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --Section 4--
                Row(
                  children: [
                    // First Container
                    Expanded(
                      child: Column(
                        children: [
                          ReusableContainer(
                              height: 108,
                              width: double.infinity,
                              child: _buildFertilizerSection()),
                          const SizedBox(height: ESizes.sm),
                          ReusableContainer(
                            height: 108,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.pin_drop, color: Colors.white54),
                                    SizedBox(width: 1),
                                    Text(
                                      'Field Location',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white54),
                                    )
                                  ],
                                ),
                                SizedBox(height: ESizes.sm),
                                Text(
                                  _fieldLocations[_selectedField]!['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: ESizes.sm),

                    // Second Container
                    Expanded(
                      child: ReusableContainer(
                          height: 224,
                          width: double.infinity,
                          child: _buildNPKSection()),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // --Section 5--
                ReusableContainer(
                    height: 100,
                    width: 75,
                    child: Row(
                      children: [
                        const Text(
                          "   Irrigation Control",
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        const Spacer(),
                        RotationTransition(
                          turns: _motorController,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                              onPressed: () async {
                                if (motorStatus == 'ON') {
                                  await Irrigation().updateMotorStatusOFF();
                                  setState(() {
                                    motorStatus = 'OFF';
                                    _motorController.stop();
                                  });
                                } else {
                                  await Irrigation().updateMotorStatusON();
                                  setState(() {
                                    motorStatus = 'ON';
                                    _motorController.repeat();
                                  });
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.fan,
                                size: 45,
                                color: motorStatus == 'ON'
                                    ? const Color(0xFF70BE92)
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    )),
                const SizedBox(height: 8),

                // --Section 6--
                SizedBox(
                  height: 130,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController2,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            List<Widget> analysisBoxes = [
                              Analysis_box(
                                icon: Icons.query_stats_rounded,
                                title: 'Nitrogen Analysis',
                                subTitle: N_analysis ?? "Loading analysis...",
                              ),
                              Analysis_box(
                                icon: Icons.query_stats_rounded,
                                title: 'Phosphorous Analysis',
                                subTitle: P_analysis ?? "Loading analysis...",
                              ),
                              Analysis_box(
                                icon: Icons.query_stats_rounded,
                                title: 'Potassium Analysis',
                                subTitle: K_analysis ?? "Loading analysis...",
                              ),
                            ];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: analysisBoxes[index],
                            );
                          },
                          physics: const BouncingScrollPhysics(),
                          pageSnapping: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SmoothPageIndicator(
                        controller: _pageController2,
                        count: 3,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPredictionBottomSheet(BuildContext context) {
    final MlApi mlApi = MlApi();
    bool isLoading = true;
    Map<String, dynamic> predictionData = {};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            Future<void> fetchData() async {
              try {
                await MlApi().trainMl();
                final data = await mlApi.mlPredict();
                setState(() {
                  predictionData = data;
                  isLoading = false;
                });
              } catch (error) {
                setState(() {
                  predictionData = {
                    'Fertilizer': 'Error fetching data',
                    'NPK_values_needed': [],
                  };
                  isLoading = false;
                });
              }
            }

            fetchData();

            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prediction Results',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54),
                    ),
                    const SizedBox(height: 16),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 150,
                                    height: 20,
                                    color: Colors.white54),
                                const SizedBox(height: 8),
                                Container(
                                    width: double.infinity,
                                    height: 20,
                                    color: Colors.white54),
                                const SizedBox(height: 8),
                                Container(
                                    width: double.infinity,
                                    height: 20,
                                    color: Colors.white54),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fertilizer: ${predictionData['Fertilizer'] ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'NPK Values Needed:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              const SizedBox(height: 8),
                              ...((predictionData['NPK_values_needed'] ?? [])
                                      as List<List<dynamic>>)
                                  .map<Widget>((values) {
                                return Text(
                                  'N: ${values[0]}, P: ${values[1]}, K: ${values[2]}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                );
                              }),
                            ],
                          ),
                    const SizedBox(height: 16),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _responseBuilt = false;

  String _getGreetingText() {
    switch (_selectedLanguage) {
      case 'Tamil':
        return 'வணக்கம், நான் எப்படி உதவலாம்?';
      case 'Malayalam':
        return 'ഹായ്, എനിക്ക് നിങ്ങളെ എങ്ങനെ സഹായിക്കാം?';
      case 'Telugu':
        return 'హలో, నేను మీకు ఎలా సహాయపడగలను?';
      case 'Hindi':
        return 'नमस्ते, मैं आपकी कैसे मदद कर सकता हूँ?';
      case 'Kannada':
        return 'ಹಾಯ್, ನಾನು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು?';
      case 'Bengali':
        return 'হাই, আমি আপনাকে কীভাবে সাহায্য করতে পারি?';
      case 'Marathi':
        return 'हाय, मी तुम्हाला कसे मदत करू शकतो?';
      default:
        return 'Hi, How can I help you?';
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Gemini ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '- $_selectedLanguage',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 125,
                      child: ListView(
                        children: [
                          if (!_responseBuilt)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _getGreetingText(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          _buildResponseSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.g_translate,
                              color: Colors.white54),
                          onPressed: () {
                            _showLanguageBottomSheet(context);
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: 'Type your question...',
                              hintStyle: const TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.white54,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.white54,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20.0),
                            ),
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            _submitQuestion(
                              "the language you should respond (it doesn't mean translation):$_selectedLanguage\n question: ${_controller.text}",
                            );
                            setState(() {
                              _responseBuilt = true;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.green,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  )),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildLanguageChip('English'),
                  _buildLanguageChip('Tamil'),
                  _buildLanguageChip('Malayalam'),
                  _buildLanguageChip('Telugu'),
                  _buildLanguageChip('Hindi'),
                  _buildLanguageChip('Kannada'),
                  _buildLanguageChip('Bengali'),
                  _buildLanguageChip('Marathi'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFertilizerSection() {
    return FutureBuilder<List<NutritionDataModel>>(
      future: _nutritionDataFuture,
      builder: (context, AsyncSnapshot<List<NutritionDataModel>> snapshot) {
        String latestFertilizer = 'N/A';
        bool isLoading = snapshot.connectionState == ConnectionState.waiting;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final data = snapshot.data!;
          final fertilizerList = data
              .map((e) => e.last_fertilizer)
              .where((e) => e.isNotEmpty)
              .toList();
          latestFertilizer =
              fertilizerList.isNotEmpty ? fertilizerList.join(', ') : 'N/A';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: EHelperFunctions.screenWidth(context) * .01),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current\nfertilizer:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 8),
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.green[300]!,
                    child: Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Text(
                    latestFertilizer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            SizedBox(width: EHelperFunctions.screenWidth(context) * .01),
            const VerticalDivider(
              color: Colors.white54,
              endIndent: 15,
              indent: 15,
            ),
            TextButton(
              onPressed: () {
                showPredictionBottomSheet(context);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.speed_sharp, color: Colors.white54, size: 50),
                  SizedBox(height: 4),
                  Text(
                    'Optimize',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildNPKSection() {
    return FutureBuilder<List<NutritionDataModel>>(
      future: _nutritionDataFuture,
      builder: (context, AsyncSnapshot<List<NutritionDataModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.equalizer_outlined, color: Colors.white54),
                  SizedBox(width: 2),
                  Text(
                    'Soil Nutrition',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildNPKLoadingRow("Nitrogen"),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              _buildNPKLoadingRow("Phosphorous"),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              _buildNPKLoadingRow("Potassium"),
              const Divider(color: Colors.white24),
            ],
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 40),
              const SizedBox(height: 8),
              const Text(
                'Failed to load data',
                style: TextStyle(color: Colors.white54),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _nutritionDataFuture = _fetchNutritionData();
                  });
                },
                child:
                    const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        }

        final data = snapshot.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.equalizer_outlined, color: Colors.white54),
                SizedBox(width: 2),
                Text(
                  'Soil Nutrition',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (data.isNotEmpty) ...[
              NPK(
                  nutrient: 'Nitrogen',
                  value: data.map((e) => e.nitrogen).reduce((a, b) => a + b) /
                      data.length.toInt()),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              NPK(
                  nutrient: 'Phosphorous',
                  value: data.map((e) => e.phosphorus).reduce((a, b) => a + b) /
                      data.length.toInt()),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              NPK(
                  nutrient: 'Potassium',
                  value: data.map((e) => e.potassium).reduce((a, b) => a + b) /
                      data.length.toInt()),
              const Divider(color: Colors.white24),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNPKLoadingRow(String nutrient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nutrient,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: Colors.green[300]!,
          child: Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageChip(String language) {
    bool isSelected = _selectedLanguage == language;

    return ChoiceChip(
      selectedColor: Colors.greenAccent,
      label: Text(
        language,
        style: TextStyle(color: isSelected ? Colors.black : Colors.white54),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedLanguage = language;
          });
          context.pop();
          context.pop();
          _showModalBottomSheet(context);
        }
      },
    );
  }

  Widget _buildResponseSection() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20.0, width: 150.0, color: Colors.grey[300]),
              const SizedBox(height: 8.0),
              Container(height: 20.0, width: 200.0, color: Colors.grey[300]),
              const SizedBox(height: 8.0),
              Container(height: 20.0, width: 180.0, color: Colors.grey[300]),
            ],
          ),
        ),
      );
    } else if (_response.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: MarkdownBody(
          data: _response,
          styleSheet: MarkdownStyleSheet(
            h2: const TextStyle(fontSize: 20, color: Colors.white54),
            p: const TextStyle(fontSize: 16, color: Colors.white),
            strong: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> _submitQuestion(String question) async {
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = '';
    });

    final response = await Gemini().makeApiRequest(question);

    setState(() {
      _isLoading = false;
      _response = response;
    });

    _controller.clear();
    _focusNode.unfocus();
  }
}
