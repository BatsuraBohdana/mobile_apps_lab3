import SwiftUI

// Модель для збереження коментаря
struct MovieComment: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let time: String
}

struct ContentView: View {
    // 1. Мова додатку (UA / EN)
    @State private var currentLanguage: String = "ua"
    
    // 2. Обраний фільм
    @State private var selectedMovie: String = "movie1"
    
    // 3. Поле вводу нового коментаря
    @State private var newCommentText: String = ""
    
    // 4. Словник коментарів для кожного фільму
    @State private var commentsByMovie: [String: [MovieComment]] = [
        "movie1": [
            MovieComment(text: "Неймовірні спецефекти як для 1968 року!", time: "14:10"),
            MovieComment(text: "Сцена з космічним вальсом — шедевр.", time: "14:25")
        ],
        "movie2": [
            MovieComment(text: "Саундтрек Ганса Ціммера просто до мурашок!", time: "12:00")
        ],
        "movie3": [
            MovieComment(text: "Плакала на сцені з повідомленнями від дітей 😭", time: "13:40")
        ]
    ]
    
    // 5. Відкриття нового вікна (Пункт А)
    @State private var showDetailScreen: Bool = false
    
    // Словник перекладів
    let texts: [String: [String: String]] = [
        "ua": [
            "app_title": "Lumière",
            "picker_label": "Оберіть фільм",
            "movie1_title": "Одіссея",
            "movie1_genre": "Фентезі, пригоди",
            "movie1_year": "2026",
            "movie1_rating": "8.3",
            "movie1_desc": "Фільм Крістофера Нолана за епічною поемою Гомера про царя Ітаки.",
            
            "movie2_title": "Дюна",
            "movie2_genre": "Пригоди, драма",
            "movie2_year": "2021",
            "movie2_rating": "8.5",
            "movie2_desc": "Науково-фантастичний епос Дені Вільнева про піщану планету Арракіс.",
            
            "movie3_title": "Інтерстеллар",
            "movie3_genre": "Наукова фантастика",
            "movie3_year": "2014",
            "movie3_rating": "8.7",
            "movie3_desc": "Подорож крізь червоточину в пошуках нового дому для людства.",
            
            "comments_title": "Відгуки глядачів",
            "input_placeholder": "Напишіть коментар...",
            "btn_new_window": "Усі відгуки (Нове вікно)",
            "btn_share": "Поділитися",
            "detail_header": "Стрічка відгуків до фільму",
            "detail_close": "Закрити",
            "no_comments": "Ще немає відгуків. Будьте першим!"
        ],
        "en": [
            "app_title": "Lumière",
            "picker_label": "Select movie",
            "movie1_title": "Odyssey",
            "movie1_genre": "Fantasy, adventure",
            "movie1_year": "2026",
            "movie1_rating": "8.3",
            "movie1_desc": "Christopher Nolan's adaptation of Homer's epic tale.",
            
            "movie2_title": "Dune",
            "movie2_genre": "Adventure, drama",
            "movie2_year": "2021",
            "movie2_rating": "8.5",
            "movie2_desc": "Denis Villeneuve's sci-fi masterpiece about planet Arrakis.",
            
            "movie3_title": "Interstellar",
            "movie3_genre": "Sci-Fi, drama",
            "movie3_year": "2014",
            "movie3_rating": "8.7",
            "movie3_desc": "Wormhole expedition to secure humanity's survival.",
            
            "comments_title": "Audience Reviews",
            "input_placeholder": "Write a comment...",
            "btn_new_window": "All Reviews (New Window)",
            "btn_share": "Share",
            "detail_header": "Movie Review Feed",
            "detail_close": "Close",
            "no_comments": "No reviews yet. Be the first!"
        ]
    ]

    var shareText: String {
        let title = texts[currentLanguage]?["\(selectedMovie)_title"] ?? ""
        let currentComments = commentsByMovie[selectedMovie] ?? []
        let lastComment = currentComments.last?.text ?? "Рекомендую переглянути!"
        return "🎬 Фільм: \(title)\n💬 Мій відгук: \(lastComment)\nСтворено в Lumière ✨"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // 1. ВЕРХНІЙ БАР (Безпечно під Dynamic Island)
                HStack(alignment: .center) {
                    HStack(spacing: 8) {
                        Image(systemName: "film.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                        Text(texts[currentLanguage]?["app_title"] ?? "")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // ВИПАДАЮЧИЙ СПИСОК МОВ
                    Menu {
                        Button(action: { withAnimation(.easeInOut) { currentLanguage = "ua" } }) {
                            Label("Українська", systemImage: currentLanguage == "ua" ? "checkmark" : "")
                        }
                        Button(action: { withAnimation(.easeInOut) { currentLanguage = "en" } }) {
                            Label("English", systemImage: currentLanguage == "en" ? "checkmark" : "")
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "globe")
                                .font(.system(size: 13, weight: .semibold))
                            Text(currentLanguage == "ua" ? "🇺🇦 UA" : "🇬🇧 EN")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .opacity(0.7)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.3), lineWidth: 0.8)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // 2. ПОСТЕР (КАРУСЕЛЬ)
                VStack(spacing: 12) {
                    Image(selectedMovie)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 190, height: 270)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 12)
                        .id(selectedMovie)
                        .transition(.opacity.combined(with: .scale(scale: 0.94)))

                    // Точки каруселі
                    HStack(spacing: 8) {
                        ForEach(["movie1", "movie2", "movie3"], id: \.self) { item in
                            Capsule()
                                .fill(selectedMovie == item ? Color.yellow : Color.white.opacity(0.35))
                                .frame(width: selectedMovie == item ? 22 : 7, height: 7)
                                .animation(.spring(response: 0.35), value: selectedMovie)
                        }
                    }
                }
                .padding(.vertical, 14)

                // 3. ІНФОРМАЦІЯ ПРО ФІЛЬМ + ВІДГУКИ
                VStack(spacing: 14) {
                    
                    // Назва фільму
                    Text(texts[currentLanguage]?["\(selectedMovie)_title"] ?? "")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Бейджі (Рейтинг, Рік, Жанр)
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 11))
                            Text(texts[currentLanguage]?["\(selectedMovie)_rating"] ?? "")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)

                        Text(texts[currentLanguage]?["\(selectedMovie)_year"] ?? "")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(8)

                        Text(texts[currentLanguage]?["\(selectedMovie)_genre"] ?? "")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(8)
                    }

                    // ВИПАДАЮЧИЙ СПИСОК ФІЛЬМІВ
                    Menu {
                        Button(action: { switchTo("movie1") }) {
                            Label(texts[currentLanguage]?["movie1_title"] ?? "", systemImage: "sparkles")
                        }
                        Button(action: { switchTo("movie2") }) {
                            Label(texts[currentLanguage]?["movie2_title"] ?? "", systemImage: "flame.fill")
                        }
                        Button(action: { switchTo("movie3") }) {
                            Label(texts[currentLanguage]?["movie3_title"] ?? "", systemImage: "globe.americas.fill")
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.yellow)
                            Text(texts[currentLanguage]?["picker_label"] ?? "")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(14)
                    }

                    Divider().background(Color.white.opacity(0.2))

                    // ----------------------------------------------------
                    // БЛОК ВВОДУ ТА ВИДАЛЕННЯ КОМЕНТАРІВ (ЛАБ 3)
                    // ----------------------------------------------------
                    
                    // Поле введення
                    HStack {
                        Image(systemName: "text.bubble.fill")
                            .foregroundColor(.yellow)
                        TextField(
                            texts[currentLanguage]?["input_placeholder"] ?? "",
                            text: $newCommentText
                        )
                        .foregroundColor(.white)
                        .tint(.yellow)
                        
                        Button(action: addComment) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(newCommentText.isEmpty ? .gray : .yellow)
                        }
                        .disabled(newCommentText.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )

                    // Стрічка останніх відгуків на головному екрані
                    VStack(alignment: .leading, spacing: 8) {
                        let list = commentsByMovie[selectedMovie] ?? []
                        if list.isEmpty {
                            Text(texts[currentLanguage]?["no_comments"] ?? "")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.vertical, 4)
                        } else {
                            ForEach(list.suffix(3)) { comment in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "quote.opening")
                                        .font(.caption2)
                                        .foregroundColor(.yellow)
                                    Text(comment.text)
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                    
                                    Text(comment.time)
                                        .font(.system(size: 10))
                                        .foregroundColor(.white.opacity(0.4))
                                    
                                    // КНОПКА ВИДАЛЕННЯ НА ГОЛОВНОМУ ЕКРАНІ 🗑
                                    Button(action: { deleteComment(id: comment.id) }) {
                                        Image(systemName: "trash")
                                            .font(.caption2)
                                            .foregroundColor(.red.opacity(0.75))
                                            .padding(4)
                                    }
                                }
                                .padding(10)
                                .background(Color.black.opacity(0.35))
                                .cornerRadius(10)
                            }
                        }
                    }

                    // КНОПКИ ВІДПРАВКИ (ПУНКТ А та ПУНКТ Б)
                    HStack(spacing: 10) {
                        
                        // ПУНКТ (а): В НОВЕ ВІКНО ДОДАТКУ
                        Button(action: {
                            showDetailScreen = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "rectangle.stack.fill")
                                Text(texts[currentLanguage]?["btn_new_window"] ?? "")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Color.black)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                        }

                        // ПУНКТ (б): В ІНШІ ДОДАТКИ
                        ShareLink(
                            item: shareText,
                            preview: SharePreview("Lumière Cinema", image: Image(selectedMovie))
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "paperplane.fill")
                                Text(texts[currentLanguage]?["btn_share"] ?? "")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Color.yellow)
                            .cornerRadius(14)
                            .shadow(color: Color.yellow.opacity(0.3), radius: 8, x: 0, y: 3)
                        }
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        // НАДІЙНИЙ ФОН
        .background(
            ZStack {
                Color.black

                Image(selectedMovie)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 50)
                    .scaleEffect(1.2)
                    .animation(.easeInOut(duration: 0.5), value: selectedMovie)

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.45),
                        Color.black.opacity(0.25),
                        Color.black.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
        )
        // НОВЕ ВІКНО ДОДАТКУ (ПУНКТ А)
        .sheet(isPresented: $showDetailScreen) {
            ReviewFeedView(
                movieName: texts[currentLanguage]?["\(selectedMovie)_title"] ?? "",
                moviePoster: selectedMovie,
                comments: commentsByMovie[selectedMovie] ?? [],
                headerTitle: texts[currentLanguage]?["detail_header"] ?? "",
                closeTitle: texts[currentLanguage]?["detail_close"] ?? "",
                noCommentsText: texts[currentLanguage]?["no_comments"] ?? "",
                onDelete: { id in
                    deleteComment(id: id)
                }
            )
        }
    }

    // ДОДАВАННЯ КОМЕНТАРЯ
    private func addComment() {
        let trimmed = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: Date())
        
        let newComment = MovieComment(text: trimmed, time: currentTime)
        
        withAnimation(.spring()) {
            if commentsByMovie[selectedMovie] != nil {
                commentsByMovie[selectedMovie]?.append(newComment)
            } else {
                commentsByMovie[selectedMovie] = [newComment]
            }
            newCommentText = ""
        }
    }

    // ВИДАЛЕННЯ КОМЕНТАРЯ ЗА ID
    private func deleteComment(id: UUID) {
        withAnimation(.easeInOut(duration: 0.3)) {
            commentsByMovie[selectedMovie]?.removeAll { $0.id == id }
        }
    }

    private func switchTo(_ movie: String) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            selectedMovie = movie
        }
    }
}

// -----------------------------------------------------------------
// ОКРЕМЕ НОВЕ ВІКНО: Повна стрічка з кнопками видалення 🗑
// -----------------------------------------------------------------
struct ReviewFeedView: View {
    @Environment(\.dismiss) var dismiss
    
    let movieName: String
    let moviePoster: String
    let comments: [MovieComment]
    let headerTitle: String
    let closeTitle: String
    let noCommentsText: String
    let onDelete: (UUID) -> Void // Функція видалення

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                // Верхня панель
                HStack {
                    Text(headerTitle)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.top, 20)

                // Шапка фільму
                HStack(spacing: 14) {
                    Image(moviePoster)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(movieName)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("Всього відгуків: \(comments.count)")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color.white.opacity(0.08))
                .cornerRadius(16)

                // Список усіх відгуків з можливістю видалення
                ScrollView {
                    VStack(spacing: 10) {
                        if comments.isEmpty {
                            Text(noCommentsText)
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.top, 30)
                        } else {
                            ForEach(comments) { item in
                                HStack(alignment: .top, spacing: 10) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Image(systemName: "person.circle.fill")
                                                .foregroundColor(.yellow)
                                            Text("Глядач")
                                                .font(.caption.bold())
                                                .foregroundColor(.white.opacity(0.8))
                                            Spacer()
                                            Text(item.time)
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.4))
                                        }

                                        Text(item.text)
                                            .font(.body)
                                            .foregroundColor(.white)
                                    }

                                    // КНОПКА ВИДАЛЕННЯ У ВІКНІ 🗑
                                    Button(action: { onDelete(item.id) }) {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red.opacity(0.8))
                                            .padding(8)
                                    }
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(14)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Кнопка закриття
                Button(action: { dismiss() }) {
                    Text(closeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.yellow)
                        .cornerRadius(16)
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
}
