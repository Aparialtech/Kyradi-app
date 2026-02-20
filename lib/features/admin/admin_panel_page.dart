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
                        _buildTabContent(context),
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

  List<Widget> _buildTabContent(BuildContext context) {
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
        final recent = _asMapList(_overview['recentActivity']);
        return [
          _HeaderAction(title: 'Son Hareketler'),
          const SizedBox(height: 8),
          ...recent.map(
            (item) => _GlassTile(
              title: item['userName']?.toString() ?? '-',
              subtitle:
                  '${item['dropLocationName'] ?? '-'} • ${item['status'] ?? '-'} • ${item['paymentStatus'] ?? '-'}',
              badge: '₺${item['totalPrice'] ?? 0}',
            ),
          ),
        ];
    }
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
    final luggage = Map<String, dynamic>.from(
      overview['luggage'] as Map? ?? const {},
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
                'Kyradi Admin',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Canli sistem ozetini buradan yonet.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF334155)),
              ),
              const SizedBox(height: 14),
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
                  _StatChip(label: 'Bavul', value: '${luggage['total'] ?? 0}'),
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
