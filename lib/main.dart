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
    'transaction_account': 'Transaction account',
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
    'transaction_account': 'Трансакциска сметка',
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
class DepositsView extends StatelessWidget {
  const DepositsView({super.key});


  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage ?? 'en';

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, 'deposits')),
        centerTitle: false,
        elevation: 1,
        titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDepositCard(
            context,
            title: t(context, 'deposit_time_mkd'),
            interest: "2.5%",
            period: "12 ${t(context, 'months')}",
            icon: Icons.savings_outlined,
          ),
          _buildDepositCard(
            context,
            title: t(context, 'deposit_sight'),
            interest: "0.1%",
            period: t(context, 'flexible'),
            icon: Icons.account_balance_wallet_outlined,
          ),
          _buildDepositCard(
            context,
            title: t(context, 'deposit_children'),
            interest: "3.0%",
            period: "24 ${t(context, 'months')}",
            icon: Icons.child_care,
          ),
        ],
      ),
    );
  }

  Widget _buildDepositCard(BuildContext context,
      {required String title, required String interest, required String period, required IconData icon}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${t(context, 'interest_label')}: $interest | ${t(context, 'period_label')}: $period"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
        },
      ),
    );
  }
}

/// ---------------------------
/// CONTACTVIEW
/// ---------------------------
class ContactView extends StatelessWidget {
  const ContactView({super.key});

  static const Map<String, String> contacts = {
    'customer_support': 'tel:023166466',
    'questions': 'mailto:info@fkcbs.com.mk',
    'visit_website': 'https://fkcbs.com.mk/',
    'location_services': 'https://www.google.com/maps/search/?api=1&query=Ул.+Даме+Груев,+блок+1,+1000+Скопје',
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
            onTap: () => _openUrl(contacts['location_services']!, context),
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

          const SizedBox(height: 20),

          _buildSectionHeader(
              title: t(context, 'deposits'),
              icon: Icons.savings_outlined,
              color: Colors.teal.shade700
          ),

          SizedBox(
            height: 220,
            child: PageView(
              controller: PageController(viewportFraction: 0.9),
              children: [
                _buildDepositItem(
                  title: t(context, 'deposit_time_mkd'),
                  interest: "2.5%",
                  period: "12 ${t(context, 'months')}",
                  colors: [Colors.teal.shade800, Colors.teal.shade400],
                ),
                _buildDepositItem(
                  title: t(context, 'deposit_children'),
                  interest: "3.0%",
                  period: "24 ${t(context, 'months')}",
                  colors: [Colors.orange.shade800, Colors.orange.shade400],
                ),
              ],
            ),
          ),
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

  static const String _mapsUrl =
      'https://www.google.com/maps/search/?api=1&query=Ул.+Даме+Груев,+блок+1,+1000+Скопје';

  Future<void> _openMap(BuildContext context) async {
    final Uri uri = Uri.parse(_mapsUrl);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the map.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error launching external app')),
      );
    }
  }

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
              onPressed: () => _openMap(context),
            ),
          )
        ],
      ),
    );
  }
}

/// ---------------------------
/// LOAN
/// ---------------------------
class Loan {
  final String title;
  final double amount;

  Loan({
    required this.title,
    required this.amount,
  });
}

/// ---------------------------
/// LOGIN SCREEN
/// ---------------------------
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;
  bool _loading = false;

  // Track WHICH user is actually paused
  String? _lockedUsername;
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;

  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // 1. CHECK IF CURRENTLY PAUSED (Only if it's the SAME username that was locked)
    if (_lockoutUntil != null &&
        _lockedUsername == username &&
        DateTime.now().isBefore(_lockoutUntil!)) {

      final diff = _lockoutUntil!.difference(DateTime.now());
      final minutes = diff.inMinutes;
      final seconds = diff.inSeconds % 60;

      setState(() {
        _error = "${t(context, 'account_paused')} ${t(context, 'try_again_in')} $minutes ${t(context, 'minutes')} $seconds ${t(context, 'seconds')}";
      });
      return;
    }

    if (username.isEmpty || password.isEmpty) {
      setState(() => _error = t(context, 'fields_required'));
      return;
    }

    setState(() { _error = null; _loading = true; });

    try {
      final response = await http.post(
        Uri.parse("https://epay.fkcbs.com.mk/loginAPIprod.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _failedAttempts = 0;
        _lockoutUntil = null;
        _lockedUsername = null; // Clear on success

        final String uId = data['userId'].toString();
        final String loggedInCustId = data['crCustId'].toString();
        final userProvider = Provider.of<SPDUser>(context, listen: false);
        userProvider.setUserData(uId);

        final prefs = await SharedPreferences.getInstance();
        String savedPin = prefs.getString('user_${uId}_pin') ?? "0000";

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PinGateScreen(
              correctPin: savedPin,
              userId: loggedInCustId,
              username: data['username'] ?? username,
            ),
          ),
        );
      } else {
        _failedAttempts++;

        if (_failedAttempts >= 3) {
          _lockoutUntil = DateTime.now().add(const Duration(minutes: 5));
          _lockedUsername = username; // Assign the lockout to THIS specific username
          _failedAttempts = 0;
          setState(() => _error = t(context, 'account_paused'));
        } else {
          setState(() => _error = t(context, data['message'] ?? 'login_failed'));
        }
      }
    } catch (e) {
      setState(() => _error = "Connection Error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            // Switch based on the current mode
            isDark
                ? 'assets/images/logo-spd-big-white.png'
                : 'assets/images/logo-spd-big.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => SPDDialog.showLanguageDialog(context),
              child: Image.asset(
                lang == 'mk' ? 'assets/images/langs/mk.png' : 'assets/images/langs/en.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo-bs-small.jpg', height: 100, fit: BoxFit.contain),
              const SizedBox(height: 100),
              TextField(
                controller: _usernameController,
                onChanged: (val) {
                  // If we start typing and the error matches the "Paused" state,
                  // we only hide the error text; the logic in _login handles
                  // the actual blocking if they try to submit the locked name.
                  if (_error != null) {
                    setState(() {
                      _error = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: t(context, 'username'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                decoration: InputDecoration(
                  labelText: t(context, 'password'),
                  border: const OutlineInputBorder(),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(t(context, 'login')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------
/// PIN SCREEN / BIOMETRICS
/// ---------------------------
class PinGateScreen extends StatefulWidget {
  final String correctPin;
  final String userId;
  final String username;

  const PinGateScreen({
    super.key,
    required this.correctPin,
    required this.userId,
    required this.username,
  });

  @override
  State<PinGateScreen> createState() => _PinGateScreenState();
}

class _PinGateScreenState extends State<PinGateScreen> {
  String enteredPin = '';
  String? error;
  final LocalAuthentication _auth = LocalAuthentication();

  // Helper function for translations
  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _checkBioPreference();
  }

  Future<void> _checkBioPreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool isBioEnabled = prefs.getBool('bio_enabled_${widget.userId}') ?? false;

    if (isBioEnabled) {
      // Direct call to system biometric prompt
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _authenticate();
      });
    }
  }

  Future<void> _authenticate() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck && !isSupported) return;

      // Use direct parameters instead of the 'options' object
      final bool authenticated = await _auth.authenticate(
        localizedReason: t(context, 'verify_identity'),
        // Remove 'options: const AuthenticationOptions('
        biometricOnly: true,
        ///stickyAuth: true,
      );

      if (authenticated && mounted) {
        _navigateToMain();
      }
    } catch (e) {
      debugPrint('Biometric error: $e');
    }
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainView(
          userId: widget.userId,
          username: widget.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            // Switch based on the current mode
            isDark
                ? 'assets/images/logo-spd-big-white.png'
                : 'assets/images/logo-spd-big.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => SPDDialog.showLanguageDialog(context),
              child: Image.asset(
                lang == 'mk' ? 'assets/images/langs/mk.png' : 'assets/images/langs/en.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo-bs-small.jpg', height: 100, fit: BoxFit.contain),
              const SizedBox(height: 100),
              TextField(
                autofocus: true,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (v) => setState(() => enteredPin = v),
                decoration: InputDecoration(
                  labelText: t(context, 'pin'),
                  border: const OutlineInputBorder(),
                  // Now calls the official system prompt directly
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.fingerprint, color: Colors.blue, size: 30),
                    onPressed: _authenticate,
                  ),
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(error!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (enteredPin == widget.correctPin) {
                      _navigateToMain();
                    } else {
                      setState(() => error = t(context, 'incorrect_pin'));
                    }
                  },
                  child: Text(t(context, 'login')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------
/// SPDMenu
/// ---------------------------
class SPDMenu extends StatelessWidget {
  final List<Widget> children;
  const SPDMenu({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: children),
    );
  }
}

/// ---------------------------
/// SPDMenuItem
/// ---------------------------
class SPDMenuItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final VoidCallback onTap;

  const SPDMenuItem({required this.leading, required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: title,
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}

/// ---------------------------
/// SPDMenuGroup
/// ---------------------------
class SPDMenuGroup extends StatelessWidget {
  final List<SPDMenuGroupItem> items;
  const SPDMenuGroup({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: items);
  }
}

/// ---------------------------
/// SPDMenuGroupItem
/// ---------------------------
class SPDMenuGroupItem extends StatelessWidget {
  final String value;
  final Widget icon;
  final Widget title;
  final List<SPDMenuItem> items;

  const SPDMenuGroupItem({required this.value, required this.icon, required this.title, required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: icon,
      title: title,
      children: items,
    );
  }
}

/// ---------------------------
/// SPDAppBar
/// ---------------------------
PreferredSizeWidget SPDAppBar(BuildContext context, {required Widget title}) {
  return AppBar(
    title: Image.asset(
      'assets/images/logo-spd-big.png',
      width: 150,
      height: 40,
      fit: BoxFit.contain,
    ),
  );
}

/// ---------------------------
/// MAINAPP
/// ---------------------------
Future<void> main() async {
  // This line tells Flutter to use your custom 'MyHttpOverrides' class
  // which ignores the "Unable to verify certificate" error.
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await SPDUser.init();

  runApp(
    ChangeNotifierProvider<SPDUser>.value(
      value: SPDUser.current,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final String lang = user.currentLanguage ?? 'en';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(lang),
      supportedLocales: const [
        Locale('en'),
        Locale('mk'),
      ],
      localizationsDelegates: const [
        flutter_loc.GlobalMaterialLocalizations.delegate,
        flutter_loc.GlobalWidgetsLocalizations.delegate,
        flutter_loc.GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],

      // --- THEME SECTION START ---

      // 1. Light Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue, // Change this to your bank's primary color
      ),

      // 2. Dark Theme Configuration
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue, // Keep the seed the same for brand consistency
      ),

      // 3. Follow the System Setting (this makes it "automatic")
      themeMode: ThemeMode.system,

      // --- THEME SECTION END ---

      home: const LoginView(),
    );
  }
}

/// ---------------------------
/// MAINVIEW
/// ---------------------------
class MainView extends StatefulWidget {
  final String userId;
  final String username;
  static const int initialTabIndex = 2; // Default to 'Home'

  const MainView({super.key, required this.userId, required this.username});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        vsync: this,
        length: 5,
        initialIndex: MainView.initialTabIndex
    );
    tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void changeView({required int tabIndex}) {
    if (tabIndex == 4) {
      scaffoldKey.currentState?.openEndDrawer();
    } else {
      tabController.animateTo(tabIndex);
    }
    setState(() {});
  }

  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  List<Widget> menuItems() {
    final user = Provider.of<SPDUser>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset( isDark
                ? 'assets/images/logo-spd-big-white.png'
                : 'assets/images/logo-spd-big.png',
              fit: BoxFit.contain,
            ),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
      SPDMenuItem(
        leading: const Icon(Icons.person),
        title: Text(" ${widget.username}"),
        onTap: () => Navigator.pop(context),
      ),
      SPDMenuGroup(items: [
        SPDMenuGroupItem(
          value: 'Menu_ControlPanel',
          icon: const Icon(Icons.rocket_launch_outlined),
          title: Text(t(context, 'control_panel')),
          items: [
            SPDMenuItem(
              leading: const Icon(Icons.home_outlined),
              title: Text(t(context, 'home')),
              onTap: () { Navigator.pop(context); changeView(tabIndex: 2); },
            ),
            /// ===================== НОВО: Кредити =====================
            SPDMenuItem(
              leading: const Icon(Icons.payments_outlined),
              title: Text(t(context, 'loans')),
              onTap: () {
                Navigator.pop(context); // Го затвора drawer-от
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LoansView(userId: widget.userId) // Праќаме userId
                    )
                );
              },
            ),
            /// ===================== НОВО: Позајмици =====================
            SPDMenuItem(
              leading: const Icon(Icons.savings_outlined),
              title: Text(t(context, 'deposits')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DepositsView())
                );
              },
            ),
            SPDMenuItem(
              leading: const Icon(Icons.currency_exchange_outlined),
              // This now calls the translation helper every time the UI paints
              title: Text(t(context, 'exchange_rates')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExchangeRatesView()));
              },
            ),

            /// ===================== ADDED CALENDAR ITEM =====================
            SPDMenuItem(
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(t(context, 'calendar')), // Make sure 'calendar' is in your translations
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarView())
                );
              },
            ),
            /// ==============================================================
          ],
        ),
      ]),
      const Divider(),
      SPDMenuItem(
        leading: const Icon(Icons.language_outlined),
        title: Text(t(context, 'language')),
        onTap: () { Navigator.pop(context); SPDDialog.showLanguageDialog(context); },
      ),
      SPDMenuItem(
        leading: const Icon(Icons.settings_outlined),
        title: Text(t(context, 'settings')),
        onTap: () { Navigator.pop(context);
        // Inside your MainView or wherever you open Settings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsView(userId: widget.userId), // widget.userId comes from MainView
          ),
        ); },
      ),
      SPDMenuItem(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: Text(t(context, 'logout')),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          SPDDialog.showLogoutDialog(context, () async {
            final user = Provider.of<SPDUser>(context, listen: false);
            await user.logout();

            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
              );
            }
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            // Switch based on the current mode
            isDark
                ? 'assets/images/logo-spd-big-white.png'
                : 'assets/images/logo-spd-big.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => SPDDialog.showLanguageDialog(context),
              child: Image.asset(
                user.currentLanguage == 'mk' ? 'assets/images/langs/mk.png' : 'assets/images/langs/en.png',
                width: 35, height: 35,
              ),
            ),
          ),
        ],
      ),
      endDrawer: SPDMenu(children: menuItems()),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const NewsView(),
          const ContactView(),
          HomeView(userId: widget.userId, username: widget.username),
          const LocationsView(),
          const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabController.index,
        onTap: (index) => changeView(tabIndex: index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Change to your primary color
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), label: t(context, 'news')),
          BottomNavigationBarItem(icon: const Icon(Icons.phone_outlined), label: t(context, 'contact')),
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: t(context, 'home')),
          BottomNavigationBarItem(icon: const Icon(Icons.location_on_outlined), label: t(context, 'locations')),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_outlined), label: t(context, 'menu')),
        ],
      ),
    );
  }
}

/// ---------------------------
/// LOANVIEW
/// ---------------------------
class LoanView extends StatelessWidget {
  final List<dynamic> data;
  final ConnectionState connectionState;
  final String lang;

  const LoanView({
    required this.data,
    required this.connectionState,
    required this.lang,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (connectionState == ConnectionState.waiting) {
      return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
    }

    if (data.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(child: Text(t(context, 'no_loans'))),
      );
    }

    return SizedBox(
      height: 230,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9, initialPage: 0),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildLoanCarouselCard(context, data[index]);
        },
      ),
    );
  }

  Widget _buildLoanCarouselCard(BuildContext context, dynamic loan) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoanDetailsView(loanData: loan),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.blue.shade900, Colors.blueGrey.shade800]
                  : [Colors.blue.shade800, Colors.blue.shade500],
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
                      const Icon(Icons.account_balance, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        t(context, 'loans').toUpperCase(),
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
                      "${loan['CURR'] ?? ''}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                loan['PRODUCT_NAME'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
                    loan['ACCOUNT_NUMBER'] ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoanViewCard extends StatelessWidget {
  final Loan loan;

  const LoanViewCard({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        title: Text(
          loan.title,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        subtitle: Text(
          loan.amount.toString(),
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// ---------------------------
/// EXCHANGERATESVIEW
/// ---------------------------
class ExchangeRatesView extends StatefulWidget {
  const ExchangeRatesView({super.key});

  @override
  State<ExchangeRatesView> createState() => _ExchangeRatesViewState();
}

class _ExchangeRatesViewState extends State<ExchangeRatesView> {
  late Future<List<dynamic>> _ratesFuture;

  @override
  void initState() {
    super.initState();
    _ratesFuture = fetchRates();
  }

  Future<List<dynamic>> fetchRates() async {
    final date = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final url =
        'https://www.nbrm.mk/KLServiceNOV/GetExchangeRate?StartDate=$date&EndDate=$date&format=json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to load rates');
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<void> refreshData() async {
    setState(() {
      _ratesFuture = fetchRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage ?? 'en';

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(translations[lang]?['exchange_rates'] ?? 'Exchange Rates'),
        centerTitle: false,
        elevation: 1,
        // Text color adjusts automatically to the background
        titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<dynamic>>(
          future: _ratesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                    '${translations[lang]?['server_error'] ?? 'Error'}: ${snapshot.error}',
                    style: TextStyle(color: colorScheme.onSurface),
                  )
              );
            }
            final rates = snapshot.data ?? [];
            return ListView.separated(
              itemCount: rates.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = rates[index];
                final oznaka = item['oznaka'] ?? '';
                final naziv = lang == 'mk' ? (item['naziv'] ?? '') : (item['nazivAng'] ?? '');
                final drzava = lang == 'mk' ? (item['drzava'] ?? '') : (item['drzavaAng'] ?? '');
                final rate = item['sreden']?.toString() ?? '';

                return ListTile(
                  leading: CircleAvatar(
                    // Kept as white for both modes
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/currencies/${oznaka.toUpperCase()}.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            oznaka.isNotEmpty ? oznaka : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black, // Dark text on white circle
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    '$naziv ($oznaka)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    drzava,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  trailing: Text(
                    rate,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: 16
                    ),
                  ),
                );
              },
            );

          },
        ),
      ),
    );
  }
}

/// ---------------------------
/// SETTINGS
/// ---------------------------
class SettingsView extends StatefulWidget {

  final String userId; // Add this line
  // Add userId to the constructor
  const SettingsView({super.key, required this.userId});


  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool useBiometrics = false;
  bool _isBioEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Make sure to use the same key format: bio_enabled_{userId}
      _isBioEnabled = prefs.getBool('bio_enabled_${widget.userId}') ?? false;
    });
  }

  _toggleBio(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bio_enabled_${widget.userId}', value);
    setState(() {
      _isBioEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage ?? 'en'; // fallback to English

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(translations[lang]?['settings'] ?? 'Settings'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          // Language section
          SPDMenuItem(
            leading: const Icon(Icons.language_outlined),
            title: Text(translations[lang]?['language'] ?? 'Language'),
            onTap: () {
              final user = Provider.of<SPDUser>(context, listen: false);
              final lang = user.currentLanguage;

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog( // Use 'ctx' for the dialog context
                  title: Text(translations[lang]?['select_language'] ?? 'Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ENGLISH OPTION
                      ListTile(
                        leading: Image.asset('assets/images/langs/en.png', width: 32, height: 32),
                        title: Text(translations[lang]?['english'] ?? 'English'),
                        onTap: () {
                          user.setLanguage('en');
                          Navigator.pop(ctx); // Use ctx to close the dialog
                        },
                      ),
                      const Divider(),
                      // MACEDONIAN OPTION
                      ListTile(
                        leading: Image.asset('assets/images/langs/mk.png', width: 32, height: 32),
                        title: Text(translations[lang]?['macedonian'] ?? 'Macedonian'),
                        onTap: () {
                          user.setLanguage('mk');
                          Navigator.pop(ctx); // Use ctx to close the dialog
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),



          /// Change PIN
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(translations[lang]?['change_pin'] ?? 'Change PIN'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePinView()),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(translations[lang]?['pin_changed_success'] ?? 'PIN changed successfully')),
                );
              }
            },
          ),

          // Use biometrics
          SwitchListTile(
            title: Text(t(context, 'use_biometrics')),
            secondary: const Icon(Icons.fingerprint),
            value: _isBioEnabled,
            onChanged: (bool value) => _toggleBio(value),
          ),
          const Divider(),

          // Application info
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(translations[lang]?['application_info'] ?? 'Application info'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ApplicationInfoView(lang: lang),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ---------------------------
/// APPLICATIONINFOVIEW
/// ---------------------------
class ApplicationInfoView extends StatelessWidget {
  final String lang;

  const ApplicationInfoView({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(translations[lang]?['application_info'] ?? 'Application info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Application Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translations[lang]?['application_name'] ?? 'Application name',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text("BS E-Bank"),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),

            // Version
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translations[lang]?['version'] ?? 'Version',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text("1.0.0"),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),

            // Developer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translations[lang]?['developer'] ?? 'Application developer',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text("Software Pro Design"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// CHANGE PIN SCREEN
/// ---------------------------
class ChangePinView extends StatefulWidget {
  const ChangePinView({super.key});

  @override
  State<ChangePinView> createState() => _ChangePinViewState();
}

class _ChangePinViewState extends State<ChangePinView> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  String? _error;

  // Helper to fetch translations based on current language
  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  void _changePin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();
    final user = Provider.of<SPDUser>(context, listen: false);

    // Validation
    if (user.userId == null) {
      setState(() => _error = "Session error: User ID not found");
      return;
    }

    if (pin.length != 4 || int.tryParse(pin) == null) {
      setState(() => _error = t(context, 'pin_4_digits'));
      return;
    }

    if (pin != confirmPin) {
      setState(() => _error = t(context, 'pin_mismatch'));
      return;
    }

    // Save to SharedPreferences using the correct user key
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_${user.userId}_pin', pin);

    setState(() => _error = null);

    // Show the left-aligned success dialog
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Consistent margin
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // All text starts on the left
            children: [
              Text(
                  t(context, 'success'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              Text(t(context, 'pin_changed_success')),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Button on the left
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Line up text with title
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx); // Close Dialog
                      Navigator.pop(context, true); // Close Screen
                    },
                    child: const Text(
                        "OK",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            // Switch based on the current mode
            isDark
                ? 'assets/images/logo-spd-big-white.png'
                : 'assets/images/logo-spd-big.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => SPDDialog.showLanguageDialog(context),
              child: Image.asset(
                user.currentLanguage == 'mk'
                    ? 'assets/images/langs/mk.png'
                    : 'assets/images/langs/en.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo-bs-small.jpg', height: 100, fit: BoxFit.contain),
              const SizedBox(height: 100),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: t(context, 'new_pin'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: t(context, 'confirm_pin'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _changePin,
                  child: Text(t(context, 'change_pin')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------
/// SPDUser
/// ---------------------------
class SPDUser extends ChangeNotifier {
  bool isLoggedIn = false;
  String? _userId;
  String currentLanguage = 'en'; // 'en' or 'mk'
  String? sessionCookie; // store PHP session cookie
  String? username; // optional, for reference
  static final SPDUser current = SPDUser._internal();
  SPDUser._internal();
  String? get userId => _userId;

  // Initialize (if needed)
  static Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Inside your SPDUser class
  Future<void> updatePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', newPin); // Save locally
    // If you have a server, you would also do an API call here
    notifyListeners();
  }

  Future<void> logout() async {
    isLoggedIn = false;
    sessionCookie = null;
    _userId = null;

    // Clear SharedPreferences so the session is truly dead
    final prefs = await SharedPreferences.getInstance();
    // If you want to keep settings like language but clear login:
    await prefs.remove('session_key'); // or whatever key you use
    // Or to clear everything:
    // await prefs.clear();

    notifyListeners();
  }

  void setLanguage(String lang) {
    currentLanguage = lang;
    notifyListeners();
  }

  void setUserData(String id) {
    _userId = id;
    notifyListeners();
  }

  // Login method
  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("https://epay.fkcbs.com.mk/loginapiprod.php"), // your real login PHP URL
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // extract session cookie from headers
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          SPDUser.current.sessionCookie = cookies.split(';')[0];
        }

        SPDUser.current.isLoggedIn = true;
        SPDUser.current.username = username;
        SPDUser.current.notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // GET request with session cookie
  static Future<http.Response> get(String endpoint) async {
    final headers = <String, String>{};
    if (current.sessionCookie != null) {
      headers['Cookie'] = current.sessionCookie!;
    }

    return await http.get(Uri.parse(endpoint), headers: headers);
  }

  // POST request with session cookie
  static Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = <String, String>{};
    if (current.sessionCookie != null) {
      headers['Cookie'] = current.sessionCookie!;
    }

    return await http.post(Uri.parse(endpoint), body: body, headers: headers);
  }

  // Handle responses
  static bool handleResponse(BuildContext context, http.Response? response, {Function? callback}) {
    if (response == null || response.statusCode != 200) {
      return true; // treat as error
    }

    if (callback != null) callback();
    return false; // no logout needed
  }
}

/// ---------------------------
/// SPDRoute
/// ---------------------------
class SPDRoute {
  static void go(String routeName) {
    debugPrint("Navigate to $routeName");
  }
}

/// ---------------------------
/// SPDColor
/// ---------------------------
class SPDColor {
  static const Color primaryColor = Colors.blue;
}

/// ---------------------------
/// SPDDialog
/// ---------------------------
class SPDDialog {
  static String _t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  static void showLogoutDialog(BuildContext context, VoidCallback onLogout) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        // The background color will now automatically adapt to theme.colorScheme.surface
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t(context, 'logout'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  // Color automatically switches between dark/light text
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _t(context, 'confirm_logout_msg') ?? "Дали сакате да се одјавите?",
                style: theme.textTheme.bodyMedium?.copyWith(
                  // Adaptive muted color (e.g., grey in light, light grey in dark)
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // Highlight color (usually blue or green)
                      foregroundColor: colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      onLogout();
                    },
                    child: Text(_t(context, 'yes')),
                  ),
                  const SizedBox(width: 24),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colorScheme.secondary,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(_t(context, 'cancel')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showExitAppDialog(BuildContext context, VoidCallback onExit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t(context, 'close')),
        content: Text(_t(context, 'confirm_exit_msg') ?? "Do you want to exit the app?"),
        actions: [
          TextButton(onPressed: onExit, child: Text(_t(context, 'success') ?? "Yes")),
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(_t(context, 'cancel'))),
        ],
      ),
    );
  }

  static void showLanguageDialog(BuildContext context) {
    final user = Provider.of<SPDUser>(context, listen: false);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t(context, 'select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.asset('assets/images/langs/en.png', width: 32, height: 32),
              title: Text(_t(context, 'english')),
              // Text color in ListTile automatically follows theme
              onTap: () {
                user.setLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            Divider(color: theme.dividerColor),
            ListTile(
              leading: Image.asset('assets/images/langs/mk.png', width: 32, height: 32),
              title: Text(_t(context, 'macedonian')),
              onTap: () {
                user.setLanguage('mk');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> showConfirmDialog(BuildContext context, String titleKey, String bodyKey,
      [IconData? icon, Color? color]) async {
    final theme = Theme.of(context);

    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) Icon(icon, color: color ?? theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(_t(context, titleKey)),
          ],
        ),
        content: Text(_t(context, bodyKey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(_t(context, 'success') ?? "Yes")
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(_t(context, 'cancel'))
          ),
        ],
      ),
    ) ?? false;
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
            child: CircularProgressIndicator(
              // Uses the primary theme color (blue/green) in both modes
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            )
        )
    );
  }

  static void removeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

/// ---------------------------
/// SPDFormValidation
/// ---------------------------
class SPDFormValidation {
  final bool required;
  const SPDFormValidation({this.required = false});
  String? Function(String?) build(BuildContext context) => (val) {
    if (required && (val == null || val.isEmpty)) return 'Required';
    return null;
  };
}

/// ---------------------------
/// SPDDateFormField
/// ---------------------------
class SPDDateFormField extends FormField<DateTime> {
  SPDDateFormField({
    required DateTime value,
    FormFieldSetter<DateTime>? onSaved,
  }) : super(
    key: Key(value.toString()),
    initialValue: value,
    onSaved: onSaved,
    builder: (state) {
      return InkWell(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: state.context,
            initialDate: state.value ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) state.didChange(picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: "Date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            state.value != null
                ? state.value.toString().split(' ')[0]
                : 'Select Date',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    },
  );
}

/// ---------------------------
/// JsonProp
/// ---------------------------
class JsonProp {
  static num number(dynamic v) => v is num ? v : int.tryParse(v.toString()) ?? 0;
  static DateTime dateTime(dynamic v) => DateTime.tryParse(v.toString()) ?? DateTime.now();
  static Color color(dynamic v) => Colors.blue;
}

/// ============== CALENDAR MODEL ==========
class CalendarEvent {
  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final num eventType;
  final String colorHex;
  final String? recurrenceRule;

  CalendarEvent({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.eventType,
    required this.colorHex,
    this.recurrenceRule,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['ID']?.toString(),
      title: json['TITLE']?.toString() ?? '',
      description: json['DESCR']?.toString() ?? '',
      date: DateTime.tryParse(json['EVENT_DATE']?.toString() ?? '') ?? DateTime.now(),
      eventType: num.tryParse(json['TYPE_ID']?.toString() ?? '1') ?? 1,
      colorHex: json['BG_COLOR']?.toString() ?? '#3498db',
      recurrenceRule: json['RECURRENCE'],
    );
  }

  Color get color {
    String hex = colorHex.replaceAll('#', '');
    if (hex.length == 8) hex = hex.substring(6, 8) + hex.substring(0, 6);
    return Color(int.parse("0x$hex"));
  }
}

/// ============== CALENDAR DIALOG (Add/Edit) ==========
class CalendarEventDialog extends StatefulWidget {
  final CalendarEvent event;
  final dynamic eventTypes;
  final Function onEventChanged;

  const CalendarEventDialog({
    super.key,
    required this.event,
    required this.eventTypes,
    required this.onEventChanged,
  });

  @override
  State<CalendarEventDialog> createState() => _CalendarEventDialogState();
}

class _CalendarEventDialogState extends State<CalendarEventDialog> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late DateTime _eventDate;
  late num _currType;
  late String _recurrenceFreq;

  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    _eventDate = widget.event.date;
    _currType = widget.event.eventType;

    if (_currType == 1) _recurrenceFreq = 'WEEKLY';
    else if (_currType == 2) _recurrenceFreq = 'MONTHLY';
    else if (_currType == 3) _recurrenceFreq = 'YEARLY';
    else _recurrenceFreq = 'NONE';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.id == null ? t(context, "new_event") : t(context, "edit_event")),
        actions: [
          if (widget.event.id != null)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () {
                CalendarDeleteEvent.showDialog(context, widget.event, () {
                  Navigator.of(context).pop();
                  widget.onEventChanged();
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: t(context, "title"),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? t(context, "title_req") : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: t(context, "description"),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _recurrenceFreq,
                dropdownColor: theme.cardColor,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: t(context, "type"),
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'NONE', child: Text(t(context, " - "))),
                  DropdownMenuItem(value: 'WEEKLY', child: Text(t(context, "weekly"))),
                  DropdownMenuItem(value: 'MONTHLY', child: Text(t(context, "monthly"))),
                  DropdownMenuItem(value: 'YEARLY', child: Text(t(context, "yearly"))),
                ],
                onChanged: (v) => setState(() => _recurrenceFreq = v!),
              ),
              const SizedBox(height: 16),
              SPDDateFormField(
                value: _eventDate,
                onSaved: (v) => _eventDate = v ?? DateTime.now(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2e9e48),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_form.currentState?.validate() ?? false) {
                      _form.currentState!.save();
                      num updatedTypeId = 0;
                      if (_recurrenceFreq == 'WEEKLY') updatedTypeId = 1;
                      else if (_recurrenceFreq == 'MONTHLY') updatedTypeId = 2;
                      else if (_recurrenceFreq == 'YEARLY') updatedTypeId = 3;

                      CalendarSaveEvent.showDialog(
                        context,
                        CalendarEvent(
                          id: widget.event.id,
                          title: _nameController.text,
                          description: _descController.text,
                          eventType: updatedTypeId,
                          date: _eventDate,
                          colorHex: widget.event.colorHex,
                        ),
                            () {
                          Navigator.of(context).pop();
                          widget.onEventChanged();
                        },
                      );
                    }
                  },
                  child: Text(widget.event.id == null ? t(context, "add_event") : t(context, "update_event")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============== DELETE LOGIC ==========
class CalendarDeleteEvent {
  static Future<void> showDialog(BuildContext context, CalendarEvent e, Function callback) async {
    final user = Provider.of<SPDUser>(context, listen: false);
    final lang = user.currentLanguage ?? 'en';

    final confirm = await SPDDialog.showConfirmDialog(
      context,
      translations[lang]?['delete_event'] ?? "Delete Event",
      translations[lang]?['delete_confirm'] ?? "Permanently remove this event?",
      Icons.delete,
      Colors.red,
    );

    if (confirm) {
      try {
        SPDDialog.showLoadingDialog(context);
        final response = await SPDUser.post(
          'https://epay.fkcbs.com.mk/calendarapi.php',
          body: {
            'action': 'delete',
            'user_id': user.userId.toString(),
            'eventId': e.id.toString(),
          },
        );
        SPDDialog.removeDialog(context);
        final result = jsonDecode(response.body);
        if (result['success'] == true) callback.call();
      } catch (err) {
        SPDDialog.removeDialog(context);
      }
    }
  }
}

/// ============== SAVE LOGIC ==========
class CalendarSaveEvent {
  static Future<void> showDialog(BuildContext context, CalendarEvent e, Function callback) async {
    final user = Provider.of<SPDUser>(context, listen: false);
    final lang = user.currentLanguage ?? 'en';
    final isNew = e.id == null;

    final confirm = await SPDDialog.showConfirmDialog(
      context,
      isNew ? (translations[lang]?['add_event'] ?? "Add Event") : (translations[lang]?['update_event'] ?? "Update Event"),
      isNew ? (translations[lang]?['create_event'] ?? "Create this event?") : (translations[lang]?['save_changes'] ?? "Save changes?"),
      isNew ? Icons.add : Icons.save,
      Colors.green,
    );

    if (confirm) {
      try {
        SPDDialog.showLoadingDialog(context);
        final Map<String, String> postData = {
          'action': 'save',
          'user_id': user.userId.toString(),
          'eventId': e.id?.toString() ?? '',
          'eventTitle': e.title,
          'eventDesc': e.description,
          'eventType': e.eventType.toString(),
          'eventDate': "${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}",
        };

        final response = await SPDUser.post('https://epay.fkcbs.com.mk/calendarapi.php', body: postData);
        SPDDialog.removeDialog(context);
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          callback.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${result['message']}")),
          );
        }
      } catch (err) {
        SPDDialog.removeDialog(context);
      }
    }
  }
}

/// ============== DATA SOURCE ==========
class CalendarEventDataSource extends sf.CalendarDataSource<CalendarEvent> {
  CalendarEventDataSource(List<CalendarEvent> source) {
    appointments = source;
  }
  @override DateTime getStartTime(int index) => appointments![index].date;
  @override DateTime getEndTime(int index) => appointments![index].date;
  @override String getSubject(int index) => appointments![index].title;
  @override Color getColor(int index) => appointments![index].color;
}

/// ============== MAIN CALENDAR VIEW ==========
class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  final sf.CalendarController _controller = sf.CalendarController();
  Future<http.Response>? _lastResponse;
  dynamic _eventTypes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_lastResponse == null) refreshData();
  }

  void refreshData() {
    final user = Provider.of<SPDUser>(context, listen: false);
    setState(() {
      _lastResponse = http.get(
        Uri.parse('https://epay.fkcbs.com.mk/calendarAPI.php?user_id=${user.userId}'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage ?? 'en';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'mk' ? 'Календар' : 'Calendar'),
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF388E3C),
        onPressed: () => _openEventDialog(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<http.Response>(
        future: _lastResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading data'));
          }

          final json = jsonDecode(snapshot.data!.body);
          _eventTypes = json['eventTypes'];
          List<CalendarEvent> events = (json['events'] as List)
              .map((item) => CalendarEvent.fromJson(item))
              .toList();

          String monthName = DateFormat('MMMM yyyy', lang).format(_controller.displayDate ?? DateTime.now());
          if (monthName.isNotEmpty) {
            monthName = monthName[0].toUpperCase() + monthName.substring(1);
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: theme.scaffoldBackgroundColor,
                child: Text(
                  monthName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
              ),
              Expanded(
                child: sf.SfCalendar(
                  key: ValueKey('calendar_${lang}_${events.length}'),
                  controller: _controller,
                  dataSource: CalendarEventDataSource(events),
                  view: sf.CalendarView.month,
                  headerHeight: 0,
                  showNavigationArrow: true,
                  todayHighlightColor: colorScheme.primary,
                  cellBorderColor: colorScheme.outlineVariant,
                  onViewChanged: (sf.ViewChangedDetails details) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {});
                    });
                  },
                  monthViewSettings: sf.MonthViewSettings(
                    showAgenda: true,
                    agendaStyle: sf.AgendaStyle(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      appointmentTextStyle: TextStyle(color: colorScheme.onSurface),
                      dayTextStyle: TextStyle(color: colorScheme.onSurface),
                      dateTextStyle: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  onTap: (details) {
                    if (details.targetElement == sf.CalendarElement.appointment) {
                      _openEventDialog(details.appointments!.first);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openEventDialog(CalendarEvent? event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarEventDialog(
          event: event ?? CalendarEvent(
              id: null, title: '', description: '',
              date: _controller.selectedDate ?? DateTime.now(),
              eventType: 0, colorHex: '#2e9e48'
          ),
          eventTypes: _eventTypes,
          onEventChanged: refreshData,
        ),
      ),
    );
  }
}

/// ---------------------------
/// LOANDETAILS VIEW
/// ---------------------------
class LoanDetailsView extends StatelessWidget {
  final Map<String, String> loanData;
  const LoanDetailsView({super.key, required this.loanData});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);
    final lang = user.currentLanguage ?? 'en';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String lbl(String key) => translations[lang]?[key] ?? key;

    return Scaffold(
      // Removed hardcoded white - now uses theme background
      appBar: AppBar(
        // Colors will now adapt automatically
        title: Text(lbl('loan'), style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context, loanData['PRODUCT_NAME'] ?? ''),
            const SizedBox(height: 20),

            _buildDetailRow(context, lbl('ref_number'), loanData['REF_NO']),
            _buildDetailRow(context, lbl('approved_amount'), loanData['AMOUNT']),
            _buildDetailRow(context, lbl('currency'), loanData['CURR']),
            _buildDetailRow(context, lbl('approval_date'), loanData['DATE_APP']),
            _buildDetailRow(context, lbl('due_date'), loanData['DUE_DATE']),
            _buildDetailRow(context, lbl('next_payment_amount'), loanData['NEXT_PAYMENT']),
            _buildDetailRow(context, lbl('interest_rate'), loanData['INTEREST_RATE']),
            _buildDetailRow(context, lbl('transaction_account'), loanData['ACCOUNT']),
            _buildDetailRow(context, lbl('undue_principal'), loanData['UNDUE_PRINCIPAL']),
            _buildDetailRow(context, lbl('due_principal'), loanData['DUE_PRINCIPAL']),
            _buildDetailRow(context, lbl('undue_interest'), loanData['UNDUE_INTEREST']),
            _buildDetailRow(context, lbl('due_interest'), loanData['DUE_INTEREST']),
            _buildDetailRow(context, lbl('due_penalty_interest'), loanData['DUE_PENALTY']),
            _buildDetailRow(context, lbl('undue_penalty_interest'), loanData['UNDUE_PENALTY']),
            _buildDetailRow(context, lbl('due_commission'), loanData['DUE_COMMISSION']),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Light blue for light mode, deep subtle blue for dark mode
        color: isDark ? Colors.blue.withOpacity(0.15) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.blueAccent.withOpacity(0.3) : Colors.blue.shade100),
      ),
      child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.blueAccent : Colors.blue.shade800
          )
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String? value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Grey text that adapts
          Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
          Flexible(
              child: Text(
                  value ?? '-',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colorScheme.onSurface // Black in light / White in dark
                  )
              )
          ),
        ],
      ),
    );
  }
}

/// ---------------------------
/// LOANDETAILSBOTTOMSHEET
/// ---------------------------
class LoanDetailsSheet extends StatelessWidget {
  final dynamic loan;
  final String lang;

  const LoanDetailsSheet({
    super.key,
    required this.loan,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final List payments = loan['PAYMENTS'] ?? [];
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _handle(context),
            _title(loan['KREDIT'] ?? translations[lang]!['loan']!, colorScheme.onSurface),

            _info(context, translations[lang]!['account_no']!, loan['PARTIJA']),
            _info(context, translations[lang]!['contract_no']!, loan['DOGOVOR']),
            _info(context, translations[lang]!['approval_date']!, loan['DATE_APPROVAL']),
            _info(context, translations[lang]!['currency']!, loan['CURR']),
            _info(context, translations[lang]!['approved_amount']!, loan['CURR_AMOUNT']),
            _info(context, translations[lang]!['approved_amount_mkd']!, loan['MKD_AMOUNT']),
            _info(context, translations[lang]!['due_date']!, loan['DUE_DATE']),

            const SizedBox(height: 20),
            const Divider(),

            Text(
              translations[lang]!['payment_list']!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 10),

            if (payments.isEmpty)
              Text(translations[lang]!['no_payments']!, style: TextStyle(color: colorScheme.onSurfaceVariant))
            else
              ...payments.map((p) => _paymentRow(context, p)).toList(),

            const SizedBox(height: 20),
            const Divider(),

            _actionButton(
              context,
              icon: Icons.receipt_long_outlined,
              label: translations[lang]!['amortization_plan']!,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _actionButton(
              context,
              icon: Icons.close,
              label: translations[lang]!['close']!,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _handle(BuildContext context) => Center(
    child: Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _title(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
    ),
  );

  Widget _info(BuildContext context, String label, String? value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(BuildContext context, dynamic payment) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(payment['date'], style: TextStyle(color: colorScheme.onSurface)),
          Text(payment['amount'],
              style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}

/// ---------------------------
/// FETCH LOANS
/// ---------------------------
Future<List<Map<String, String>>> fetchLoans(String userId) async {
  final String url = 'https://epay.fkcbs.com.mk/loansapi.php?cust_id=$userId';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['loans'] != null) {
        List<dynamic> list = data['loans'];

        return list.map((item) {
          String rawCurr = item['CURR']?.toString() ?? '';
          String displayCurr = (rawCurr.trim() == '807' || rawCurr.trim() == 'MKD') ? 'MKD' : rawCurr;

          var rawAmount = item['CURR_AMOUNT'] ?? item['CUR_AMOUNT'] ?? '0.00';

          return {
            'PRODUCT_NAME':    item['PRODUCT_NAME']?.toString() ?? '',
            'REF_NO':          item['APP_APPNO']?.toString() ?? '',

            'AMOUNT':          '${_formatAmount(rawAmount)} $displayCurr',
            'AMOUNT_MKD':      '${_formatAmount(item['MKD_AMOUNT'])} MKD',

            'CURR':            displayCurr,
            'DATE_APP':        _formatDate(item['DATE_APPROVAL']?.toString()),
            'DUE_DATE':        _formatDate(item['DUE_DATE']?.toString()),

            'NEXT_PAYMENT':    '${_formatAmount(item['NEXTINSTALLMENTAMOUNT'])} $displayCurr',
            'UNDUE_PRINCIPAL': '${_formatAmount(item['NONMATUREPRINCIPAL'])} $displayCurr',
            'DUE_PRINCIPAL':   '${_formatAmount(item['MATUREPRINCIPAL'])} $displayCurr',
            'UNDUE_INTEREST':  '${_formatAmount(item['NONMATUREINTEREST'])} $displayCurr',
            'DUE_INTEREST':    '${_formatAmount(item['REGULARINTEREST'])} $displayCurr',
            'DUE_PENALTY':     '${_formatAmount(item['PENALTYINTEREST'])} $displayCurr',
            'UNDUE_PENALTY':   '${_formatAmount(item['NONMATUREPROVISION'])} $displayCurr',
            'DUE_COMMISSION':  '${_formatAmount(item['PROVISION'])} $displayCurr',

            'INTEREST_RATE': (item['INTRATE'] != null && item['INTRATE'].toString().isNotEmpty)
                ? "${double.tryParse(item['INTRATE'].toString())?.toStringAsFixed(2) ?? item['INTRATE']}%"
                : "1.00%",
            'ACCOUNT':         item['APP_RESV_ACCOUNT']?.toString() ?? '',
          };
        }).toList();
      }
    }
    return [];
  } catch (e) {
    debugPrint("Fetch Error: $e");
    return [];
  }
}

// Helper to format 200000 into 200,000.00
String _formatAmount(dynamic val) {
  if (val == null) return "0.00";
  double amount = double.tryParse(val.toString()) ?? 0.0;

  // This creates the comma separator and 2 decimal places
  // Example: 200000 -> 200,000.00
  return amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

String _formatDate(String? dateStr) {
  if (dateStr == null || dateStr.length < 10) return '-';
  try {
    DateTime dt = DateTime.parse(dateStr);
    return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
  } catch (e) {
    return dateStr.split(' ')[0];
  }
}


