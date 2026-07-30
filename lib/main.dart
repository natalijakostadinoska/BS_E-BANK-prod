import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sf;
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart' as flutter_loc;
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'dart:io';
import 'package:map_launcher/map_launcher.dart';

/// ---------------------------
/// HTTP OVERRIDES
/// ---------------------------
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, String host, int port) => true;
  }
}

/// ---------------------------
/// TRANSLATIONS
/// ---------------------------
const Map<String, Map<String, String>> translations = {
  'en': {
    // Login & Authentication
    'username': 'Username',
    'password': 'Password',
    'login': 'Login',
    'fields_required': 'Username and Password are required',
    'login_failed': 'Invalid username or password',
    'user_not_found': 'User not found or inactive',
    'server_error': 'Server error',
    'auth_required': 'Authentication required',
    'verify_identity': 'Please scan your fingerprint to continue',
    'touch_fingerprint': 'Touch the fingerprint sensor',
    'cancel': 'Cancel',
    'pin': 'PIN',
    'incorrect_pin': 'Incorrect PIN',
    'welcome': 'Welcome',

    // Loans & Maps
    'no_loans': 'You have no loans at the moment',
    'cash_loan': 'Cash Loan',
    'car_loan': 'Car Loan',
    'house_loan': 'House Loan',
    'shop_loan': 'Shop Loan',
    'pc_loan': 'PC Loan',
    'open_in_maps': 'Open the Location in Maps',

    // Navigation & Menu
    'user': 'User',
    'control_panel': 'Control Panel',
    'home': 'Home',
    'exchange_rates': 'Exchange Rates',
    'calendar': 'Calendar',
    'settings': 'Settings',
    'logout': 'Logout',
    'news': 'News',
    'contact': 'Contact',
    'locations': 'Locations',
    'menu': 'Menu',

    // Support & Services
    'customer_support': 'Customer support',
    'questions': 'Questions',
    'visit_website': 'Visit our website',
    'location_services': 'Location services',
    'report_card': 'Report a lost or stolen card 24/7',
    'visit_our_branch': 'View our branch office',
    'contact_us': 'Contact us via e-mail',
    'could_not_launch': 'Could not launch the URL.',
    'error_launching': 'Error launching external app',

    // Settings & PIN Management
    'language': 'Language',
    'select_language': 'Select Language',
    'english': 'English',
    'macedonian': 'Macedonian',
    'change_pin': 'Change PIN',
    'pin_changed_success': 'PIN changed successfully',
    'yes': 'Yes',
    'use_biometrics': 'Use biometrics',
    'application_info': 'Application info',
    'application_name': 'Application name',
    'version': 'Version',
    'developer': 'Application developer',
    'new_pin': 'New PIN',
    'confirm_pin': 'Confirm PIN',
    'pin_4_digits': 'PIN must be 4 digits',
    'pin_mismatch': 'PINs do not match',
    'success': 'Success',

    // Loan details
    'loan': 'Loan',
    'loans': 'Loans',
    'party': 'Party',
    'contract_no': 'Contract Number',
    'approval_date': 'Approval Date',
    'currency': 'Currency',
    'approved_amount': 'Approved Amount',
    'approved_amount_mkd': 'Approved Amount in MKD',
    'due_date': 'Due Date',
    'payment_list': 'Payment List',
    'no_payments': 'No payments made',
    'amortization_plan': 'Amortization Plan',
    'close': 'Close',
    'ref_number': 'Reference Number',
    'next_payment_amount': 'Next payment amount',
    'interest_rate': 'Annual interest rate',
    'transaction_account': 'Loan Party',
    'undue_principal': 'Undue Principal',
    'due_principal': 'Due Principal',
    'undue_interest': 'Undue Interest',
    'due_interest': 'Due Interest',
    'due_penalty_interest': 'Due Penalty Interest',
    'undue_penalty_interest': 'Undue Penalty Interest',
    'due_commission': 'Due Commission',

    'confirm_logout_msg': 'Do you want to logout?',
    'confirm_exit_msg': 'Do you want to exit the app?',
    'confirm_action': 'Confirm',

    // Lockout
    'account_paused': 'Account is paused for 5 minutes due to too many failed attempts.',
    'try_again_in': 'Please try again in',
    'minutes': 'minutes',
    'seconds': 'seconds',

    // Calendar
    'new_event': 'New Event',
    'edit_event': 'Edit Event',
    'title': 'Title',
    'title_req': 'Title is required',
    'description': 'Description',
    'type': 'Type',
    'once': 'Once',
    'weekly': 'Weekly',
    'monthly': 'Monthly',
    'yearly': 'Yearly',
    'add_event': 'Add Event',
    'update_event': 'Update Event',
    'delete_event': 'Delete Event',
    'delete_confirm': 'Permanently remove this event?',
    'save_changes': 'Save changes?',
    'create_event': 'Create this event?',
    'conn_error': 'Connection Error',

    //Deposits
    'deposits': 'Deposits',
    'deposit_time_mkd': 'Time deposit in MKD',
    'deposit_sight': 'Sight deposit',
    'deposit_children': 'Children\'s savings',
    'months': 'months',
    'flexible': 'Flexible',
    'interest_label': 'Interest',
    'period_label': 'Period',
  },
  'mk': {
    // Најава и Автентикација
    'username': 'Корисничко име',
    'password': 'Лозинка',
    'login': 'Најава',
    'fields_required': 'Корисничкото име и лозинката се задолжителни',
    'login_failed': 'Неточно корисничко име или лозинка',
    'user_not_found': 'Корисникот не е пронајден или е неактивен',
    'server_error': 'Грешка на серверот',

    // Updated Popup Lines
    'auth_required': 'Потребна е потврда',
    'verify_identity': 'Ве молиме скенирајте го вашиот оттисок',
    'touch_fingerprint': 'Допрете го сензорот',
    'cancel': 'Откажи',

    'pin': 'ПИН',
    'incorrect_pin': 'Невалиден ПИН',
    'welcome': 'Добредојдовте',

    // Кредити и Локации
    'no_loans': 'Во моментов немате кредити',
    'cash_loan': 'Кеш кредит',
    'car_loan': 'Кредит за автомобил',
    'house_loan': 'Кредит за куќа',
    'shop_loan': 'Кредит за продавница',
    'pc_loan': 'Кредит за компјутер',
    'open_in_maps': 'Отвори ја локацијата во Мапа',

    // Навигација и Мени
    'user': 'Корисник',
    'control_panel': 'Контролен панел',
    'home': 'Дома',
    'exchange_rates': 'Курсна листа',
    'calendar': 'Календар',
    'settings': 'Поставки',
    'logout': 'Одјави се',
    'news': 'Новости',
    'contact': 'Контакт',
    'locations': 'Локации',
    'menu': 'Мени',

    // Поддршка и Услуги
    'customer_support': 'Корисничка поддршка',
    'questions': 'Прашања',
    'visit_website': 'Посетете ја нашата веб страна',
    'location_services': 'Локациски услуги',
    'report_card': 'Пријавете изгубена или украдена картичка 24/7',
    'visit_our_branch': 'Посета на нашата експозитура',
    'contact_us': 'Контактирајте не преку е-пошта',
    'could_not_launch': 'Не може да се отвори URL.',
    'error_launching': 'Грешка при отворање на апликацијата',

    // Поставки и ПИН
    'language': 'Јазик',
    'select_language': 'Изберете јазик',
    'english': 'Англиски',
    'macedonian': 'Македонски',
    'change_pin': 'Смени ПИН',
    'pin_changed_success': 'ПИН успешно сменет',
    'yes': 'Да',
    'use_biometrics': 'Користи биометрија',
    'application_info': 'Информации за апликацијата',
    'application_name': 'Име на апликацијата',
    'version': 'Верзија',
    'developer': 'Развој на апликацијата',
    'new_pin': 'Нов ПИН',
    'confirm_pin': 'Потвди ПИН',
    'pin_4_digits': 'ПИН-от мора да има 4 цифри',
    'pin_mismatch': 'ПИН-овите не се совпаѓаат',
    'success': 'Успешно',

    // Детали за кредит
    'loan': 'Кредит',
    'loans': 'Кредити',
    'party': 'Партија',
    'contract_no': 'Бр. на договор',
    'approval_date': 'Датум на одобрување',
    'currency': 'Валута',
    'approved_amount': 'Одобрен Износ',
    'approved_amount_mkd': 'Одобрен Износ во МКД',
    'due_date': 'Датум на доспевање',
    'payment_list': 'Список на уплати',
    'no_payments': 'Не се направени уплати',
    'amortization_plan': 'Амортизациски план',
    'close': 'Затвори',
    'ref_number': 'Референтен број',
    'next_payment_amount': 'Следен износ на отплата',
    'interest_rate': 'Годишна каматна стапка',
    'transaction_account': 'Кредитна партија',
    'undue_principal': 'Недоспеана Главница',
    'due_principal': 'Доспеана главница',
    'undue_interest': 'Недоспеана камата',
    'due_interest': 'Доспеана камата',
    'due_penalty_interest': 'Доспеана казнена камата',
    'undue_penalty_interest': 'Недоспеана казнена камата',
    'due_commission': 'Доспеана провизија',

    'confirm_logout_msg': 'Дали сакате да се одјавите?',
    'confirm_exit_msg': 'Дали сакате да ја затворите апликацијата?',
    'confirm_action': 'Потврди',

    // 5 минути заклучен корисник
    'account_paused': 'Акаунтот е паузиран 5 минути поради премногу неуспешни обиди.',
    'try_again_in': 'Обидете се повторно за',
    'minutes': 'минути',
    'seconds': 'секунди',

    // Календар
    'new_event': 'Нов Настан',
    'edit_event': 'Уреди Настан',
    'title': 'Наслов',
    'title_req': 'Насловот е задолжителен',
    'description': 'Опис',
    'type': 'Тип',
    'once': 'Еднаш',
    'weekly': 'Неделно',
    'monthly': 'Месечно',
    'yearly': 'Годишно',
    'add_event': 'Додај Настан',
    'update_event': 'Промени Настан',
    'delete_event': 'Избриши Настан',
    'delete_confirm': 'Трајно отстрани го овој настан?',
    'save_changes': 'Зачувај промени?',
    'create_event': 'Креирај го овој настан?',
    'conn_error': 'Проблем со конекцијата',

    //Позајмици
    'deposits': 'Позајмици',
    'deposit_time_mkd': 'Орочен депозит во МКД',
    'deposit_sight': 'Депозит по видување',
    'deposit_children': 'Детско штедење',
    'months': 'месеци',
    'flexible': 'Флексибилно',
    'interest_label': 'Камата',
    'period_label': 'Рок',
  },
};


/// ---------------------------
/// MAPS PICKER (Apple Maps + others)
/// ---------------------------
Future<void> openMapsPicker(
    BuildContext context, {
      required double lat,
      required double lng,
      required String title,
      required String address,
    }) async {
  try {
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isEmpty) {
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    if (availableMaps.length == 1) {
      await availableMaps.first.showMarker(
        coords: Coords(lat, lng),
        title: title,
        description: address,
      );
      return;
    }

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: availableMaps.map((map) {
              return ListTile(
                leading: Image.asset(
                  map.icon,
                  height: 30,
                  width: 30,
                  package: 'map_launcher',
                ),
                title: Text(map.mapName),
                onTap: () async {
                  Navigator.pop(ctx);
                  await map.showMarker(
                    coords: Coords(lat, lng),
                    title: title,
                    description: address,
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  } catch (e) {
    debugPrint('Map launcher error: $e');
  }
}

/// ---------------------------
/// TRANSLATION HELPER
/// ---------------------------
String t(BuildContext context, String key) {
  final user = Provider.of<SPDUser>(context, listen: false);
  return translations[user.currentLanguage]?[key] ?? key;
}

/// ---------------------------
/// LOANS VIEW
/// ---------------------------
class LoansView extends StatefulWidget {
  final String userId;
  const LoansView({super.key, required this.userId});

  @override
  State<LoansView> createState() => _LoansViewState();
}

class _LoansViewState extends State<LoansView> {
  Future<List<Map<String, String>>>? _loansFuture;

  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _loansFuture = fetchLoans(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, 'loans')),
        elevation: 1,
        titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _loansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${t(context, 'error_launching')}'));
          }

          final loans = snapshot.data ?? [];
          if (loans.isEmpty) {
            return Center(child: Text(t(context, 'no_loans')));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _buildLoanCard(context, loan);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoanCard(BuildContext context, Map<String, String> loan) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(Icons.payments_outlined, color: Colors.blue),
        ),
        title: Text(
          loan['PRODUCT_NAME'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoanDetailsView(loanData: loan),
            ),
          );
        },
      ),
    );
  }
}

/// ---------------------------
/// DEPOSIT VIEW
/// ---------------------------
// class DepositsView extends StatelessWidget {
//   const DepositsView({super.key});
//
//
//   String t(BuildContext context, String key) {
//     final user = Provider.of<SPDUser>(context, listen: false);
//     return translations[user.currentLanguage]?[key] ?? key;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<SPDUser>(context);
//     final lang = user.currentLanguage ?? 'en';
//
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(t(context, 'deposits')),
//         centerTitle: false,
//         elevation: 1,
//         titleTextStyle: TextStyle(
//             color: colorScheme.onSurface,
//             fontSize: 20,
//             fontWeight: FontWeight.bold
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           _buildDepositCard(
//             context,
//             title: t(context, 'deposit_time_mkd'),
//             interest: "2.5%",
//             period: "12 ${t(context, 'months')}",
//             icon: Icons.savings_outlined,
//           ),
//           _buildDepositCard(
//             context,
//             title: t(context, 'deposit_sight'),
//             interest: "0.1%",
//             period: t(context, 'flexible'),
//             icon: Icons.account_balance_wallet_outlined,
//           ),
//           _buildDepositCard(
//             context,
//             title: t(context, 'deposit_children'),
//             interest: "3.0%",
//             period: "24 ${t(context, 'months')}",
//             icon: Icons.child_care,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDepositCard(BuildContext context,
//       {required String title, required String interest, required String period, required IconData icon}) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         leading: CircleAvatar(
//           backgroundColor: Colors.blue.withOpacity(0.1),
//           child: Icon(icon, color: Colors.blue),
//         ),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text("${t(context, 'interest_label')}: $interest | ${t(context, 'period_label')}: $period"),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {
//         },
//       ),
//     );
//   }
// }

/// ---------------------------
/// CONTACTVIEW
/// ---------------------------
class ContactView extends StatelessWidget {
  const ContactView({super.key});

  static const Map<String, String> contacts = {
    'customer_support': 'tel:023166466',
    'questions': 'mailto:info@fkcbs.com.mk',
    'visit_website': 'https://fkcbs.com.mk/',
    'report_card': 'tel: 02 316 6466',
  };

  Future<void> _openUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t(context, 'could_not_launch'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t(context, 'error_launching'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get current theme info
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // 2. Define Styles (Removed 'const' because Theme.of is dynamic)
    final TextStyle subtitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      // 'onSurface' is white in dark mode and black in light mode
      color: colorScheme.onSurface.withOpacity(0.7),
    );

    // Dynamic color for the "Report Card" section
    final Color dangerColor = isDark ? Colors.redAccent : const Color(0xFFD32F2F);
    final Color dangerBg = isDark ? Colors.red.withOpacity(0.15) : const Color(0xFFFFEBEE);

    return Scaffold(
      // The background will automatically adjust (White/Dark) based on MaterialApp theme
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            leading: const Icon(Icons.support_agent_outlined, size: 32),
            title: Text(t(context, 'customer_support')),
            subtitle: Text('02 3166 466', style: subtitleStyle),
            trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
            onTap: () => _openUrl(contacts['customer_support']!, context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.web_outlined, size: 32),
            title: Text(t(context, 'visit_website')),
            subtitle: Text('https://fkcbs.com.mk/', style: subtitleStyle),
            trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
            onTap: () => _openUrl(contacts['visit_website']!, context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on_outlined, size: 32),
            title: Text(t(context, 'location_services')),
            subtitle: Text(t(context, 'visit_our_branch'), style: subtitleStyle),
            trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
            onTap: () => openMapsPicker(
              context,
              lat: 41.9919649,
              lng: 21.4327494,
              title: 'FD - Financial Credit Center BS',
              address: 'Ул. Даме Груев, блок 1, 1000 Скопје',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email_outlined, size: 32),
            title: Text(t(context, 'questions')),
            subtitle: Text(t(context, 'contact_us'), style: subtitleStyle),
            trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
            onTap: () => _openUrl(contacts['questions']!, context),
          ),
          const Divider(),

          // Emergency/Report Section
          Container(
            decoration: BoxDecoration(
              color: dangerBg,
              borderRadius: BorderRadius.circular(8), // Adds a nice touch
            ),
            child: ListTile(
              leading: Icon(
                  Icons.report_problem_outlined,
                  size: 32,
                  color: dangerColor
              ),
              title: Text(
                t(context, 'report_card'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: dangerColor,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: dangerColor),
              onTap: () => _openUrl(contacts['report_card']!, context),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

/// ---------------------------
/// NEWSVIEW
///---------------------------
class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://fkcbs.com.mk/%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8/'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: WebViewWidget(controller: _controller));
  }
}

/// ---------------------------
/// HOMEVIEW
/// ---------------------------
class HomeView extends StatefulWidget {
  final String? userId;
  final String? username;
  const HomeView({super.key, this.userId, this.username});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<Map<String, String>>>? _loansFuture;

  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loansFuture == null) {
      _loansFuture = widget.userId != null ? fetchLoans(widget.userId!) : Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              title: t(context, 'loans'),
              icon: Icons.payments_outlined,
              color: Colors.blue.shade800
          ),

          FutureBuilder<List<Map<String, String>>>(
            future: _loansFuture,
            builder: (context, snapshot) {
              return LoanView(
                data: snapshot.data ?? [],
                connectionState: snapshot.connectionState,
                lang: user.currentLanguage,
              );
            },
          ),

          // const SizedBox(height: 20),
          //
          // _buildSectionHeader(
          //     title: t(context, 'deposits'),
          //     icon: Icons.savings_outlined,
          //     color: Colors.teal.shade700
          // ),

          // SizedBox(
          //   height: 220,
          //   child: PageView(
          //     controller: PageController(viewportFraction: 0.9),
          //     children: [
          //       _buildDepositItem(
          //         title: t(context, 'deposit_time_mkd'),
          //         interest: "2.5%",
          //         period: "12 ${t(context, 'months')}",
          //         colors: [Colors.teal.shade800, Colors.teal.shade400],
          //       ),
          //       _buildDepositItem(
          //         title: t(context, 'deposit_children'),
          //         interest: "3.0%",
          //         period: "24 ${t(context, 'months')}",
          //         colors: [Colors.orange.shade800, Colors.orange.shade400],
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanItem(Map<String, String> loan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade600]),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.account_balance, color: Colors.white, size: 30),
            Text(loan['PRODUCT_NAME'] ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(loan['ACCOUNT_NUMBER'] ?? '',
                style: const TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }
  Widget _buildDepositItem({
    required String title,
    required String interest,
    required String period,
    required List<Color> colors
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.savings_outlined, color: Colors.white, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      t(context, 'deposits').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    interest,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${t(context, 'period_label')}: $period",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// LOCATIONSVIEW
/// ---------------------------
class LocationsView extends StatelessWidget {
  const LocationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset('assets/images/map_bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.location_on_outlined),
              label: Text(
                translations[SPDUser.current.currentLanguage]!['open_in_maps']!,
              ),
              onPressed: () => openMapsPicker(
                context,
                lat: 41.9919649,
                lng: 21.4327494,
                title: 'FD - Financial Credit Center BS',
                address: 'Ul. Dame Gruev, blok 1, 1000 Skopje',
              ),
            ),
          )
        ],
      ),
    );
  }
}


