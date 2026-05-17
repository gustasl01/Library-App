import '../../features/books/data/models/author_model.dart';
import '../../features/books/data/models/book_model.dart';
import 'mock_excerpts.dart';

class _BookEntry {
  final BookModel book;
  final List<String> tags;
  final bool featured;
  const _BookEntry({required this.book, required this.tags, this.featured = false});
}

class MockDatabase {
  MockDatabase._();
  static final MockDatabase instance = MockDatabase._();

  final Set<String> _favoriteIds = {};

  static const List<_BookEntry> _entries = [
    _BookEntry(
      book: BookModel(
        id: 'b1',
        title: 'Harry Potter e a Pedra Filosofal',
        author: 'J.K. Rowling',
        coverColor: '#7B1FA2',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780439708180-L.jpg',
        rating: 4.9,
        totalChapters: 17,
        description: 'Um jovem órfão descobre que é um bruxo e é admitido em Hogwarts, uma escola de magia. Lá, ele faz amizades, enfrenta desafios e confronta um passado misterioso ligado ao vilão mais temido do mundo mágico.',
      ),
      tags: ['Fantasy', 'Adventure'],
      featured: true,
    ),
    _BookEntry(
      book: BookModel(
        id: 'b2',
        title: '1984',
        author: 'George Orwell',
        coverColor: '#212121',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg',
        rating: 4.7,
        totalChapters: 23,
        description: 'Em uma sociedade totalitária do futuro, Winston Smith tenta resistir ao controle absoluto do Grande Irmão e encontra um amor proibido. Uma visão assustadoramente profética do mundo moderno.',
      ),
      tags: ['Science Fiction', 'Thriller'],
      featured: true,
    ),
    _BookEntry(
      book: BookModel(
        id: 'b3',
        title: 'Duna',
        author: 'Frank Herbert',
        coverColor: '#E65100',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780441013593-L.jpg',
        rating: 4.6,
        totalChapters: 48,
        description: 'No planeta desértico Arrakis, Paul Atreides lidera uma rebelião ao lado dos nativos Fremen em uma luta pelo controle da especiaria mais valiosa do universo. Uma saga épica de política, religião e ecologia.',
      ),
      tags: ['Science Fiction', 'Adventure'],
      featured: true,
    ),
    _BookEntry(
      book: BookModel(
        id: 'b4',
        title: 'O Nome do Vento',
        author: 'Patrick Rothfuss',
        coverColor: '#1B5E20',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780756404741-L.jpg',
        rating: 4.8,
        totalChapters: 90,
        description: 'Kvothe, o lendário bruxo e músico, conta sua própria história: de órfão miserável a estudante prodígio da Universidade, em um mundo de magia, música e mistério.',
      ),
      tags: ['Fantasy'],
      featured: true,
    ),
    _BookEntry(
      book: BookModel(
        id: 'b5',
        title: 'Jogos Vorazes',
        author: 'Suzanne Collins',
        coverColor: '#B71C1C',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780439023481-L.jpg',
        rating: 4.3,
        totalChapters: 27,
        description: 'Em um futuro distópico, Katniss Everdeen se voluntaria para participar dos Jogos Vorazes no lugar de sua irmã, enfrentando uma luta mortal televisionada para todo o país.',
      ),
      tags: ['Action', 'Science Fiction'],
      featured: true,
    ),
    _BookEntry(
      book: BookModel(
        id: 'b6',
        title: 'Divergente',
        author: 'Veronica Roth',
        coverColor: '#0D47A1',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780062024022-L.jpg',
        rating: 4.1,
        totalChapters: 39,
        description: 'Em uma Chicago futurista dividida em facções baseadas em virtudes, Tris Prior descobre ser Divergente — o que pode custar sua vida e mudar o destino de toda a sociedade.',
      ),
      tags: ['Action', 'Science Fiction'],
      featured: true,
    ),
    _BookEntry(
      book: BookModel(
        id: 'b7',
        title: 'Dom Quixote',
        author: 'Miguel de Cervantes',
        coverColor: '#8D6E63',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780060934347-L.jpg',
        rating: 4.5,
        totalChapters: 52,
        currentChapter: 18,
        progress: 0.35,
        description: 'A obra-prima da literatura espanhola narra as aventuras do idealista Alonso Quijano que, enlouquecido pelos romances de cavalaria, sai pelo mundo como Dom Quixote de La Mancha.',
      ),
      tags: ['Adventure', 'Romance'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b8',
        title: 'O Hobbit',
        author: 'J.R.R. Tolkien',
        coverColor: '#33691E',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780547928227-L.jpg',
        rating: 4.7,
        totalChapters: 19,
        description: 'Bilbo Bolseiro, um hobbit caseiro, é arrastado para uma aventura épica por um feiticeiro e treze anões em busca de um tesouro guardado pelo dragão Smaug.',
      ),
      tags: ['Fantasy', 'Adventure'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b9',
        title: 'O Senhor dos Anéis',
        author: 'J.R.R. Tolkien',
        coverColor: '#4E342E',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780618640157-L.jpg',
        rating: 4.9,
        totalChapters: 62,
        description: 'A grande jornada de Frodo Bolseiro para destruir o Anel do Poder nas chamas da Montanha da Perdição, acompanhado por uma comunidade de heróis da Terra-Média.',
      ),
      tags: ['Fantasy', 'Adventure'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b10',
        title: 'Crime e Castigo',
        author: 'Fiódor Dostoiévski',
        coverColor: '#880E4F',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780486415871-L.jpg',
        rating: 4.6,
        totalChapters: 36,
        description: 'Raskólnikov, um estudante pobre, comete um assassinato e é consumido pela culpa. Uma profunda exploração psicológica sobre moralidade, sofrimento e redenção.',
      ),
      tags: ['Mystery', 'Thriller'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b11',
        title: 'O Grande Gatsby',
        author: 'F. Scott Fitzgerald',
        coverColor: '#F57F17',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780743273565-L.jpg',
        rating: 4.2,
        totalChapters: 9,
        description: 'Na efervescente década de 1920, o misterioso milionário Jay Gatsby tenta reconquistar o amor perdido de Daisy Buchanan através de festas extravagantes e uma vida de ilusão.',
      ),
      tags: ['Romance'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b12',
        title: 'Orgulho e Preconceito',
        author: 'Jane Austen',
        coverColor: '#AD1457',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780141439518-L.jpg',
        rating: 4.8,
        totalChapters: 61,
        currentChapter: 37,
        progress: 0.6,
        description: 'A espirituosa Elizabeth Bennet navega pelas complexidades do amor e classe social na Inglaterra regencial, em um duelo de orgulho e preconceito com o austero Sr. Darcy.',
      ),
      tags: ['Romance'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b13',
        title: 'It — A Coisa',
        author: 'Stephen King',
        coverColor: '#C62828',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9781501156700-L.jpg',
        rating: 4.4,
        totalChapters: 23,
        description: 'Em Derry, um grupo de crianças enfrenta um mal ancestral e shapeshifter que assume a forma dos maiores medos de cada um, frequentemente o terrível Pennywise.',
      ),
      tags: ['Horror'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b14',
        title: 'A Sombra do Vento',
        author: 'Carlos Ruiz Zafón',
        coverColor: '#37474F',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780143034902-L.jpg',
        rating: 4.7,
        totalChapters: 25,
        description: 'Na Barcelona pós-guerra, um menino encontra um livro misterioso no Cemitério dos Livros Esquecidos e descobre que alguém está destruindo todas as cópias existentes.',
      ),
      tags: ['Mystery', 'Thriller', 'Romance'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b15',
        title: 'Cem Anos de Solidão',
        author: 'Gabriel García Márquez',
        coverColor: '#558B2F',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780060883287-L.jpg',
        rating: 4.7,
        totalChapters: 20,
        description: 'A saga da família Buendía ao longo de sete gerações na cidade imaginária de Macondo, contada com o realismo mágico que definiu a literatura latino-americana.',
      ),
      tags: ['Romance', 'Adventure'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b16',
        title: 'O Alquimista',
        author: 'Paulo Coelho',
        coverColor: '#F9A825',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780062315007-L.jpg',
        rating: 4.3,
        totalChapters: 2,
        description: 'O pastor Santiago parte em uma jornada pelo deserto em busca de um tesouro, mas descobre que a verdadeira riqueza está no caminho percorrido e nos sonhos perseguidos.',
      ),
      tags: ['Adventure'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b17',
        title: 'As Aventuras de Sherlock Holmes',
        author: 'Arthur Conan Doyle',
        coverColor: '#4527A0',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780140439076-L.jpg',
        rating: 4.5,
        totalChapters: 12,
        description: 'Uma coletânea dos casos mais intrigantes do famoso detetive Sherlock Holmes e seu fiel companheiro Dr. Watson, solucionando mistérios impossíveis com lógica afiada.',
      ),
      tags: ['Mystery'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b18',
        title: 'A Menina que Roubava Livros',
        author: 'Markus Zusak',
        coverColor: '#5C6BC0',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780375842207-L.jpg',
        rating: 4.8,
        totalChapters: 88,
        description: 'Narrado pela própria Morte, conta a história de Liesel Meminger que encontra consolo nos livros durante a Segunda Guerra Mundial na Alemanha nazista.',
      ),
      tags: ['Romance'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b19',
        title: 'O Caçador de Pipas',
        author: 'Khaled Hosseini',
        coverColor: '#1565C0',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9781594631931-L.jpg',
        rating: 4.7,
        totalChapters: 25,
        description: 'A história de amizade entre dois meninos no Afeganistão e as consequências de uma traição que persegue um homem por décadas, em sua jornada de redenção.',
      ),
      tags: ['Romance'],
    ),
    _BookEntry(
      book: BookModel(
        id: 'b20',
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        coverColor: '#006064',
        coverImage: 'https://covers.openlibrary.org/b/isbn/9780062316097-L.jpg',
        rating: 4.4,
        totalChapters: 20,
        description: 'Uma breve história da humanidade, desde os primeiros Homo sapiens até a era moderna, explorando como nossa espécie dominou o planeta através de mitos compartilhados.',
      ),
      tags: ['Science Fiction'],
    ),
  ];

  static const List<AuthorModel> _authors = [
    AuthorModel(
      id: 'a1',
      name: 'J.K. Rowling',
      bio: 'Autora britânica criadora da série Harry Potter, uma das mais vendidas de todos os tempos.',
      totalBooks: 7,
    ),
    AuthorModel(
      id: 'a2',
      name: 'J.R.R. Tolkien',
      bio: 'Escritor e filólogo inglês, criador da Terra-Média e pai da fantasia épica moderna.',
      totalBooks: 5,
    ),
    AuthorModel(
      id: 'a3',
      name: 'Stephen King',
      bio: 'Mestre do horror americano, autor de mais de 60 romances que definiram o gênero.',
      totalBooks: 63,
    ),
    AuthorModel(
      id: 'a4',
      name: 'Suzanne Collins',
      bio: 'Autora americana conhecida pela trilogia Jogos Vorazes, fenômeno da ficção distópica.',
      totalBooks: 4,
    ),
    AuthorModel(
      id: 'a5',
      name: 'George Orwell',
      bio: 'Escritor e jornalista inglês, famoso por suas obras distópicas sobre totalitarismo.',
      totalBooks: 6,
    ),
  ];

  List<BookModel> get allBooks => _entries.map((e) => e.book).toList();

  List<BookModel> get featuredBooks =>
      _entries.where((e) => e.featured).map((e) => e.book).toList();

  List<BookModel> get continueReading => _entries
      .where((e) => e.book.progress != null && e.book.progress! < 1.0)
      .map((e) => e.book)
      .toList();

  List<BookModel> recommendations({int limit = 6}) {
    final sorted = List<_BookEntry>.from(_entries)
      ..sort((a, b) => (b.book.rating ?? 0).compareTo(a.book.rating ?? 0));
    return sorted.take(limit).map((e) => e.book).toList();
  }

  List<BookModel> search(String query) {
    final lower = query.toLowerCase();
    return _entries
        .where((e) =>
            e.book.title.toLowerCase().contains(lower) ||
            e.book.author.toLowerCase().contains(lower))
        .map((e) => e.book)
        .toList();
  }

  List<BookModel> byTag(String tag) {
    final lower = tag.toLowerCase();
    return _entries
        .where((e) => e.tags.any((t) => t.toLowerCase() == lower))
        .map((e) => e.book)
        .toList();
  }

  BookModel? byId(String id) {
    for (final e in _entries) {
      if (e.book.id == id) return e.book;
    }
    return null;
  }

  String? excerpt(String bookId) => mockExcerpts[bookId];

  List<AuthorModel> get topAuthors => List.from(_authors);

  List<AuthorModel> searchAuthors(String query) {
    final lower = query.toLowerCase();
    return _authors.where((a) => a.name.toLowerCase().contains(lower)).toList();
  }

  bool isFavorite(String bookId) => _favoriteIds.contains(bookId);
  void addFavorite(String bookId) => _favoriteIds.add(bookId);
  void removeFavorite(String bookId) => _favoriteIds.remove(bookId);
  List<BookModel> get favorites =>
      _entries.where((e) => _favoriteIds.contains(e.book.id)).map((e) => e.book).toList();
}
