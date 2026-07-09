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
import 'dart:math';
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
Widget buildLanguageFlag(BuildContext context) {
  final user = Provider.of<SPDUser>(context);

  String rawLang = user.currentLanguage?.toLowerCase() ?? 'en';
  String normalizedLang = rawLang.split('_').first.split('-').first;

  if (normalizedLang != 'mk' && normalizedLang != 'en') {
    normalizedLang = 'en';
  }

  return Image.asset(
    'assets/images/$normalizedLang.png',
    key: ValueKey<String>(normalizedLang),
    width: 32,
    height: 32,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.g_translate, size: 24);
    },
  );
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
    'payments': 'Payments',
    'no_payments_found': 'No payments found.',
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

    // Deposits
    'deposits': 'Deposits',
    'deposit_time_mkd': 'Time deposit in MKD',
    'deposit_sight': 'Sight deposit',
    'deposit_children': 'Children\'s savings',
    'months': 'months',
    'flexible': 'Flexible',
    'interest_label': 'Interest',
    'period_label': 'Period',

    // Payments Extra
    'total_amount_due': 'Total amount due',
    'pay_now': 'Pay now',
    'recent_transactions': 'Recent transactions',
    'loan_repayment': 'Loan repayment',
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

    // Сигурносни скокачки прозорци
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
    'confirm_pin': 'Потврди ПИН',
    'pin_4_digits': 'ПИН-от мора да има 4 цифри',
    'pin_mismatch': 'ПИН-овите не се совпаѓаат',
    'success': 'Успешно',

    // Детали за кредит & Плаќања
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
    'payments': 'Плаќања',
    'no_payments_found': 'Нема пронајдено плаќања.',
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

    // Заклучен корисник
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

    // Позајмици / Депозити
    'deposits': 'Позајмици',
    'deposit_time_mkd': 'Орочен депозит во МКД',
    'deposit_sight': 'Депозит по видување',
    'deposit_children': 'Детско штедење',
    'months': 'месеци',
    'flexible': 'Флексибилно',
    'interest_label': 'Камата',
    'period_label': 'Рок',

    // Плаќања дополнително
    'total_amount_due': 'Вкупен износ за плаќање',
    'pay_now': 'Плати сега',
    'recent_transactions': 'Неодамнешни трансакции',
    'loan_repayment': 'Отплата на заем',
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
/// PAYMENTS VIEW
/// ---------------------------
class PaymentsView extends StatefulWidget {
  final String userId;

  const PaymentsView({super.key, required this.userId});

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t(context, 'payments'),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 24),

              Text(
                t(context, 'recent_transactions'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildTransactionItem();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo[800],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t(context, 'total_amount_due'),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '1.250,00 ден',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo[800],
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              t(context, 'pay_now'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.greenAccent,
          child: Icon(Icons.arrow_downward, color: Colors.green),
        ),
        title: Text(
          t(context, 'loan_repayment'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('09.07.2026'),
        trailing: const Text(
          '-250,00 ден',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        ),
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

class HighSecurityAuthView extends StatefulWidget {
  final String correctPin;
  final Map<String, String> matrixGridValues;
  final VoidCallback onSuccess;

  const HighSecurityAuthView({
    super.key,
    required this.correctPin,
    required this.matrixGridValues,
    required this.onSuccess,
  });

  @override
  State<HighSecurityAuthView> createState() => _HighSecurityAuthViewState();
}

class _HighSecurityAuthViewState extends State<HighSecurityAuthView> {
  List<String> _scrambledKeys = [];
  String _inputPin = '';
  late String _currentGridCoordinate;
  String _inputGridValue = '';
  int _currentStep = 1;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrambleKeypad();
    _generateGridChallenge();
  }

  void _scrambleKeypad() {
    setState(() {
      final List<String> digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
      digits.shuffle(Random());
      _scrambledKeys = digits;
    });
  }
  void _generateGridChallenge() {
    final keys = widget.matrixGridValues.keys.toList();
    if (keys.isNotEmpty) {
      _currentGridCoordinate = keys[Random().nextInt(keys.length)];
    } else {
      _currentGridCoordinate = "A1";
    }
  }

  void _onKeyPress(String value) {
    setState(() {
      _errorMessage = null;
    });

    if (_currentStep == 1) {
      if (_inputPin.length < 4) {
        setState(() => _inputPin += value);
      }
      if (_inputPin.length == 4) {
        if (_inputPin == widget.correctPin) {
          setState(() {
            _currentStep = 2;
          });
        } else {
          _handleFailure();
        }
      }
    } else {
      setState(() => _inputGridValue = value);

      if (_inputGridValue == widget.matrixGridValues[_currentGridCoordinate]) {
        widget.onSuccess();
      } else {
        _handleFailure();
      }
    }
    _scrambleKeypad();
  }

  void _handleFailure() {
    setState(() {
      _inputPin = '';
      _inputGridValue = '';
      _currentStep = 1;
      _errorMessage = "Authentication failed. Layout reset.";
    });
    _scrambleKeypad();
    _generateGridChallenge();
  }

  void _onBackspace() {
    setState(() {
      _errorMessage = null;
      if (_currentStep == 1 && _inputPin.isNotEmpty) {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
      } else if (_currentStep == 2) {
        _inputGridValue = '';
      }
    });
    _scrambleKeypad();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.shield_outlined, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              _currentStep == 1 ? "ENTER SECURE PIN" : "MATRIX SECURITY CHECK",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentStep == 1
                  ? "Keypad layouts are dynamically scrambled."
                  : "Verify security token card details.",
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            _currentStep == 1 ? _buildPinIndicators() : _buildMatrixChallengeBlock(),

            SizedBox(
              height: 40,
              child: Center(
                child: _errorMessage != null
                    ? Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                    : null,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildKeyboardRow(_scrambledKeys.sublist(0, 3)),
                  _buildKeyboardRow(_scrambledKeys.sublist(3, 6)),
                  _buildKeyboardRow(_scrambledKeys.sublist(6, 9)),
                  _buildBottomRow(_scrambledKeys[9]),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPinIndicators() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < _inputPin.length;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 36,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isFilled ? colorScheme.error.withOpacity(0.1) : colorScheme.surface,
            border: Border.all(
                color: isFilled ? colorScheme.error : colorScheme.outlineVariant,
                width: 2
            ),
          ),
          child: Text(
            isFilled ? _inputPin[index] : "",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.error
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMatrixChallengeBlock() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter coordinate [ $_currentGridCoordinate ] value: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.error, width: 2),
              borderRadius: BorderRadius.circular(6),
              color: colorScheme.surface,
            ),
            child: Text(
              _inputGridValue,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildKeyButton(key)).toList(),
      ),
    );
  }

  Widget _buildBottomRow(String lastDigit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 68),
          _buildKeyButton(lastDigit),
          SizedBox(
            width: 68,
            height: 68,
            child: IconButton(
              onPressed: _onBackspace,
              icon: const Icon(Icons.backspace_outlined),
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 68,
      height: 68,
      child: OutlinedButton(
        onPressed: () => _onKeyPress(value),
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: BorderSide(color: colorScheme.error.withOpacity(0.4), width: 1.5),
          backgroundColor: colorScheme.surface,
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
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
    'customer_support': 'tel:13 505',
    'questions': 'mailto:info@flexcredit.mk',
    'visit_website': 'https://flexcredit.mk/',
    'location_services': 'https://www.google.com/maps/place/FlexCredit/@42.0001971,21.4403052,2465m/data=!3m1!1e3!4m10!1m2!2m1!1sflexcredit!3m6!1s0x135415bb5ee2ce17:0x4309d6ea3a80b5e2!8m2!3d42.0001971!4d21.4593596!15sCgpmbGV4Y3JlZGl0kgELbG9hbl9hZ2VuY3ngAQA!16s%2Fg%2F11yq89lgbj?entry=ttu&g_ep=EgoyMDI2MDcwNi4wIKXMDSoASAFQAw%3D%3D',
    'report_card': 'tel:13 505',
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final TextStyle subtitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface.withOpacity(0.7),
    );

    final Color dangerColor = isDark ? Colors.redAccent : const Color(0xFFD32F2F);
    final Color dangerBg = isDark ? Colors.red.withOpacity(0.15) : const Color(0xFFFFEBEE);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            leading: const Icon(Icons.support_agent_outlined, size: 32),
            title: Text(t(context, 'customer_support')),
            subtitle: Text('13 505', style: subtitleStyle),
            trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
            onTap: () => _openUrl(contacts['customer_support']!, context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.web_outlined, size: 32),
            title: Text(t(context, 'visit_website')),
            subtitle: Text('https://flexcredit.mk/', style: subtitleStyle),
            trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
            onTap: () => _openUrl(contacts['visit_website']!, context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on_outlined, size: 32),
            title: Text(t(context, 'location_services')),
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

          Container(
            decoration: BoxDecoration(
              color: dangerBg,
              borderRadius: BorderRadius.circular(8),
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
        Uri.parse('https://flexcredit.mk/'),
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
  Future<List<Map<String, String>>>? _paymentsFuture;

  Future<List<Map<String, String>>> fetchPayments(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'TITLE': 'EVN Electricity Bill',
        'CURR': 'MKD',
        'REFERENCE_NUMBER': '200018475920',
      },
      {
        'TITLE': 'A1 Telecom Internet',
        'CURR': 'MKD',
        'REFERENCE_NUMBER': '100049285011',
      },
    ];
  }
  Future<List<Map<String, String>>> fetchLoans(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'TITLE': 'Стамбен Кредит',
        'CURR': 'MKD',
        'CONTRACT_NO': '100-2024-3392',
      }
    ];
  }

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
    if (_paymentsFuture == null) {
      _paymentsFuture = widget.userId != null ? fetchPayments(widget.userId!) : Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SPDUser>(context);

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
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

            const SizedBox(height: 15),

            _buildSectionHeader(
                title: t(context, 'payments'),
                icon: Icons.receipt_long_outlined,
                color: Colors.green.shade700
            ),

            FutureBuilder<List<Map<String, String>>>(
              future: _paymentsFuture,
              builder: (context, snapshot) {
                return PaymentView(
                  data: snapshot.data ?? [],
                  connectionState: snapshot.connectionState,
                  lang: user.currentLanguage,
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
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
}

/// ---------------------------
/// PAYMENTVIEW (Companion Widget)
/// ---------------------------
class PaymentView extends StatelessWidget {
  final List<dynamic> data;
  final ConnectionState connectionState;
  final String lang;

  const PaymentView({
    required this.data,
    required this.connectionState,
    required this.lang,
    super.key,
  });

  String t(BuildContext context, String key) {
    return translations[lang]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    if (connectionState == ConnectionState.waiting) {
      return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
    }

    if (data.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(child: Text(t(context, 'no_payments'), style: const TextStyle(color: Colors.black54))),
      );
    }

    return Container(
      color: Colors.white,
      height: 230,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9, initialPage: 0),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildPaymentCarouselCard(context, data[index]);
        },
      ),
    );
  }

  Widget _buildPaymentCarouselCard(BuildContext context, dynamic payment) {
    return GestureDetector(
      onTap: () {
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.green.shade800, Colors.green.shade500],
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
                      const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        t(context, 'payments').toUpperCase(),
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
                      "${payment['CURR'] ?? 'MKD'}",
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
                payment['TITLE'] ?? payment['PRODUCT_NAME'] ?? '',
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
                    payment['REFERENCE_NUMBER'] ?? payment['ACCOUNT_NUMBER'] ?? '',
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

/// ---------------------------
/// LOCATIONSVIEW
/// ---------------------------
class LocationsView extends StatelessWidget {
  const LocationsView({super.key});

  static const String _mapsUrl =
      'https://www.google.com/maps/place/FlexCredit/@42.0001971,21.4403052,2465m/data=!3m1!1e3!4m10!1m2!2m1!1sflexcredit!3m6!1s0x135415bb5ee2ce17:0x4309d6ea3a80b5e2!8m2!3d42.0001971!4d21.4593596!15sCgpmbGV4Y3JlZGl0kgELbG9hbl9hZ2VuY3ngAQA!16s%2Fg%2F11yq89lgbj?entry=ttu&g_ep=EgoyMDI2MDcwNi4wIKXMDSoASAFQAw%3D%3D';

  Future<void> _openMap(BuildContext context) async {
    final Uri uri = Uri.parse(_mapsUrl);
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 64, color: colorScheme.primary),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => _openMap(context),
                icon: const Icon(Icons.map),
                label: Text(t(context, 'open_in_maps')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        _lockedUsername = null;

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
          _lockedUsername = username;
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            'assets/images/S.jpg',
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
              Image.asset('assets/images/S.jpg', height: 200, fit: BoxFit.contain),
              const SizedBox(height: 200),
              TextField(
                controller: _usernameController,
                onChanged: (val) {
                  if (_error != null) {
                    setState(() {
                      _error = null;
                    });
                  }
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: t(context, 'username'),
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: t(context, 'password'),
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
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

      final bool authenticated = await _auth.authenticate(
        localizedReason: t(context, 'verify_identity'),
        biometricOnly: true,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Image.asset(
            'assets/images/S.jpg',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => SPDDialog.showLanguageDialog(context),
              child: Image.asset(
                lang == 'mk' ? 'assets/images/langs/en.png' : 'assets/images/langs/en.png',
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
              Image.asset('assets/images/S.jpg', height: 200, fit: BoxFit.contain),
              const SizedBox(height: 200),
              TextField(
                autofocus: true,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (v) => setState(() => enteredPin = v),
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: t(context, 'pin'),
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
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
      backgroundColor: Colors.white,
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
        const Divider(height: 1, color: Colors.black12),
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
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
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
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    title: Image.asset(
      'assets/images/S.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    ),
  );
}
/// ---------------------------
/// MAINAPP
/// ---------------------------
Future<void> main() async {
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

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),

      themeMode: ThemeMode.system,


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
  static const int initialTabIndex = 2;

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
    return [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/S.jpg',
              height: 236,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      SPDMenuItem(
        leading: const Icon(Icons.person, color: Colors.black87),
        title: Text(" ${widget.username}", style: const TextStyle(color: Colors.black)),
        onTap: () => Navigator.pop(context),
      ),
      SPDMenuGroup(items: [
        SPDMenuGroupItem(
          value: 'Menu_ControlPanel',
          icon: const Icon(Icons.rocket_launch_outlined, color: Colors.black87),
          title: Text(t(context, 'control_panel'), style: const TextStyle(color: Colors.black)),
          items: [
            SPDMenuItem(
              leading: const Icon(Icons.home_outlined, color: Colors.black87),
              title: Text(t(context, 'home'), style: const TextStyle(color: Colors.black)),
              onTap: () { Navigator.pop(context); changeView(tabIndex: 2); },
            ),
            SPDMenuItem(
              leading: const Icon(Icons.payments_outlined, color: Colors.black87),
              title: Text(t(context, 'loans'), style: const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LoansView(userId: widget.userId)
                    )
                );
              },
            ),
            SPDMenuItem(
              leading: const Icon(Icons.payment, color: Colors.black87),
              title: Text(t(context, 'payments'), style: const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentsView(userId: widget.userId)
                    )
                );
              },
            ),
            SPDMenuItem(
              leading: const Icon(Icons.currency_exchange_outlined, color: Colors.black87),
              title: Text(t(context, 'exchange_rates'), style: const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExchangeRatesView()));
              },
            ),
            SPDMenuItem(
              leading: const Icon(Icons.calendar_today_outlined, color: Colors.black87),
              title: Text(t(context, 'calendar'), style: const TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarView())
                );
              },
            ),
          ],
        ),
      ]),
      const Divider(color: Colors.black12),
      SPDMenuItem(
        leading: const Icon(Icons.language_outlined, color: Colors.black87),
        title: Text(t(context, 'language'), style: const TextStyle(color: Colors.black)),
        onTap: () { Navigator.pop(context); SPDDialog.showLanguageDialog(context); },
      ),
      SPDMenuItem(
        leading: const Icon(Icons.settings_outlined, color: Colors.black87),
        title: Text(t(context, 'settings'), style: const TextStyle(color: Colors.black)),
        onTap: () { Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsView(userId: widget.userId),
          ),
        ); },
      ),
      SPDMenuItem(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: Text(t(context, 'logout'), style: const TextStyle(color: Colors.red)),
        onTap: () {
          Navigator.pop(context);
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 9),
          child: Transform.scale(
            scale: 2.1,
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/S.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => SPDDialog.showLanguageDialog(context),
              child: Image.asset(
                user.currentLanguage == 'mk' ? 'assets/images/langs/mk.png' : 'assets/images/langs/en.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
        ],
      ),
      endDrawer: SPDMenu(children: menuItems()),
      body: Container(
        color: Colors.white,
        child: TabBarView(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabController.index,
        onTap: (index) => changeView(tabIndex: index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
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
        child: Center(child: Text(t(context, 'no_loans'), style: const TextStyle(color: Colors.black54))),
      );
    }

    return Container(
      color: Colors.white,
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
              colors: [Colors.blue.shade800, Colors.blue.shade500],
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
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(
          loan.title,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          loan.amount.toString(),
          style: const TextStyle(color: Colors.black54),
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(translations[lang]?['exchange_rates'] ?? 'Exchange Rates'),
        centerTitle: false,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black,
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
                    style: const TextStyle(color: Colors.black),
                  )
              );
            }
            final rates = snapshot.data ?? [];
            return ListView.separated(
              itemCount: rates.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
              itemBuilder: (context, index) {
                final item = rates[index];
                final oznaka = item['oznaka'] ?? '';
                final naziv = lang == 'mk' ? (item['naziv'] ?? '') : (item['nazivAng'] ?? '');
                final drzava = lang == 'mk' ? (item['drzava'] ?? '') : (item['drzavaAng'] ?? '');
                final rate = item['sreden']?.toString() ?? '';

                return ListTile(
                  leading: CircleAvatar(
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
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    '$naziv ($oznaka)',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    drzava,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Text(
                    rate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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

  final String userId;
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
    final lang = user.currentLanguage ?? 'en';

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(translations[lang]?['settings'] ?? 'Settings'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SPDMenuItem(
            leading: const Icon(Icons.language_outlined),
            title: Text(translations[lang]?['language'] ?? 'Language'),
            onTap: () {
              final user = Provider.of<SPDUser>(context, listen: false);
              final lang = user.currentLanguage;

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(translations[lang]?['select_language'] ?? 'Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Image.asset('assets/images/langs/en.png', width: 32, height: 32),
                        title: Text(translations[lang]?['english'] ?? 'English'),
                        onTap: () {
                          user.setLanguage('en');
                          Navigator.pop(ctx);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: Image.asset('assets/images/langs/mk.png', width: 32, height: 32),
                        title: Text(translations[lang]?['macedonian'] ?? 'Macedonian'),
                        onTap: () {
                          user.setLanguage('mk');
                          Navigator.pop(ctx);
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
          SwitchListTile(
            title: Text(t(context, 'use_biometrics')),
            secondary: const Icon(Icons.fingerprint),
            value: _isBioEnabled,
            onChanged: (bool value) => _toggleBio(value),
          ),
          const Divider(),

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

  String t(BuildContext context, String key) {
    final user = Provider.of<SPDUser>(context, listen: false);
    return translations[user.currentLanguage]?[key] ?? key;
  }

  void _changePin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();
    final user = Provider.of<SPDUser>(context, listen: false);

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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_${user.userId}_pin', pin);

    setState(() => _error = null);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  t(context, 'success'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              Text(t(context, 'pin_changed_success')),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context, true);
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
            isDark
                ? 'assets/images/S.jpg'
                : 'assets/images/S.jpg',
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
              Image.asset('assets/images/S.jpg', height: 100, fit: BoxFit.contain),
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
  static late SPDUser current;

  String? _userId;
  String _currentLanguage = 'mk';


  String? get userId => _userId;
  String get currentLanguage => _currentLanguage;

  static Future<void> init() async {
    current = SPDUser();
    final prefs = await SharedPreferences.getInstance();
    current._currentLanguage = prefs.getString('selected_language') ?? 'mk';
  }

  void setUserData(String? id) {
    _userId = id;
    notifyListeners();
  }

  void setLanguage(String langCode) async {
    if (_currentLanguage != langCode) {
      _currentLanguage = langCode;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', langCode);

      notifyListeners();
    }
  }

  Future<void> logout() async {
    _userId = null;
    notifyListeners();
  }

  static Future<http.Response> post(String url, {required Map<String, dynamic> body}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'error': e.toString()}), 500);
    }
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
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _t(context, 'confirm_logout_msg') ?? "Дали сакате да се одјавите?",
                style: theme.textTheme.bodyMedium?.copyWith(
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
      appBar: AppBar(
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
          Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
          Flexible(
              child: Text(
                  value ?? '-',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colorScheme.onSurface
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

String _formatAmount(dynamic val) {
  if (val == null) return "0.00";
  double amount = double.tryParse(val.toString()) ?? 0.0;
=
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


