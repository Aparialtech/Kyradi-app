import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../widgets/app_mesh_background.dart';
import '../../widgets/section_card.dart';

const _adminTextPrimary = Color(0xFFF3F7FF);
const _adminTextSecondary = Color(0xFFA9B7D3);
const _adminCardBase = Color(0xFF112540);
const _adminCardBaseSoft = Color(0xFF0D1C35);
const _adminAccent = Color(0xFF14B8A6);

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  bool _loading = true;
  String? _error;
  int _tab = 0;

  Map<String, dynamic> _overview = const {};
  List<Map<String, dynamic>> _locations = const [];
  List<Map<String, dynamic>> _campaigns = const [];
  List<Map<String, dynamic>> _users = const [];

  final TextEditingController _userSearchController = TextEditingController();
  bool _showReservationInsights = true;
  bool _showPaymentInsights = true;
  bool _showLocationInsights = true;
  bool _showActivityInsights = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        ApiService.getAdminOverview(),
        ApiService.getAdminLocations(),
        ApiService.getAdminCampaigns(),
        ApiService.getAdminUsers(q: _userSearchController.text.trim()),
      ]);
      if (!mounted) return;

      final overview = results[0];
      final locations = results[1];
      final campaigns = results[2];
      final users = results[3];

      if (overview['ok'] != true) {
        throw Exception(
          (overview['error'] ?? 'ADMIN_OVERVIEW_FAILED').toString(),
        );
      }
      if (locations['ok'] != true) {
        throw Exception(
          (locations['error'] ?? 'ADMIN_LOCATIONS_FAILED').toString(),
        );
      }
      if (campaigns['ok'] != true) {
        throw Exception(
          (campaigns['error'] ?? 'ADMIN_CAMPAIGNS_FAILED').toString(),
        );
      }
      if (users['ok'] != true) {
        throw Exception((users['error'] ?? 'ADMIN_USERS_FAILED').toString());
      }

      setState(() {
        _overview = Map<String, dynamic>.from(overview);
        _locations = _asMapList(locations['locations'] ?? locations['data']);
        _campaigns = _asMapList(campaigns['campaigns'] ?? campaigns['data']);
        _users = _asMapList(users['users'] ?? users['data']);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<Map<String, dynamic>> _asMapList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> _openLocationEditor({Map<String, dynamic>? item}) async {
    final nameController = TextEditingController(
      text: item?['name']?.toString() ?? '',
    );
    final addressController = TextEditingController(
      text: item?['address']?.toString() ?? '',
    );
    final idController = TextEditingController(
      text: item?['_id']?.toString() ?? item?['id']?.toString() ?? '',
    );
    final totalSlotsController = TextEditingController(
      text: (item?['totalSlots'] ?? 0).toString(),
    );
    final availableSlotsController = TextEditingController(
      text: (item?['availableSlots'] ?? 0).toString(),
    );
    final latController = TextEditingController(
      text: (item?['latitude'] ?? 0).toString(),
    );
    final lngController = TextEditingController(
      text: (item?['longitude'] ?? 0).toString(),
    );
    bool isActive = item?['isActive'] != false;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item == null ? 'Lokasyon Ekle' : 'Lokasyon Duzenle',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Field(label: 'ID', controller: idController),
                    _Field(label: 'Lokasyon adi', controller: nameController),
                    _Field(label: 'Adres', controller: addressController),
                    Row(
                      children: [
                        Expanded(
                          child: _Field(
                            label: 'Toplam Slot',
                            controller: totalSlotsController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Field(
                            label: 'Musait Slot',
                            controller: availableSlotsController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _Field(
                            label: 'Latitude',
                            controller: latController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Field(
                            label: 'Longitude',
                            controller: lngController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: isActive,
                      title: const Text('Aktif'),
                      onChanged: (value) =>
                          setSheetState(() => isActive = value),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(item == null ? 'Kaydet' : 'Guncelle'),
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

    if (saved != true || !mounted) return;
    final payload = <String, dynamic>{
      'id': idController.text.trim(),
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'totalSlots': int.tryParse(totalSlotsController.text.trim()) ?? 0,
      'availableSlots': int.tryParse(availableSlotsController.text.trim()) ?? 0,
      'latitude': double.tryParse(latController.text.trim()) ?? 0,
      'longitude': double.tryParse(lngController.text.trim()) ?? 0,
      'isActive': isActive,
    };
    Map<String, dynamic> response;
    if (item == null) {
      response = await ApiService.createAdminLocation(payload);
    } else {
      final id = (item['_id'] ?? item['id'] ?? '').toString();
      response = await ApiService.updateAdminLocation(id, payload);
    }
    if (!mounted) return;
    if (response['ok'] == true) {
      await _loadAll();
      return;
    }
    _showError(
      'Lokasyon kaydedilemedi: ${response['error'] ?? response['message'] ?? 'Hata'}',
    );
  }

  Future<void> _openCampaignEditor({Map<String, dynamic>? item}) async {
    final titleController = TextEditingController(
      text: item?['title']?.toString() ?? '',
    );
    final subtitleController = TextEditingController(
      text: item?['subtitle']?.toString() ?? '',
    );
    final detailsController = TextEditingController(
      text: item?['details']?.toString() ?? '',
    );
    final iconController = TextEditingController(
      text: item?['iconKey']?.toString() ?? 'local_offer_outlined',
    );
    final gradientStartController = TextEditingController(
      text: item?['gradientStart']?.toString() ?? '#0F766E',
    );
    final gradientEndController = TextEditingController(
      text: item?['gradientEnd']?.toString() ?? '#5EEAD4',
    );
    bool isActive = item?['isActive'] != false;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item == null ? 'Kampanya Ekle' : 'Kampanya Duzenle',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Field(label: 'Baslik', controller: titleController),
                    _Field(label: 'Alt baslik', controller: subtitleController),
                    _Field(
                      label: 'Detay',
                      controller: detailsController,
                      maxLines: 4,
                    ),
                    _Field(label: 'Ikon anahtari', controller: iconController),
                    Row(
                      children: [
                        Expanded(
                          child: _Field(
                            label: 'Gradient baslangic',
                            controller: gradientStartController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Field(
                            label: 'Gradient bitis',
                            controller: gradientEndController,
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: isActive,
                      title: const Text('Aktif'),
                      onChanged: (value) =>
                          setSheetState(() => isActive = value),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(item == null ? 'Kaydet' : 'Guncelle'),
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

    if (saved != true || !mounted) return;
    final payload = <String, dynamic>{
      'title': titleController.text.trim(),
      'subtitle': subtitleController.text.trim(),
      'details': detailsController.text.trim(),
      'iconKey': iconController.text.trim(),
      'gradientStart': gradientStartController.text.trim(),
      'gradientEnd': gradientEndController.text.trim(),
      'isActive': isActive,
    };
    Map<String, dynamic> response;
    if (item == null) {
      response = await ApiService.createAdminCampaign(payload);
    } else {
      final id = (item['_id'] ?? item['id'] ?? '').toString();
      response = await ApiService.updateAdminCampaign(id, payload);
    }
    if (!mounted) return;
    if (response['ok'] == true) {
      await _loadAll();
      return;
    }
    _showError(
      'Kampanya kaydedilemedi: ${response['error'] ?? response['message'] ?? 'Hata'}',
    );
  }

  Future<void> _openUserActivities(Map<String, dynamic> user) async {
    final userId = (user['id'] ?? '').toString();
    if (userId.isEmpty) return;
    final response = await ApiService.getAdminUserActivities(userId);
    if (!mounted) return;
    if (response['ok'] != true) {
      _showError(
        response['error']?.toString() ?? 'Kullanici hareketleri alinamadi',
      );
      return;
    }
    final activities = _asMapList(response['activities']);
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user['name'] ?? ''} ${user['surname'] ?? ''}'.trim(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                user['email']?.toString() ?? '',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: activities.isEmpty
                    ? const Center(child: Text('Hareket bulunamadi'))
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final item = activities[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              item['dropLocationName']?.toString() ?? '-',
                            ),
                            subtitle: Text(
                              '${item['status'] ?? '-'} • ${item['paymentStatus'] ?? '-'}',
                            ),
                            trailing: Text(
                              '₺${item['totalPrice'] ?? 0}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemCount: activities.length,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yonetim panelinden cik'),
        content: const Text(
          'Oturumu kapatip admin giris ekranina donulsun mu?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cikis yap'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) return;
    await ApiService.clearSession();
    if (!mounted) return;
    context.go('/admin/login');
  }

  @override
  Widget build(BuildContext context) {
    final recent = _asMapList(_overview['recentActivity']);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _adminTextPrimary,
        title: const Text(
          'Yonetim Paneli',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
        actions: [
          IconButton(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh_rounded, color: _adminTextPrimary),
          ),
          IconButton(
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout_rounded, color: _adminTextPrimary),
            tooltip: 'Cikis yap',
          ),
        ],
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          else
            RefreshIndicator(
              onRefresh: _loadAll,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: _GlassHero(overview: _overview),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: CupertinoSlidingSegmentedControl<int>(
                        backgroundColor: Colors.white.withValues(alpha: 0.11),
                        thumbColor: Colors.white.withValues(alpha: 0.22),
                        groupValue: _tab,
                        children: const {
                          0: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              'Dashboard',
                              style: TextStyle(
                                color: _adminTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          1: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              'Lokasyon',
                              style: TextStyle(
                                color: _adminTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          2: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              'Kampanya',
                              style: TextStyle(
                                color: _adminTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          3: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              'Kullanicilar',
                              style: TextStyle(
                                color: _adminTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          if (value == null) return;
                          setState(() => _tab = value);
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        _buildTabContent(context, recent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildTabContent(
    BuildContext context,
    List<Map<String, dynamic>> recent,
  ) {
    switch (_tab) {
      case 1:
        return [
          _HeaderAction(
            title: 'Lokasyonlar',
            actionLabel: 'Yeni Ekle',
            onAction: () => _openLocationEditor(),
          ),
          const SizedBox(height: 10),
          ..._locations.map(
            (item) => _GlassTile(
              title: item['name']?.toString() ?? '-',
              subtitle:
                  '${item['address'] ?? '-'} • ${item['availableSlots'] ?? 0}/${item['totalSlots'] ?? 0} slot',
              badge: item['isActive'] == false ? 'Pasif' : 'Aktif',
              onTap: () => _openLocationEditor(item: item),
            ),
          ),
        ];
      case 2:
        return [
          _HeaderAction(
            title: 'Kampanyalar',
            actionLabel: 'Yeni Ekle',
            onAction: () => _openCampaignEditor(),
          ),
          const SizedBox(height: 10),
          ..._campaigns.map(
            (item) => _GlassTile(
              title: item['title']?.toString() ?? '-',
              subtitle: item['subtitle']?.toString() ?? '-',
              badge: item['isActive'] == false ? 'Pasif' : 'Aktif',
              onTap: () => _openCampaignEditor(item: item),
            ),
          ),
        ];
      case 3:
        return [
          TextField(
            controller: _userSearchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _loadAll(),
            decoration: InputDecoration(
              hintText: 'Kullanici ara (isim veya e-posta)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: _loadAll,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ..._users.map(
            (item) => _GlassTile(
              title: '${item['name'] ?? ''} ${item['surname'] ?? ''}'.trim(),
              subtitle:
                  '${item['email'] ?? '-'} • ${item['luggageCount'] ?? 0} bavul',
              badge: (item['role'] ?? 'user').toString(),
              onTap: () => _openUserActivities(item),
            ),
          ),
        ];
      default:
        return _buildDashboardSection(recent);
    }
  }

  List<Widget> _buildDashboardSection(List<Map<String, dynamic>> recent) {
    final users = Map<String, dynamic>.from(
      _overview['users'] as Map? ?? const {},
    );
    final locations = Map<String, dynamic>.from(
      _overview['locations'] as Map? ?? const {},
    );
    final campaigns = Map<String, dynamic>.from(
      _overview['campaigns'] as Map? ?? const {},
    );
    final luggage = Map<String, dynamic>.from(
      _overview['luggage'] as Map? ?? const {},
    );
    final statusCounts = Map<String, dynamic>.from(
      luggage['statusCounts'] as Map? ?? const {},
    );
    final paymentCounts = Map<String, dynamic>.from(
      luggage['paymentCounts'] as Map? ?? const {},
    );
    final metricCards = [
      _KpiCardData(
        id: 'users_total',
        title: 'Kullanicilar',
        value: _asInt(users['total']),
        subtitle: 'Toplam hesap',
        icon: Icons.people_alt_outlined,
        gradient: const [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
      ),
      _KpiCardData(
        id: 'users_7d',
        title: 'Yeni 7 gun',
        value: _asInt(users['last7d']),
        subtitle: 'Son kayitlar',
        icon: Icons.person_add_alt_1_rounded,
        gradient: const [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
      ),
      _KpiCardData(
        id: 'luggage_total',
        title: 'Rezervasyon',
        value: _asInt(luggage['total']),
        subtitle: 'Tum bavullar',
        icon: Icons.luggage_outlined,
        gradient: const [Color(0xFF6366F1), Color(0xFF818CF8)],
      ),
      _KpiCardData(
        id: 'payment_pending',
        title: 'Odeme bekleyen',
        value: _asInt(luggage['paymentPending']),
        subtitle: 'Pending/failed',
        icon: Icons.warning_amber_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      ),
      _KpiCardData(
        id: 'revenue_total',
        title: 'Toplam gelir',
        value: _asInt(luggage['totalRevenue']),
        subtitle: 'Paid toplami (TRY)',
        icon: Icons.payments_outlined,
        gradient: const [Color(0xFF0F766E), Color(0xFF14B8A6)],
        prefix: '₺',
      ),
      _KpiCardData(
        id: 'locations_active',
        title: 'Aktif lokasyon',
        value: _asInt(locations['active']),
        subtitle: '${_asInt(locations['total'])} icinde aktif',
        icon: Icons.location_on_outlined,
        gradient: const [Color(0xFF9333EA), Color(0xFFA855F7)],
      ),
    ];

    return [
      _HeaderAction(title: 'Canli Dashboard'),
      const SizedBox(height: 10),
      _KpiGrid(
        cards: metricCards,
        onTap: (card) => _showDashboardMetricSheet(
          card: card,
          users: users,
          locations: locations,
          luggage: luggage,
          campaigns: campaigns,
          statusCounts: statusCounts,
          paymentCounts: paymentCounts,
        ),
      ),
      const SizedBox(height: 12),
      _PanelCard(
        title: 'Dashboard Panelleri',
        icon: Icons.tune_rounded,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InsightToggleChip(
              label: 'Rezervasyon',
              icon: Icons.bar_chart_rounded,
              active: _showReservationInsights,
              onTap: () => setState(
                () => _showReservationInsights = !_showReservationInsights,
              ),
            ),
            _InsightToggleChip(
              label: 'Odeme',
              icon: Icons.pie_chart_outline_rounded,
              active: _showPaymentInsights,
              onTap: () =>
                  setState(() => _showPaymentInsights = !_showPaymentInsights),
            ),
            _InsightToggleChip(
              label: 'Lokasyon',
              icon: Icons.location_city_outlined,
              active: _showLocationInsights,
              onTap: () => setState(
                () => _showLocationInsights = !_showLocationInsights,
              ),
            ),
            _InsightToggleChip(
              label: 'Akis',
              icon: Icons.auto_graph_rounded,
              active: _showActivityInsights,
              onTap: () => setState(
                () => _showActivityInsights = !_showActivityInsights,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _ExpandableInsightPanel(
        title: 'Rezervasyon Analizi',
        icon: Icons.bar_chart_rounded,
        expanded: _showReservationInsights,
        onToggle: () => setState(
          () => _showReservationInsights = !_showReservationInsights,
        ),
        child: _StatusDistributionCard(statusCounts: statusCounts),
      ),
      const SizedBox(height: 14),
      _ExpandableInsightPanel(
        title: 'Odeme Analizi',
        icon: Icons.pie_chart_outline_rounded,
        expanded: _showPaymentInsights,
        onToggle: () =>
            setState(() => _showPaymentInsights = !_showPaymentInsights),
        child: _PaymentDistributionCard(paymentCounts: paymentCounts),
      ),
      const SizedBox(height: 14),
      const _PanelCard(
        title: 'Dataset Donut Demo',
        icon: Icons.donut_large_rounded,
        child: _SampleDatasetPanel(),
      ),
      const SizedBox(height: 14),
      _ExpandableInsightPanel(
        title: 'Lokasyon Doluluk Analizi',
        icon: Icons.location_city_outlined,
        expanded: _showLocationInsights,
        onToggle: () =>
            setState(() => _showLocationInsights = !_showLocationInsights),
        child: _LocationUtilizationCard(locations: _locations),
      ),
      const SizedBox(height: 14),
      _ExpandableInsightPanel(
        title: 'Hareket Akisi',
        icon: Icons.auto_graph_rounded,
        expanded: _showActivityInsights,
        onToggle: () =>
            setState(() => _showActivityInsights = !_showActivityInsights),
        child: _ActivityTimelineCard(recent: recent),
      ),
      const SizedBox(height: 14),
      _HeaderAction(
        title: 'Son Hareketler',
        actionLabel: 'Tumunu Yenile',
        onAction: _loadAll,
      ),
      const SizedBox(height: 8),
      if (recent.isEmpty)
        const _GlassTile(
          title: 'Hareket yok',
          subtitle: 'Heniz islem kaydi bulunmuyor.',
        ),
      ...recent.map(
        (item) => _GlassTile(
          title: item['userName']?.toString() ?? '-',
          subtitle:
              '${item['dropLocationName'] ?? '-'} • ${item['status'] ?? '-'} • ${item['paymentStatus'] ?? '-'}',
          badge: '₺${item['totalPrice'] ?? 0}',
        ),
      ),
      const SizedBox(height: 6),
      _HeaderAction(title: 'Hizli Eylemler'),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              label: 'Lokasyon Ekle',
              icon: Icons.add_location_alt_outlined,
              accent: const Color(0xFF0EA5E9),
              onTap: () => _openLocationEditor(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickActionButton(
              label: 'Kampanya Ekle',
              icon: Icons.campaign_outlined,
              accent: const Color(0xFF9333EA),
              onTap: () => _openCampaignEditor(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _QuickActionButton(
        label: 'Kullanicilari Yenile',
        icon: Icons.sync_rounded,
        accent: const Color(0xFF0F766E),
        onTap: _loadAll,
      ),
      const SizedBox(height: 12),
      _GlassTile(
        title: 'Aktif kampanyalar',
        subtitle:
            '${_asInt(campaigns['active'])} aktif / ${_asInt(campaigns['total'])} toplam',
      ),
    ];
  }

  int _asInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '0').toString()) ?? 0;
  }

  Future<void> _showDashboardMetricSheet({
    required _KpiCardData card,
    required Map<String, dynamic> users,
    required Map<String, dynamic> locations,
    required Map<String, dynamic> luggage,
    required Map<String, dynamic> campaigns,
    required Map<String, dynamic> statusCounts,
    required Map<String, dynamic> paymentCounts,
  }) async {
    final paidCount = _asInt(paymentCounts['paid']);
    final pendingCount = _asInt(paymentCounts['pending']);
    final failedCount = _asInt(paymentCounts['failed']);
    final totalLuggage = _asInt(luggage['total']);
    final revenue = _asInt(luggage['totalRevenue']);
    final avgTicket = paidCount <= 0 ? 0 : (revenue / paidCount).round();
    final details = switch (card.id) {
      'users_total' => [
        'Toplam kayitli kullanici: ${_asInt(users['total'])}',
        'Son 7 gun kayit: ${_asInt(users['last7d'])}',
      ],
      'users_7d' => [
        'Son 7 gun kayit: ${_asInt(users['last7d'])}',
        'Toplam kullanicilar: ${_asInt(users['total'])}',
      ],
      'luggage_total' => [
        'Toplam rezervasyon: $totalLuggage',
        'Dropped: ${_asInt(statusCounts['dropped'])}',
        'Awaiting: ${_asInt(statusCounts['awaiting_drop'])}',
        'Picked up: ${_asInt(statusCounts['picked_up'])}',
      ],
      'payment_pending' => [
        'Bekleyen odeme: $pendingCount',
        'Basarisiz odeme: $failedCount',
        'Paid odeme: $paidCount',
      ],
      'revenue_total' => [
        'Toplam gelir: ₺$revenue',
        'Paid rezervasyon adedi: $paidCount',
        'Ortalama bilet: ₺$avgTicket',
      ],
      'locations_active' => [
        'Aktif lokasyon: ${_asInt(locations['active'])}',
        'Toplam lokasyon: ${_asInt(locations['total'])}',
        'Aktif kampanya: ${_asInt(campaigns['active'])}',
      ],
      _ => [card.subtitle],
    };
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ThreeDIconBadge(icon: card.icon, accent: card.gradient.first),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          card.subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${card.prefix}${card.value}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: card.gradient.first,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...details.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 7),
                        decoration: BoxDecoration(
                          color: card.gradient.first,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          line,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlassHero extends StatelessWidget {
  const _GlassHero({required this.overview});

  final Map<String, dynamic> overview;

  @override
  Widget build(BuildContext context) {
    final users = Map<String, dynamic>.from(
      overview['users'] as Map? ?? const {},
    );
    final locations = Map<String, dynamic>.from(
      overview['locations'] as Map? ?? const {},
    );
    final campaigns = Map<String, dynamic>.from(
      overview['campaigns'] as Map? ?? const {},
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _adminCardBase.withValues(alpha: 0.9),
                _adminCardBaseSoft.withValues(alpha: 0.84),
                const Color(0xFF143456).withValues(alpha: 0.82),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kyradi Control Center',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _adminTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Canli rezervasyon, odeme, lokasyon ve kampanya paneli',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: _adminTextSecondary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatChip(
                    label: 'Kullanici',
                    value: '${users['total'] ?? 0}',
                  ),
                  _StatChip(
                    label: 'Lokasyon',
                    value: '${locations['active'] ?? 0} aktif',
                  ),
                  _StatChip(
                    label: 'Kampanya',
                    value: '${campaigns['active'] ?? 0} aktif',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: _adminTextSecondary),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: _adminTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: _adminTextPrimary,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              foregroundColor: _adminTextPrimary,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
            ),
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _GlassTile extends StatelessWidget {
  const _GlassTile({
    required this.title,
    required this.subtitle,
    this.badge,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: _adminCardBase.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _adminTextPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _adminTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _adminAccent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: _adminAccent.withValues(alpha: 0.34),
                      ),
                    ),
                    child: Text(
                      badge!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _adminTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiCardData {
  const _KpiCardData({
    required this.id,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.prefix = '',
  });

  final String id;
  final String title;
  final int value;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String prefix;
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.cards, required this.onTap});

  final List<_KpiCardData> cards;
  final ValueChanged<_KpiCardData> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final columns = constraints.maxWidth >= 980
            ? 4
            : constraints.maxWidth >= 700
            ? 3
            : 2;
        final itemWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards
              .map(
                (card) => SizedBox(
                  width: itemWidth,
                  child: _KpiCard(data: card, onTap: () => onTap(card)),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data, required this.onTap});

  final _KpiCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Transform.scale(
          scale: 0.98 + (0.02 * t),
          child: Opacity(opacity: t, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _adminCardBase.withValues(alpha: 0.88),
                  data.gradient.first.withValues(alpha: 0.16),
                  _adminCardBaseSoft.withValues(alpha: 0.88),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThreeDIconBadge(icon: data.icon, accent: data.gradient.first),
                const SizedBox(height: 8),
                Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _adminTextSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.prefix}${data.value}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: _adminTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: data.gradient.last.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusDistributionCard extends StatelessWidget {
  const _StatusDistributionCard({required this.statusCounts});

  final Map<String, dynamic> statusCounts;

  @override
  Widget build(BuildContext context) {
    final items =
        statusCounts.entries
            .map(
              (e) => MapEntry(
                _statusLabel(e.key),
                e.value is num
                    ? e.value.toInt()
                    : int.tryParse('${e.value}') ?? 0,
              ),
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = items.isEmpty ? 1 : items.first.value;
    return items.isEmpty
        ? const Text('Veri bulunamadi')
        : Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AnimatedBarRow(
                      label: item.key,
                      value: item.value,
                      maxValue: maxValue,
                    ),
                  ),
                )
                .toList(),
          );
  }

  String _statusLabel(String raw) {
    switch (raw) {
      case 'awaiting_drop':
        return 'Awaiting Drop';
      case 'dropped':
        return 'Dropped';
      case 'picked_up':
        return 'Picked Up';
      case 'cancelled':
        return 'Cancelled';
      case 'assigned':
        return 'Assigned';
      default:
        return raw;
    }
  }
}

class _AnimatedBarRow extends StatelessWidget {
  const _AnimatedBarRow({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue <= 0
        ? 0.0
        : (value / maxValue).clamp(0, 1).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: _adminTextSecondary),
              ),
            ),
            Text(
              '$value',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: _adminTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(99),
          ),
          clipBehavior: Clip.antiAlias,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: t,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF3B82F6)],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PaymentDistributionCard extends StatelessWidget {
  const _PaymentDistributionCard({required this.paymentCounts});

  final Map<String, dynamic> paymentCounts;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, int>> entries = paymentCounts.entries
        .map<MapEntry<String, int>>(
          (e) => MapEntry<String, int>(
            e.key,
            e.value is num ? e.value.toInt() : int.tryParse('${e.value}') ?? 0,
          ),
        )
        .where((e) => e.value > 0)
        .toList();
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);
    return entries.isEmpty
        ? const Text('Veri bulunamadi')
        : LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 560;
              final legends = entries
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _LegendRow(
                        color: _palette[entry.key % _palette.length],
                        label: _paymentLabel(entry.value.key),
                        value:
                            '${entry.value.value} (${((entry.value.value / total) * 100).toStringAsFixed(0)}%)',
                      ),
                    ),
                  )
                  .toList();

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 170,
                      child: Center(
                        child: _AnimatedDonutChart(entries: entries),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...legends,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 152,
                      child: _AnimatedDonutChart(entries: entries),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: legends,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }

  String _paymentLabel(String raw) {
    switch (raw) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'unpaid':
        return 'Unpaid';
      default:
        return raw;
    }
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: _adminTextSecondary),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: _adminTextPrimary,
          ),
        ),
      ],
    );
  }
}

class _SampleDatasetPanel extends StatelessWidget {
  const _SampleDatasetPanel();

  static const List<_PieDatum> _data = [
    _PieDatum(label: 'Red', value: 300, color: Color(0xFFFF6384)),
    _PieDatum(label: 'Blue', value: 50, color: Color(0xFF36A2EB)),
    _PieDatum(label: 'Yellow', value: 100, color: Color(0xFFFFCD56)),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _data.fold<int>(0, (sum, item) => sum + item.value);
    final legendWidgets = _data
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _LegendRow(
              color: item.color,
              label: item.label,
              value:
                  '${item.value} (${((item.value / total) * 100).toStringAsFixed(0)}%)',
            ),
          ),
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;

        final chart = SizedBox(
          height: isCompact ? 190 : 162,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, progress, _) {
              return CustomPaint(
                painter: _OffsetPiePainter(
                  data: _data,
                  progress: progress,
                  offset: 4,
                ),
                child: Center(
                  child: Text(
                    '$total',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _adminTextPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [chart, const SizedBox(height: 10), ...legendWidgets],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: chart),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: legendWidgets,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PieDatum {
  const _PieDatum({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}

class _OffsetPiePainter extends CustomPainter {
  _OffsetPiePainter({
    required this.data,
    required this.progress,
    required this.offset,
  });

  final List<_PieDatum> data;
  final double progress;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<int>(0, (sum, item) => sum + item.value);
    if (total <= 0) return;
    final stroke = math.max(13.0, size.shortestSide * 0.14);
    final side = math.min(size.width, size.height);
    final baseRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: side,
      height: side,
    ).deflate(stroke / 2 + offset);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    var start = -math.pi / 2;
    for (final item in data) {
      final rawSweep = (item.value / total) * math.pi * 2;
      final sweep = rawSweep * progress;
      final mid = start + (sweep / 2);
      final dx = math.cos(mid) * offset;
      final dy = math.sin(mid) * offset;
      final rect = baseRect.shift(Offset(dx, dy));
      paint.color = item.color;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _OffsetPiePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }
}

class _AnimatedDonutChart extends StatelessWidget {
  const _AnimatedDonutChart({required this.entries});

  final List<MapEntry<String, int>> entries;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return CustomPaint(
          painter: _DonutPainter(entries: entries, progress: progress),
          child: Center(
            child: Text(
              '${entries.fold<int>(0, (sum, e) => sum + e.value)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: _adminTextPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.entries, required this.progress});

  final List<MapEntry<String, int>> entries;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);
    if (total <= 0) return;
    final stroke = math.max(12.0, size.shortestSide * 0.13);
    final side = math.min(size.width, size.height);
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: side,
      height: side,
    ).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    var start = -math.pi / 2;
    for (var i = 0; i < entries.length; i++) {
      final sweep = (entries[i].value / total) * math.pi * 2 * progress;
      paint.color = _palette[i % _palette.length];
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.entries != entries;
  }
}

class _LocationUtilizationCard extends StatelessWidget {
  const _LocationUtilizationCard({required this.locations});

  final List<Map<String, dynamic>> locations;

  @override
  Widget build(BuildContext context) {
    final sorted = [...locations]
      ..sort((a, b) {
        final aTotal = _intValue(a['totalSlots']);
        final aAvail = _intValue(a['availableSlots']);
        final bTotal = _intValue(b['totalSlots']);
        final bAvail = _intValue(b['availableSlots']);
        final aRate = aTotal <= 0 ? 0.0 : 1 - (aAvail / aTotal);
        final bRate = bTotal <= 0 ? 0.0 : 1 - (bAvail / bTotal);
        return bRate.compareTo(aRate);
      });
    final top = sorted.take(4).toList();

    return top.isEmpty
        ? const Text('Lokasyon verisi yok')
        : Column(
            children: top.map((item) {
              final total = _intValue(item['totalSlots']);
              final available = _intValue(item['availableSlots']);
              final used = math.max(total - available, 0);
              final ratio = total <= 0 ? 0.0 : used / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['name']?.toString() ?? '-',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: _adminTextPrimary,
                                ),
                          ),
                        ),
                        Text(
                          '$used/$total',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: _adminTextSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: ratio),
                        duration: const Duration(milliseconds: 850),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF14B8A6),
                                      Color(0xFF0EA5E9),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }

  int _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '0').toString()) ?? 0;
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({
    required this.title,
    required this.child,
    this.icon,
    this.action,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _adminCardBaseSoft.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      ThreeDIconBadge(
                        icon: icon!,
                        accent: const Color(0xFF0F766E),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _adminTextPrimary,
                        ),
                      ),
                    ),
                    if (action != null) action!,
                  ],
                ),
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                _adminCardBase.withValues(alpha: 0.8),
                accent.withValues(alpha: 0.24),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThreeDIconBadge(icon: icon, accent: accent),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _adminTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableInsightPanel extends StatelessWidget {
  const _ExpandableInsightPanel({
    required this.title,
    required this.icon,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _PanelCard(
      title: title,
      icon: icon,
      action: TextButton.icon(
        onPressed: onToggle,
        icon: Icon(
          expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 18,
        ),
        label: Text(expanded ? 'Gizle' : 'Ac'),
      ),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 260),
        firstCurve: Curves.easeOutCubic,
        secondCurve: Curves.easeOutCubic,
        sizeCurve: Curves.easeOutCubic,
        crossFadeState: expanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: child,
        secondChild: const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text(
            'Panel gizli. Ac butonuna basarak detaylari gor.',
            style: TextStyle(color: _adminTextSecondary),
          ),
        ),
      ),
    );
  }
}

class _InsightToggleChip extends StatelessWidget {
  const _InsightToggleChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? _adminAccent.withValues(alpha: 0.22)
                : _adminCardBase.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? _adminAccent.withValues(alpha: 0.52)
                  : Colors.white.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThreeDIconBadge(
                icon: icon,
                accent: active ? _adminAccent : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: active ? _adminTextPrimary : _adminTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTimelineCard extends StatelessWidget {
  const _ActivityTimelineCard({required this.recent});

  final List<Map<String, dynamic>> recent;

  @override
  Widget build(BuildContext context) {
    if (recent.isEmpty) return const Text('Hareket verisi bulunamadi');
    final buckets = List<int>.filled(7, 0);
    final now = DateTime.now();
    for (final item in recent) {
      final raw = (item['updatedAt'] ?? item['createdAt'])?.toString();
      if (raw == null || raw.isEmpty) continue;
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) continue;
      final diff = now.difference(parsed.toLocal()).inDays;
      if (diff >= 0 && diff < 7) buckets[6 - diff] += 1;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, progress, _) {
              return CustomPaint(
                painter: _ActivityChartPainter(
                  values: buckets,
                  progress: progress,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Son 7 gunde toplam ${buckets.fold<int>(0, (a, b) => a + b)} hareket izlendi.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: _adminTextSecondary),
        ),
      ],
    );
  }
}

class _ActivityChartPainter extends CustomPainter {
  _ActivityChartPainter({required this.values, required this.progress});

  final List<int> values;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxValue = math.max(1, values.reduce(math.max));
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = size.height - ((values[i] / maxValue) * size.height * progress);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final cX = (prev.dx + curr.dx) / 2;
      path.quadraticBezierTo(cX, prev.dy, curr.dx, curr.dy);
    }

    final glow = Paint()
      ..color = const Color(0xFF0EA5E9).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final line = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF14B8A6)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);
    for (final p in points) {
      canvas.drawCircle(p, 3.2, Paint()..color = const Color(0xFF0EA5E9));
      canvas.drawCircle(p, 1.4, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _ActivityChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.values != values;
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

const List<Color> _palette = [
  Color(0xFF0EA5E9),
  Color(0xFF14B8A6),
  Color(0xFF6366F1),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF9333EA),
];
