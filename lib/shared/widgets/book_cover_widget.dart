import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookCoverWidget extends StatelessWidget {
  final String? coverImage;
  final String coverColor;
  final String title;
  final String author;
  final double width;
  final double height;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const BookCoverWidget({
    super.key,
    this.coverImage,
    required this.coverColor,
    required this.title,
    required this.author,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final base = _parseColor(coverColor);
    final hsl = HSLColor.fromColor(base);
    final dark = hsl.withLightness((hsl.lightness * 0.55).clamp(0.0, 1.0)).toColor();
    final light = hsl.withLightness((hsl.lightness * 1.35).clamp(0.0, 1.0)).toColor();

    final pad = (width * 0.10).clamp(8.0, 20.0);
    final titleSize = (width * 0.115).clamp(9.0, 17.0);
    final authorSize = (width * 0.075).clamp(7.0, 11.0);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, base, dark],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _CoverPainter(dark: dark),
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, pad, pad * 0.8, pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 2.5,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                  shadows: [
                    Shadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 6),
                  ],
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: pad * 0.4),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.35)),
              SizedBox(height: pad * 0.4),
              Text(
                author,
                style: GoogleFonts.inter(
                  fontSize: authorSize,
                  color: Colors.white.withValues(alpha: 0.82),
                  letterSpacing: 0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String raw) {
    final v = raw.trim();
    if (v.startsWith('#')) return Color(int.parse('0xFF${v.substring(1)}'));
    if (v.startsWith('0x') || v.startsWith('0X')) return Color(int.parse(v));
    return const Color(0xFF2C3E50);
  }
}

class _CoverPainter extends CustomPainter {
  final Color dark;
  _CoverPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size s) {
    // Spine shadow on left
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width * 0.055, s.height),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );

    // Top-right decorative triangle
    final tri = Path()
      ..moveTo(s.width, 0)
      ..lineTo(s.width, s.height * 0.28)
      ..lineTo(s.width * 0.55, 0)
      ..close();
    canvas.drawPath(tri, Paint()..color = Colors.white.withValues(alpha: 0.07));

    // Bottom fade
    canvas.drawRect(
      Rect.fromLTWH(0, s.height * 0.52, s.width, s.height * 0.48),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.38)],
        ).createShader(Rect.fromLTWH(0, s.height * 0.52, s.width, s.height * 0.48)),
    );
  }

  @override
  bool shouldRepaint(_CoverPainter old) => old.dark != dark;
}
