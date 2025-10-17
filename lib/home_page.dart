import 'package:flutter/material.dart';
//import 'package:inventivo_viveros/login_screen.dart';
import 'package:inventivo_viveros/widgets/background_section_home.dart';
import 'package:inventivo_viveros/widgets/header_section_home.dart';
// Paleta de colores Inventivo
class AppColors {
  static const Color primaryGreen = Color(0xFF1A5327);
  static const Color darkGreen = Color(0xFF0D6832);
  static const Color accentYellow = Color(0xFFF7C948);
  static const Color backgroundOverlay = Color(0x55000000);
}

// Página principal
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          final isMobile = screenWidth < 700;
          final isTablet = screenWidth >= 700 && screenWidth < 1100;
          final isDesktop = screenWidth >= 1100;

          return InventivoBackground(
             child:SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : (isTablet ? 60 : 100),
                      vertical: isMobile ? 20 : 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InventivoHeader(isMobile: isMobile),
                        SizedBox(height: isMobile ? 60 : 100),
                        _MainTextSection(isMobile: isMobile, isTablet: isTablet),
                        SizedBox(height: isMobile ? 40 : 80),
                        _BoxesSection(
                          isMobile: isMobile,
                          isTablet: isTablet,
                          isDesktop: isDesktop,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}

// Texto principal
class _MainTextSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _MainTextSection({
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final fontSizeTitle = isMobile
        ? 32.0
        : (isTablet ? 40.0 : 52.0);

    final fontSizeSubtitle = isMobile
        ? 18.0
        : (isTablet ? 20.0 : 24.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Transforma la gestión de tu vivero',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(2, 2),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'La plataforma inteligente que tu empresa necesita',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSizeSubtitle,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Cajas de características
class _BoxesSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const _BoxesSection({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final boxes = [
      const _FeatureBox(
        title: 'Nuestro sistema',
        features: [
          'Manejo de inventarios',
          'Manejo de insumos',
          'Gestión de personal'
        ],
      ),
      const _FeatureBox(
        title: 'Beneficios clave',
        features: [
          'Optimiza tiempo',
          'Inventarios actualizados',
          'Toma de decisiones'
        ],
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          boxes[0],
          const SizedBox(height: 25),
          boxes[1],
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: boxes[0]),
          const SizedBox(width: 40),
          Expanded(child: boxes[1]),
        ],
      );
    }
  }
}

// Caja individual
class _FeatureBox extends StatelessWidget {
  final String title;
  final List<String> features;

  const _FeatureBox({
    required this.title,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(45, 255, 255, 255).withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map(
                    (text) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}