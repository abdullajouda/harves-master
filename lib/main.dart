import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/models/notifications.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/persistent_tab_controller_provider.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/helpers/Localization/appliction.dart';
import 'package:harvest/splash.dart';
import 'package:provider/provider.dart';
import 'customer/models/cart_items.dart';
import 'customer/models/favorite.dart';
import 'customer/models/user.dart';
import 'helpers/Localization/app_translations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'helpers/shared_perfs_provider.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;
  LangProvider _langProvider;

  void onLocaleChange(Locale locale) => setState(
      () => _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale));

  @override
  void initState() {
    application.onLocaleChanged = onLocaleChange;
    _newLocaleDelegate = AppTranslationsDelegate(
      newLocale: Locale('en', 'US'),
    );
    _langProvider = LangProvider();
    String code = _langProvider.getLocaleCode();
    _newLocaleDelegate = AppTranslationsDelegate(
      newLocale: Locale(code, code),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = _newLocaleDelegate.newLocale.languageCode == 'ar';
    // final _statusBarBrightness = context.watch<StatusBarBrighness>().brightness;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
        providers: [
          Provider(create: (context) => PTVController()),
          Provider(create: (context) => ApiHelper()),
          ChangeNotifierProvider(create: (context) => LangProvider()),
          ChangeNotifierProvider(create: (context) => FavoriteOperations()),
          ChangeNotifierProvider(create: (context) => CityOperations()),
          ChangeNotifierProvider(create: (context) => NotificationOperations()),
          ChangeNotifierProvider(create: (context) => UserFunctions()),
          ChangeNotifierProvider(create: (context) => Cart()),
        ],
        child: MaterialApp(
          supportedLocales: application.supportedLocales(),
          locale: _newLocaleDelegate.newLocale,
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            _newLocaleDelegate,
          ],
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Splash(),
        ));
  }
}
