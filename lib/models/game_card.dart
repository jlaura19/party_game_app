/// Model for a game card (used in Never Have I Ever, Most Likely To, etc.)
class GameCard {
  final String text;
  final bool isAIGenerated;
  final DateTime timestamp;

  GameCard({
    required this.text,
    this.isAIGenerated = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  GameCard copyWith({
    String? text,
    bool? isAIGenerated,
    DateTime? timestamp,
  }) {
    return GameCard(
      text: text ?? this.text,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameCard && other.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}
