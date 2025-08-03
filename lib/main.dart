import 'package:axis_task/src/core/utils/injections.dart';
import 'package:axis_task/src/core/utils/hive_initializer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:axis_task/src/core/router/router.dart';
import 'package:axis_task/src/features/intro/presentation/pages/intro_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and adapters
  await HiveInitializer.initialize();

  // Inject all dependencies
  await initInjections();

  runApp(
    DevicePreview(
      builder: (context) {
        return const App();
      },
      enabled: false,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  Locale locale = const Locale("en");
  final GlobalKey<ScaffoldMessengerState> snackBarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'TMDB Popular People',
          scaffoldMessengerKey: snackBarKey,
          onGenerateRoute: AppRouter.generateRoute,
      
          debugShowCheckedModeBanner: false,
          locale: locale,
          builder: DevicePreview.appBuilder,
          localizationsDelegates: const [
        
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: navigatorKey,
          supportedLocales: const [Locale("ar"), Locale("en")],
          home: const IntroPage(),
        );
      },
    );
  }
}
