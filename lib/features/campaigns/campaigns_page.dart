import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_mesh_background.dart';
import '../../widgets/section_card.dart';

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final campaigns = _campaigns();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.campaignsTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: campaigns.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = campaigns[index];
              return SectionCard(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CampaignDetailPage(campaign: item),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      _CampaignVisual(
                        icon: item.icon,
                        gradient: item.gradient,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({
    super.key,
    required this.campaign,
  });

  final CampaignDetail campaign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Kampanya Detayı')),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              SectionCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CampaignHero(
                      title: campaign.title,
                      subtitle: campaign.subtitle,
                      icon: campaign.icon,
                      gradient: campaign.gradient,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kampanya Detayları',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      campaign.details,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CampaignDetail {
  const CampaignDetail({
    required this.title,
    required this.subtitle,
    required this.details,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String details;
  final IconData icon;
  final List<Color> gradient;
}

List<CampaignDetail> _campaigns() => [
      CampaignDetail(
        title: 'Kahve Dünyası Kahve Hediyesi',
        subtitle: 'İlk rezervasyonuna özel 1 kahve ücretsiz.',
        details:
            'İlk rezervasyonunu tamamladığında, Kahve Dünyası’ndan 1 adet kahve ücretsiz kazanırsın. Kampanya, yalnızca ilk rezervasyon için geçerlidir. Kullanım için rezervasyon sonrası verilen kampanya kodunu kasada göster.',
        icon: Icons.local_cafe_outlined,
        gradient: [
          const Color(0xFF7A4E2D),
          const Color(0xFFD4A373),
        ],
      ),
      CampaignDetail(
        title: '3 Gün ve Üzeri %50 İndirim',
        subtitle: '3 gün ve daha uzun rezervasyonlarda %50 indirim.',
        details:
            '3 gün ve üzeri bavul bırakma rezervasyonlarında toplam ücret üzerinden %50 indirim uygulanır. İndirim, ödeme adımında otomatik olarak yansır ve rezervasyon süresi değiştiğinde tekrar hesaplanır.',
        icon: Icons.local_offer_outlined,
        gradient: [
          const Color(0xFF1D4ED8),
          const Color(0xFF60A5FA),
        ],
      ),
      CampaignDetail(
        title: 'Boyner %10 İndirim',
        subtitle: 'Boyner mağazalarında %10 indirim fırsatı.',
        details:
            'Kyradi kullanıcılarına Boyner mağazalarında %10 indirim sunulur. Kampanya kodu rezervasyon sonrası profilindeki kampanya bölümünde görünür. Kasada kodu göstererek indirimden yararlanabilirsin.',
        icon: Icons.shopping_bag_outlined,
        gradient: [
          const Color(0xFF6D28D9),
          const Color(0xFFBFA3FF),
        ],
      ),
      CampaignDetail(
        title: 'Kyradi Vadi İstanbul & Axis AVM',
        subtitle: 'Yeni lokasyonlarımızda hizmetinizdeyiz.',
        details:
            'Kyradi artık Vadi İstanbul ve Axis AVM’de! Bu lokasyonlarda hızlı teslim ve güvenli saklama hizmeti seni bekliyor. Harita ekranından yol tarifi alabilir, uygunluk durumunu anlık görebilirsin.',
        icon: Icons.location_on_outlined,
        gradient: [
          const Color(0xFF0F766E),
          const Color(0xFF5EEAD4),
        ],
      ),
      CampaignDetail(
        title: 'Öğrencilere Özel %30 İndirim',
        subtitle: 'Edu mail ile kayıt olana %30 indirim.',
        details:
            'Üniversite öğrencileri için özel indirim! Edu uzantılı e-posta ile kayıt olursan %30 indirim seni bekliyor. İndirim, doğrulama sonrası otomatik olarak hesabına tanımlanır.',
        icon: Icons.school_outlined,
        gradient: [
          const Color(0xFFB45309),
          const Color(0xFFFBBF24),
        ],
      ),
    ];

class _CampaignVisual extends StatelessWidget {
  const _CampaignVisual({
    required this.icon,
    required this.gradient,
  });

  final IconData icon;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: gradient),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}

class _CampaignHero extends StatelessWidget {
  const _CampaignHero({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: gradient),
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
