import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../widgets/app_mesh_background.dart';

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

  @override
  Widget build(BuildContext context) {
    final recent = _asMapList(_overview['recentActivity']);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Yonetim Paneli'),
        actions: [
          IconButton(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh_rounded),
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
                        groupValue: _tab,
                        children: const {
                          0: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text('Dashboard'),
                          ),
                          1: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text('Lokasyon'),
                          ),
                          2: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text('Kampanya'),
                          ),
                          3: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text('Kullanicilar'),
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

    return [
      _HeaderAction(title: 'Canli Dashboard'),
      const SizedBox(height: 10),
      _KpiGrid(
        cards: [
          _KpiCardData(
            title: 'Kullanicilar',
            value: _asInt(users['total']),
            subtitle: 'Toplam hesap',
            icon: Icons.people_alt_outlined,
            gradient: const [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
          ),
          _KpiCardData(
            title: 'Yeni 7 gun',
            value: _asInt(users['last7d']),
            subtitle: 'Son kayitlar',
            icon: Icons.person_add_alt_1_rounded,
            gradient: const [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
          ),
          _KpiCardData(
            title: 'Rezervasyon',
            value: _asInt(luggage['total']),
            subtitle: 'Tum bavullar',
            icon: Icons.luggage_outlined,
            gradient: const [Color(0xFF6366F1), Color(0xFF818CF8)],
          ),
          _KpiCardData(
            title: 'Odeme bekleyen',
            value: _asInt(luggage['paymentPending']),
            subtitle: 'Pending/failed',
            icon: Icons.warning_amber_rounded,
            gradient: const [Color(0xFFF59E0B), Color(0xFFFBBF24)],
          ),
          _KpiCardData(
            title: 'Toplam gelir',
            value: _asInt(luggage['totalRevenue']),
            subtitle: 'Paid toplami (TRY)',
            icon: Icons.payments_outlined,
            gradient: const [Color(0xFF0F766E), Color(0xFF14B8A6)],
            prefix: '₺',
          ),
          _KpiCardData(
            title: 'Aktif lokasyon',
            value: _asInt(locations['active']),
            subtitle: '${_asInt(locations['total'])} icinde aktif',
            icon: Icons.location_on_outlined,
            gradient: const [Color(0xFF9333EA), Color(0xFFA855F7)],
          ),
        ],
      ),
      const SizedBox(height: 14),
      _DashboardDualCharts(
        statusCounts: statusCounts,
        paymentCounts: paymentCounts,
      ),
      const SizedBox(height: 14),
      _LocationUtilizationCard(locations: _locations),
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
              onTap: () => _openLocationEditor(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickActionButton(
              label: 'Kampanya Ekle',
              icon: Icons.campaign_outlined,
              onTap: () => _openCampaignEditor(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _QuickActionButton(
        label: 'Kullanicilari Yenile',
        icon: Icons.sync_rounded,
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
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xCCFFFFFF), Color(0x99F4F9FF)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 28,
                offset: const Offset(0, 14),
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
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Canli rezervasyon, odeme, lokasyon ve kampanya paneli',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF334155)),
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
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: const Color(0xFF475569)),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (actionLabel != null && onAction != null)
          FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
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
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
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
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF475569),
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
                      color: const Color(0xFF0F766E).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF0F766E),
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
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.prefix = '',
  });

  final String title;
  final int value;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String prefix;
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.cards});

  final List<_KpiCardData> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width > 700
            ? 3
            : width > 460
            ? 2
            : 1;
        final itemWidth = (width - (columns - 1) * 10) / columns;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cards
              .map(
                (card) => SizedBox(
                  width: itemWidth,
                  child: _KpiCard(data: card),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});

  final _KpiCardData data;

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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              data.gradient.first.withValues(alpha: 0.18),
              data.gradient.last.withValues(alpha: 0.12),
            ],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
          boxShadow: [
            BoxShadow(
              color: data.gradient.first.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(data.icon, size: 18, color: data.gradient.first),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF334155),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AnimatedNumberText(prefix: data.prefix, value: data.value),
            const SizedBox(height: 2),
            Text(
              data.subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNumberText extends StatelessWidget {
  const _AnimatedNumberText({required this.value, this.prefix = ''});

  final int value;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return Text(
          '$prefix${v.round()}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        );
      },
    );
  }
}

class _DashboardDualCharts extends StatelessWidget {
  const _DashboardDualCharts({
    required this.statusCounts,
    required this.paymentCounts,
  });

  final Map<String, dynamic> statusCounts;
  final Map<String, dynamic> paymentCounts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxWidth < 660;
        final left = _StatusDistributionCard(statusCounts: statusCounts);
        final right = _PaymentDistributionCard(paymentCounts: paymentCounts);
        if (vertical) {
          return Column(children: [left, const SizedBox(height: 10), right]);
        }
        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 10),
            Expanded(child: right),
          ],
        );
      },
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
    return _PanelCard(
      title: 'Rezervasyon Durum Dagilimi',
      child: items.isEmpty
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
            ),
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF334155),
                ),
              ),
            ),
            Text(
              '$value',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
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
    return _PanelCard(
      title: 'Odeme Dagilimi',
      child: entries.isEmpty
          ? const Text('Veri bulunamadi')
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 124,
                        child: _AnimatedDonutChart(entries: entries),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: entries
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
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF334155)),
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
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
                color: const Color(0xFF0F172A),
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
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
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

    return _PanelCard(
      title: 'Lokasyon Doluluk',
      child: top.isEmpty
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
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            '$used/$total',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
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
            ),
    );
  }

  int _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '0').toString()) ?? 0;
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.title, required this.child});

  final String title;
  final Widget child;

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
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
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
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton.tonalIcon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
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
