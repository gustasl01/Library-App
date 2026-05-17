import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/mock/mock_database.dart';
import '../../domain/entities/book_entity.dart';

enum _ReaderTheme { light, sepia, dark }

class BookReaderPage extends StatefulWidget {
  final BookEntity book;
  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _controlsAnim;

  _ReaderTheme _theme = _ReaderTheme.sepia;
  double _fontSize = 17.0;
  bool _useSerif = true;
  bool _controlsVisible = true;
  Timer? _hideTimer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controlsAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _scrollController.addListener(_onScroll);
    _scheduleHide();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controlsAnim.dispose();
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    if (max > 0) {
      setState(() => _progress = (_scrollController.offset / max).clamp(0.0, 1.0));
    }
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) {
      _controlsAnim.forward();
      _scheduleHide();
    } else {
      _controlsAnim.reverse();
      _hideTimer?.cancel();
    }
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _controlsVisible) {
        setState(() => _controlsVisible = false);
        _controlsAnim.reverse();
      }
    });
  }

  Color get _bg => switch (_theme) {
        _ReaderTheme.light => const Color(0xFFFFFFFF),
        _ReaderTheme.sepia => const Color(0xFFF5EDD6),
        _ReaderTheme.dark => const Color(0xFF131318),
      };

  Color get _fg => switch (_theme) {
        _ReaderTheme.light => const Color(0xFF1A1A2E),
        _ReaderTheme.sepia => const Color(0xFF3B2512),
        _ReaderTheme.dark => const Color(0xFFDDD5C8),
      };

  Color get _overlay => switch (_theme) {
        _ReaderTheme.light => const Color(0xEE1A1A2E),
        _ReaderTheme.sepia => const Color(0xEE2D1A08),
        _ReaderTheme.dark => const Color(0xEE000000),
      };

  TextStyle get _chapterLabel => (_useSerif
          ? GoogleFonts.playfairDisplay()
          : GoogleFonts.inter())
      .copyWith(fontSize: 11, color: _fg.withValues(alpha: 0.45), letterSpacing: 2.5);

  TextStyle get _titleStyle =>
      (_useSerif ? GoogleFonts.playfairDisplay() : GoogleFonts.inter()).copyWith(
        fontSize: _fontSize + 7,
        fontWeight: FontWeight.bold,
        color: _fg,
        height: 1.3,
      );

  TextStyle get _bodyStyle =>
      (_useSerif ? GoogleFonts.lora() : GoogleFonts.inter()).copyWith(
        fontSize: _fontSize,
        color: _fg,
        height: 1.8,
        letterSpacing: 0.15,
      );

  @override
  Widget build(BuildContext context) {
    final excerpt = MockDatabase.instance.excerpt(widget.book.id) ?? '';
    final paragraphs = excerpt.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    final chapter = widget.book.currentChapter ?? 1;

    return Scaffold(
      backgroundColor: _bg,
      body: GestureDetector(
        onTap: _toggleControls,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            _ReadingContent(
              scrollController: _scrollController,
              chapter: chapter,
              book: widget.book,
              paragraphs: paragraphs,
              chapterLabelStyle: _chapterLabel,
              titleStyle: _titleStyle,
              bodyStyle: _bodyStyle,
              fg: _fg,
            ),
            _TopOverlay(
              animation: _controlsAnim,
              book: widget.book,
              overlayColor: _overlay,
              onClose: () => Navigator.pop(context),
              onSettings: _openSettings,
            ),
            _BottomOverlay(
              animation: _controlsAnim,
              progress: _progress,
              overlayColor: _overlay,
            ),
          ],
        ),
      ),
    );
  }

  void _openSettings() {
    _hideTimer?.cancel();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SettingsSheet(
        theme: _theme,
        fontSize: _fontSize,
        useSerif: _useSerif,
        isDarkBase: _theme == _ReaderTheme.dark,
        onThemeChanged: (t) => setState(() => _theme = t),
        onFontSizeChanged: (s) => setState(() => _fontSize = s),
        onFontChanged: (serif) => setState(() => _useSerif = serif),
      ),
    ).whenComplete(_scheduleHide);
  }
}

class _ReadingContent extends StatelessWidget {
  final ScrollController scrollController;
  final int chapter;
  final BookEntity book;
  final List<String> paragraphs;
  final TextStyle chapterLabelStyle;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final Color fg;

  const _ReadingContent({
    required this.scrollController,
    required this.chapter,
    required this.book,
    required this.paragraphs,
    required this.chapterLabelStyle,
    required this.titleStyle,
    required this.bodyStyle,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(24, top + 72, 24, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('CAPÍTULO $chapter', style: chapterLabelStyle),
          const SizedBox(height: 12),
          Text(book.title, style: titleStyle),
          const SizedBox(height: 8),
          Text(
            'por ${book.author}',
            style: chapterLabelStyle.copyWith(letterSpacing: 1),
          ),
          const SizedBox(height: 40),
          ...paragraphs.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(p.trim(), style: bodyStyle, textAlign: TextAlign.justify),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '— Fim do trecho de demonstração —',
              style: chapterLabelStyle.copyWith(letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _TopOverlay extends StatelessWidget {
  final AnimationController animation;
  final BookEntity book;
  final Color overlayColor;
  final VoidCallback onClose;
  final VoidCallback onSettings;

  const _TopOverlay({
    required this.animation,
    required this.book,
    required this.overlayColor,
    required this.onClose,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        child: Container(
          color: overlayColor,
          padding: EdgeInsets.fromLTRB(4, top + 4, 4, 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: onClose,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      book.author,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Colors.white),
                onPressed: onSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomOverlay extends StatelessWidget {
  final AnimationController animation;
  final double progress;
  final Color overlayColor;

  const _BottomOverlay({
    required this.animation,
    required this.progress,
    required this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        child: Container(
          color: overlayColor,
          padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                  ),
                  Text(
                    'Trecho de demonstração',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE07B54)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatefulWidget {
  final _ReaderTheme theme;
  final double fontSize;
  final bool useSerif;
  final bool isDarkBase;
  final ValueChanged<_ReaderTheme> onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<bool> onFontChanged;

  const _SettingsSheet({
    required this.theme,
    required this.fontSize,
    required this.useSerif,
    required this.isDarkBase,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.onFontChanged,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late _ReaderTheme _theme;
  late double _fontSize;
  late bool _useSerif;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
    _fontSize = widget.fontSize;
    _useSerif = widget.useSerif;
  }

  Color get _sheetBg => _theme == _ReaderTheme.dark ? const Color(0xFF1E1E2A) : Colors.white;
  Color get _textColor => _theme == _ReaderTheme.dark ? Colors.white : const Color(0xFF1A1A2E);
  Color get _subColor =>
      _theme == _ReaderTheme.dark ? Colors.white54 : const Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: _sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _subColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'Tamanho da fonte', color: _subColor),
          const SizedBox(height: 12),
          Row(
            children: [
              _CircleBtn(
                icon: Icons.remove,
                onTap: () {
                  final v = (_fontSize - 1).clamp(12.0, 24.0);
                  setState(() => _fontSize = v);
                  widget.onFontSizeChanged(v);
                },
                bg: _sheetBg,
                color: _textColor,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFE07B54),
                    thumbColor: const Color(0xFFE07B54),
                    inactiveTrackColor: _subColor.withValues(alpha: 0.2),
                    overlayColor: const Color(0x22E07B54),
                  ),
                  child: Slider(
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    divisions: 12,
                    onChanged: (v) {
                      setState(() => _fontSize = v);
                      widget.onFontSizeChanged(v);
                    },
                  ),
                ),
              ),
              _CircleBtn(
                icon: Icons.add,
                onTap: () {
                  final v = (_fontSize + 1).clamp(12.0, 24.0);
                  setState(() => _fontSize = v);
                  widget.onFontSizeChanged(v);
                },
                bg: _sheetBg,
                color: _textColor,
              ),
              const SizedBox(width: 8),
              Text('${_fontSize.toInt()}pt', style: TextStyle(color: _textColor, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: 'Fonte', color: _subColor),
          const SizedBox(height: 12),
          Row(
            children: [
              _FontToggle(
                label: 'Serif',
                selected: _useSerif,
                fontStyle: GoogleFonts.lora().copyWith(fontSize: 14),
                onTap: () {
                  setState(() => _useSerif = true);
                  widget.onFontChanged(true);
                },
                textColor: _textColor,
                bg: _sheetBg,
              ),
              const SizedBox(width: 12),
              _FontToggle(
                label: 'Sans',
                selected: !_useSerif,
                fontStyle: GoogleFonts.inter().copyWith(fontSize: 14),
                onTap: () {
                  setState(() => _useSerif = false);
                  widget.onFontChanged(false);
                },
                textColor: _textColor,
                bg: _sheetBg,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(label: 'Tema', color: _subColor),
          const SizedBox(height: 12),
          Row(
            children: [
              _ThemeOption(
                label: 'Claro',
                bg: Colors.white,
                fg: const Color(0xFF1A1A2E),
                selected: _theme == _ReaderTheme.light,
                onTap: () {
                  setState(() => _theme = _ReaderTheme.light);
                  widget.onThemeChanged(_ReaderTheme.light);
                },
              ),
              const SizedBox(width: 10),
              _ThemeOption(
                label: 'Sépia',
                bg: const Color(0xFFF5EDD6),
                fg: const Color(0xFF3B2512),
                selected: _theme == _ReaderTheme.sepia,
                onTap: () {
                  setState(() => _theme = _ReaderTheme.sepia);
                  widget.onThemeChanged(_ReaderTheme.sepia);
                },
              ),
              const SizedBox(width: 10),
              _ThemeOption(
                label: 'Escuro',
                bg: const Color(0xFF131318),
                fg: const Color(0xFFDDD5C8),
                selected: _theme == _ReaderTheme.dark,
                onTap: () {
                  setState(() => _theme = _ReaderTheme.dark);
                  widget.onThemeChanged(_ReaderTheme.dark);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label.toUpperCase(),
          style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color color;
  const _CircleBtn({required this.icon, required this.onTap, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _FontToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final TextStyle fontStyle;
  final VoidCallback onTap;
  final Color textColor;
  final Color bg;

  const _FontToggle({
    required this.label,
    required this.selected,
    required this.fontStyle,
    required this.onTap,
    required this.textColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? const Color(0xFFE07B54) : textColor.withValues(alpha: 0.15),
              width: selected ? 2 : 1,
            ),
            color: selected ? const Color(0xFFE07B54).withValues(alpha: 0.08) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(label, style: fontStyle.copyWith(color: textColor, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.bg,
    required this.fg,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? const Color(0xFFE07B54) : Colors.grey.withValues(alpha: 0.25),
              width: selected ? 2.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              )),
        ),
      ),
    );
  }
}
