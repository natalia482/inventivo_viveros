import 'package:flutter/material.dart';

// Definición de Colores y Estilos (Se mantienen)
class FormColors {
  static const Color backgroundGray = Color(0xFFF0F0F0); 
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color outlineGreen = Color(0xFF4CAF50);
  static const Color darkText = Color(0xFF333333); 
  static const Color placeholderText = Color(0xFFAAAAAA);
  static const Color buttonGreen = Color(0xFF1A5327); 
}

const double _cardBorderRadius = 15.0;

// ******************************************************
// WIDGET PRINCIPAL: AddPlantScreen (Mejorado para Responsividad)
// ******************************************************

class AddPlantScreen extends StatelessWidget {
  const AddPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;
    
    // Padding adaptativo
    final double horizontalPadding = isDesktop ? 40.0 : 15.0;
    final double titleFontSize = isDesktop ? 36.0 : 26.0;

    return Container(
      color: FormColors.backgroundGray, 
      padding: EdgeInsets.all(horizontalPadding), 
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agregar Planta',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w400, 
                color: FormColors.darkText,
                fontFamily: 'Roboto', 
              ),
            ),
            SizedBox(height: isDesktop ? 30 : 20),

            // 1. Buscador Superior
            _buildSearchField(isDesktop),
            SizedBox(height: isDesktop ? 30 : 20),

            // 2. Formulario Principal (Usa Wrap para auto-apilamiento)
            Wrap(
              spacing: isDesktop ? 30.0 : 15.0, 
              runSpacing: isDesktop ? 30.0 : 15.0, 
              children: [
                // Fila 1 y 2
                FormCard(
                  label: 'Nombre del producto', value: 'Rosas', icon: Icons.grass, 
                  isDesktop: isDesktop, screenWidth: screenWidth,
                ),
                FormCard(
                  label: 'Número de bolsa', value: '35', icon: Icons.numbers, 
                  isDesktop: isDesktop, screenWidth: screenWidth,
                ),
                FormCard(
                  label: 'Categoría', value: 'Ornamentales', icon: Icons.autorenew, 
                  trailing: const Icon(Icons.keyboard_arrow_down, color: FormColors.outlineGreen),
                  isDesktop: isDesktop, screenWidth: screenWidth,
                ),
                FormCard(
                  label: 'Precio Unitario', value: '\$6.000', icon: Icons.attach_money,
                  isDesktop: isDesktop, screenWidth: screenWidth,
                ),

                // Fila 3 - Totales
                FormCard(
                  label: 'Total de plantas', value: '148', icon: Icons.grass,
                  isDesktop: isDesktop, screenWidth: screenWidth,
                ),
                FormCard(
                  label: 'Total de plantas', value: '148', icon: Icons.grass,
                  isDesktop: isDesktop, screenWidth: screenWidth,
                ),
              ],
            ),
            
            SizedBox(height: isDesktop ? 40 : 25),

            // 3. Botón de Acción Principal (alineado a la derecha en desktop)
            Align(
              alignment: Alignment.centerRight,
              child: _buildActionButton(isDesktop),
            ),
            SizedBox(height: isDesktop ? 20 : 10),
          ],
        ),
      ),
    );
  }

  // Widget para el campo de búsqueda (Ajustado)
  Widget _buildSearchField(bool isDesktop) {
    return Container(
      // En móvil, usa el ancho completo. En desktop, limita el ancho.
      width: isDesktop ? 550 : double.infinity,
      decoration: BoxDecoration(
        color: FormColors.cardBackground,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        border: Border.all(color: FormColors.outlineGreen.withOpacity(0.5), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: FormColors.placeholderText),
          hintText: 'Buscar productos',
          hintStyle: TextStyle(color: FormColors.placeholderText),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
  
  // Widget para el botón principal (Ajustado)
  Widget _buildActionButton(bool isDesktop) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: FormColors.buttonGreen,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 30 : 20, vertical: isDesktop ? 15 : 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
        ),
        elevation: 5,
      ),
      child: Text(
        'Agregar productos',
        style: TextStyle(fontSize: isDesktop ? 18 : 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ******************************************************
// WIDGET AUXILIAR: Tarjeta de Entrada/Campo (FormCard Responsivo)
// ******************************************************

class FormCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Widget? trailing;
  final bool isDesktop; // Nuevo: Estado desktop
  final double screenWidth; // Nuevo: Ancho de pantalla

  const FormCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.trailing,
    required this.isDesktop,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Calculo del ancho:
    // En desktop (isDesktop=true): Ocupa menos de la mitad del espacio disponible (100% - Sidebar - Padding - Espaciado)
    // En móvil (isDesktop=false): Ocupa el ancho máximo disponible para el Wrap (casi el 100%).
    double calculatedWidth = isDesktop 
      ? (screenWidth - 320 - 90) / 2 // 320: ancho Sidebar, 90: padding y spacing total
      : screenWidth - 2 * 15; // Ancho completo - padding del Wrap

    if (calculatedWidth < 200) calculatedWidth = screenWidth - 2 * 15; // Mínimo de 200px para que se vea bien

    return Container(
      width: calculatedWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: FormColors.cardBackground,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Etiqueta del campo con su ícono
              Row(
                children: [
                  Icon(icon, color: FormColors.outlineGreen, size: isDesktop ? 24 : 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: FormColors.darkText,
                      fontSize: isDesktop ? 16 : 14, // Ajuste de fuente
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Widget opcional (ej. flecha de Categoría)
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 5),
          // Valor o input
          Text(
            value,
            style: TextStyle(
              color: FormColors.placeholderText,
              fontSize: isDesktop ? 20 : 18, // Ajuste de fuente
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}