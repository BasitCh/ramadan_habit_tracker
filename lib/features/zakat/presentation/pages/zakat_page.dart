import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';

class ZakatPage extends StatefulWidget {
  const ZakatPage({super.key});

  @override
  State<ZakatPage> createState() => _ZakatPageState();
}

class _ZakatPageState extends State<ZakatPage> {
  final _cashController = TextEditingController();
  final _metaController = TextEditingController(); // Gold/Silver
  final _businessController = TextEditingController(); // Inventory
  final _investmentsController = TextEditingController();
  final _liabilitiesController = TextEditingController();

  double _totalAssets = 0;
  double _totalLiabilities = 0;
  double _netAssets = 0;
  double _zakatDue = 0;

  @override
  void dispose() {
    _cashController.dispose();
    _metaController.dispose();
    _businessController.dispose();
    _investmentsController.dispose();
    _liabilitiesController.dispose();
    super.dispose();
  }

  void _calculateZakat() {
    double cash = double.tryParse(_cashController.text) ?? 0;
    double metals = double.tryParse(_metaController.text) ?? 0;
    double business = double.tryParse(_businessController.text) ?? 0;
    double investments = double.tryParse(_investmentsController.text) ?? 0;
    double liabilities = double.tryParse(_liabilitiesController.text) ?? 0;

    setState(() {
      _totalAssets = cash + metals + business + investments;
      _totalLiabilities = liabilities;
      _netAssets = _totalAssets - _totalLiabilities;

      // Zakat is 2.5% of net assets if positive
      if (_netAssets > 0) {
        _zakatDue = _netAssets * 0.025;
      } else {
        _zakatDue = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Zakat Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultCard(),
            const SizedBox(height: 24),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL ZAKAT PAYABLE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_zakatDue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildResultItem(
                'Net Assets',
                '\$${_netAssets.toStringAsFixed(2)}',
              ),
              _buildResultItem(
                'Liabilities',
                '\$${_totalLiabilities.toStringAsFixed(2)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Assets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField('Cash in hand & Bank', _cashController),
          const SizedBox(height: 12),
          _buildTextField('Value of Gold & Silver', _metaController),
          const SizedBox(height: 12),
          _buildTextField('Business Inventory', _businessController),
          const SizedBox(height: 12),
          _buildTextField('Investments & Shares', _investmentsController),
          const SizedBox(height: 24),
          const Text(
            'Liabilities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField('Debts Payable Immediately', _liabilitiesController),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculateZakat,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Calculate Zakat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$ ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
