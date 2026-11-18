import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final TextEditingController _gramPriceController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _goldSilverController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _investmentsController = TextEditingController();
  final TextEditingController _receivablesController = TextEditingController();
  final TextEditingController _debtsController = TextEditingController();

  String _currencySymbol = '₦';
  bool _useSilverNisab = true; // true = Silver (595g), false = Gold (85g)
  bool _hapticsEnabled = true;

  static const Map<String, Map<String, double>> _defaultGramRates = {
    '₦': {'silver': 2600.0, 'gold': 145000.0},
    '\$': {'silver': 1.15, 'gold': 86.0},
    '£': {'silver': 0.90, 'gold': 68.0},
    '€': {'silver': 1.05, 'gold': 80.0},
    'SAR': {'silver': 4.30, 'gold': 322.0},
    'AED': {'silver': 4.20, 'gold': 316.0},
  };

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _gramPriceController.dispose();
    _cashController.dispose();
    _goldSilverController.dispose();
    _businessController.dispose();
    _investmentsController.dispose();
    _receivablesController.dispose();
    _debtsController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final savedCurrency = prefs.getString('zakat_currency') ?? '₦';
    final savedUseSilver = prefs.getBool('zakat_use_silver') ?? true;
    final defaultRate =
        _defaultGramRates[savedCurrency]![savedUseSilver ? 'silver' : 'gold']!;

    setState(() {
      _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
      _currencySymbol = savedCurrency;
      _useSilverNisab = savedUseSilver;
      _gramPriceController.text =
          prefs.getString('zakat_gram_price') ?? defaultRate.toString();
      _cashController.text = prefs.getString('zakat_cash') ?? '';
      _goldSilverController.text = prefs.getString('zakat_gold_silver') ?? '';
      _businessController.text = prefs.getString('zakat_business') ?? '';
      _investmentsController.text = prefs.getString('zakat_investments') ?? '';
      _receivablesController.text = prefs.getString('zakat_receivables') ?? '';
      _debtsController.text = prefs.getString('zakat_debts') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zakat_currency', _currencySymbol);
    await prefs.setBool('zakat_use_silver', _useSilverNisab);
    await prefs.setString('zakat_gram_price', _gramPriceController.text.trim());
    await prefs.setString('zakat_cash', _cashController.text.trim());
    await prefs.setString(
      'zakat_gold_silver',
      _goldSilverController.text.trim(),
    );
    await prefs.setString('zakat_business', _businessController.text.trim());
    await prefs.setString(
      'zakat_investments',
      _investmentsController.text.trim(),
    );
    await prefs.setString(
      'zakat_receivables',
      _receivablesController.text.trim(),
    );
    await prefs.setString('zakat_debts', _debtsController.text.trim());
  }

  double _parseAmount(TextEditingController controller) {
    final cleaned = controller.text.replaceAll(',', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  double get _nisabGrams => _useSilverNisab ? 595.0 : 85.0;

  double get _nisabThreshold =>
      _parseAmount(_gramPriceController) * _nisabGrams;

  double get _totalAssets =>
      _parseAmount(_cashController) +
      _parseAmount(_goldSilverController) +
      _parseAmount(_businessController) +
      _parseAmount(_investmentsController) +
      _parseAmount(_receivablesController);

  double get _totalDebts => _parseAmount(_debtsController);

  double get _netWealth =>
      (_totalAssets - _totalDebts).clamp(0.0, double.infinity);

  bool get _isAboveNisab =>
      _nisabThreshold > 0 && _netWealth >= _nisabThreshold;

  double get _zakatDue => _isAboveNisab ? _netWealth * 0.025 : 0.0;

  String _formatMoney(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return '$_currencySymbol${formatter.format(amount)}';
  }

  void _onFieldChanged(String _) {
    setState(() {});
    _saveData();
  }

  void _changeCurrency(String symbol) {
    if (_hapticsEnabled) HapticFeedback.selectionClick();
    final rate =
        _defaultGramRates[symbol]![_useSilverNisab ? 'silver' : 'gold']!;
    setState(() {
      _currencySymbol = symbol;
      _gramPriceController.text = rate.toString();
    });
    _saveData();
  }

  void _toggleNisabStandard(bool useSilver) {
    if (_hapticsEnabled) HapticFeedback.selectionClick();
    final rate =
        _defaultGramRates[_currencySymbol]![useSilver ? 'silver' : 'gold']!;
    setState(() {
      _useSilverNisab = useSilver;
      _gramPriceController.text = rate.toString();
    });
    _saveData();
  }

  Future<void> _resetCalculator() async {
    if (_hapticsEnabled) await HapticFeedback.mediumImpact();
    setState(() {
      _cashController.clear();
      _goldSilverController.clear();
      _businessController.clear();
      _investmentsController.clear();
      _receivablesController.clear();
      _debtsController.clear();
    });
    await _saveData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zakat fields cleared.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _copyBreakdown() async {
    if (_hapticsEnabled) await HapticFeedback.selectionClick();
    final standardName = _useSilverNisab ? 'Silver (595g)' : 'Gold (85g)';
    final summary = StringBuffer()
      ..writeln('MyDeen Zakat Calculation')
      ..writeln('------------------------')
      ..writeln('Total Zakatable Assets: ${_formatMoney(_totalAssets)}')
      ..writeln('Deductible Debts: ${_formatMoney(_totalDebts)}')
      ..writeln('Net Zakatable Wealth: ${_formatMoney(_netWealth)}')
      ..writeln('Nisab ($standardName): ${_formatMoney(_nisabThreshold)}')
      ..writeln(
        'Status: ${_isAboveNisab ? "Eligible (2.5% Due)" : "Below Nisab"}',
      )
      ..writeln('Zakat Payable: ${_formatMoney(_zakatDue)}');

    await Clipboard.setData(ClipboardData(text: summary.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'Zakat breakdown copied to clipboard!',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zakat Calculator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '2.5% Annual Purification of Wealth',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Copy Breakdown',
            icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
            onPressed: _copyBreakdown,
          ),
          IconButton(
            tooltip: 'Clear Amounts',
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.orangeAccent,
              size: 22,
            ),
            onPressed: _resetCalculator,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 20),
          _buildSectionTitle('1. Currency & Nisab Standard'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Currency',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _defaultGramRates.keys.map((symbol) {
                    final selected = symbol == _currencySymbol;
                    return ChoiceChip(
                      label: Text(symbol),
                      selected: selected,
                      onSelected: (_) => _changeCurrency(symbol),
                      backgroundColor: const Color(0xFF141718),
                      selectedColor: const Color(0xFF00B060),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nisab Threshold Basis',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNisabToggleButton(
                        title: 'Silver (595g)',
                        subtitle: 'Recommended for cash',
                        selected: _useSilverNisab,
                        onTap: () => _toggleNisabStandard(true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildNisabToggleButton(
                        title: 'Gold (85g)',
                        subtitle: 'Gold standard',
                        selected: !_useSilverNisab,
                        onTap: () => _toggleNisabStandard(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildAmountField(
                  controller: _gramPriceController,
                  label: _useSilverNisab
                      ? 'Current Silver Price per Gram'
                      : 'Current Gold Price per Gram',
                  hint: '0.00',
                  icon: Icons.scale_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('2. Zakatable Assets (Held for 1 Lunar Year)'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _buildAmountField(
                  controller: _cashController,
                  label: 'Cash on Hand & Bank Savings',
                  hint: '0.00',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(height: 14),
                _buildAmountField(
                  controller: _goldSilverController,
                  label: 'Gold & Silver Value',
                  hint: '0.00',
                  icon: Icons.diamond_outlined,
                ),
                const SizedBox(height: 14),
                _buildAmountField(
                  controller: _businessController,
                  label: 'Business Inventory & Trade Goods',
                  hint: '0.00',
                  icon: Icons.storefront_outlined,
                ),
                const SizedBox(height: 14),
                _buildAmountField(
                  controller: _investmentsController,
                  label: 'Investments, Shares & Crypto',
                  hint: '0.00',
                  icon: Icons.trending_up_rounded,
                ),
                const SizedBox(height: 14),
                _buildAmountField(
                  controller: _receivablesController,
                  label: 'Loans / Money Owed to You',
                  hint: '0.00',
                  icon: Icons.payments_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('3. Deductible Liabilities'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
            ),
            child: _buildAmountField(
              controller: _debtsController,
              label: 'Short-Term Debts & Bills Due Now',
              hint: '0.00',
              icon: Icons.money_off_csred_outlined,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF00B060),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Quick Zakat Rules',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Zakat is 2.5% (1/40th) of net eligible wealth held above the Nisab threshold for one full Islamic lunar year (Hawl).\n'
                  '• Personal home, primary car, and daily household items are exempt from Zakat.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00B060).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Zakat Due (2.5%)',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _isAboveNisab
                      ? const Color(0xFF00B060).withValues(alpha: 0.22)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isAboveNisab ? 'Above Nisab' : 'Below Nisab',
                  style: TextStyle(
                    color: _isAboveNisab
                        ? const Color(0xFF00B060)
                        : Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatMoney(_zakatDue),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),
          _buildSummaryRow('Net Zakatable Wealth', _formatMoney(_netWealth)),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Nisab Threshold (${_useSilverNisab ? "595g Silver" : "85g Gold"})',
            _formatMoney(_nisabThreshold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF00B060),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildNisabToggleButton({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF00B060).withValues(alpha: 0.18)
              : const Color(0xFF141718),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF00B060) : const Color(0xFF2B3033),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: _onFieldChanged,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30),
            prefixIcon: Icon(icon, color: const Color(0xFF00B060), size: 20),
            prefixText: '$_currencySymbol ',
            prefixStyle: const TextStyle(
              color: Color(0xFF00B060),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFF141718),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF00B060)),
            ),
          ),
        ),
      ],
    );
  }
}
