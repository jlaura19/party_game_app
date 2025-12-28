import '../models/difficulty_level.dart';

/// Game data constants - all preset content for offline mode
/// Content is organized by difficulty level: Mild, Moderate, and Spicy
class GameData {
  // ============================================================================
  // NEVER HAVE I EVER - Organized by Difficulty
  // ============================================================================
  
  static const Map<String, List<String>> _neverHaveIEverByDifficulty = {
    'mild': [
      // Family-friendly, safe for all audiences
      "Never have I ever pretended to be on the phone to avoid someone.",
      "Never have I ever sung in the shower.",
      "Never have I ever talked to myself in the mirror.",
      "Never have I ever eaten food that fell on the floor.",
      "Never have I ever re-gifted a present.",
      "Never have I ever pretended to like a gift I hated.",
      "Never have I ever forgotten someone's name right after meeting them.",
      "Never have I ever waved at someone who wasn't waving at me.",
      "Never have I ever walked into a room and forgotten why.",
      "Never have I ever laughed at a joke I didn't understand.",
      "Never have I ever googled myself.",
      "Never have I ever practiced a conversation in my head before having it.",
      "Never have I ever pretended to be sick to skip work or school.",
      "Never have I ever cried during a kids' movie.",
      "Never have I ever tripped over nothing in public.",
      "Never have I ever accidentally liked an old social media post while stalking.",
      "Never have I ever eaten an entire pizza by myself.",
      "Never have I ever binge-watched an entire series in one day.",
      "Never have I ever fallen asleep during a movie I said I wanted to watch.",
      "Never have I ever judged someone for their music taste.",
      "Never have I ever pretended to know about something I had no clue about.",
      "Never have I ever laughed so hard I snorted.",
      "Never have I ever had an imaginary friend.",
      "Never have I ever made up a story to sound more interesting.",
    ],
    'moderate': [
      // Standard party content
      "Never have I ever ghosted someone I was actually interested in.",
      "Never have I ever stalked an ex on social media anonymously.",
      "Never have I ever lied about my age.",
      "Never have I ever sent a risky text and immediately regretted it.",
      "Never have I ever hooked up with a friend's ex.",
      "Never have I ever been kicked out of a bar or club.",
      "Never have I ever dined and dashed.",
      "Never have I ever lied to get a job.",
      "Never have I ever snooped through a partner's phone.",
      "Never have I ever used a fake ID.",
      "Never have I ever had a crush on a teacher or professor.",
      "Never have I ever kissed someone just to make someone else jealous.",
      "Never have I ever pretended to be someone else online.",
      "Never have I ever dated two people at the same time without them knowing.",
      "Never have I ever lied about where I was going.",
      "Never have I ever faked being drunk to do something embarrassing.",
      "Never have I ever stolen something from a store.",
      "Never have I ever cheated on a test or exam.",
      "Never have I ever called in sick to work when I was perfectly fine.",
      "Never have I ever lied about my relationship status.",
      "Never have I ever had a one-night stand.",
      "Never have I ever sent a nude to the wrong person.",
      "Never have I ever hooked up with someone whose name I didn't know.",
      "Never have I ever made out with someone at a party I just met.",
    ],
    'spicy': [
      // Bold, adult-oriented content
      "Never have I ever fallen asleep during sex.",
      "Never have I ever had sex in a public place.",
      "Never have I ever had a threesome.",
      "Never have I ever cheated on a partner.",
      "Never have I ever been to a strip club.",
      "Never have I ever sent nudes to multiple people at once.",
      "Never have I ever hooked up with someone in this room.",
      "Never have I ever had sex with someone I met online.",
      "Never have I ever been caught having sex.",
      "Never have I ever faked an orgasm.",
      "Never have I ever had a friends-with-benefits arrangement.",
      "Never have I ever watched adult content with someone else.",
      "Never have I ever had sex on the first date.",
      "Never have I ever experimented with the same gender.",
      "Never have I ever been in an open relationship.",
      "Never have I ever used handcuffs or restraints in the bedroom.",
      "Never have I ever had sex while drunk and regretted it.",
      "Never have I ever hooked up with a coworker.",
      "Never have I ever sent a sext to the wrong person.",
      "Never have I ever had a sexual dream about someone in this room.",
      "Never have I ever been to a sex shop.",
      "Never have I ever role-played in the bedroom.",
      "Never have I ever had sex in someone else's bed.",
      "Never have I ever joined the mile-high club.",
    ],
  };

  // ============================================================================
  // MOST LIKELY TO - Organized by Difficulty
  // ============================================================================
  
  static const Map<String, List<String>> _mostLikelyToByDifficulty = {
    'mild': [
      // Family-friendly scenarios
      "Most likely to become famous for something random.",
      "Most likely to win a game show.",
      "Most likely to become a millionaire by accident.",
      "Most likely to survive a zombie apocalypse.",
      "Most likely to cry during a comedy movie.",
      "Most likely to trip over nothing.",
      "Most likely to forget their own birthday.",
      "Most likely to accidentally set the kitchen on fire.",
      "Most likely to talk to animals like they understand.",
      "Most likely to get lost in their own neighborhood.",
      "Most likely to become a viral meme.",
      "Most likely to win an eating contest.",
      "Most likely to sleep through an important event.",
      "Most likely to become a professional gamer.",
      "Most likely to adopt 10 cats.",
      "Most likely to become a YouTuber.",
      "Most likely to invent something useless but popular.",
      "Most likely to laugh at their own jokes.",
      "Most likely to become a motivational speaker.",
      "Most likely to write a bestselling book.",
      "Most likely to become a conspiracy theorist.",
      "Most likely to start a weird collection.",
      "Most likely to become a hermit.",
      "Most likely to win the lottery and lose the ticket.",
    ],
    'moderate': [
      // Standard party predictions
      "Most likely to marry a stranger in Vegas.",
      "Most likely to join a cult.",
      "Most likely to get arrested for something stupid.",
      "Most likely to be the first one to die in a horror movie.",
      "Most likely to talk their way out of a speeding ticket.",
      "Most likely to date two people at once.",
      "Most likely to become an influencer.",
      "Most likely to spend all their rent money on clothes.",
      "Most likely to drunk text an ex.",
      "Most likely to get kicked out of a wedding.",
      "Most likely to fake their own death for attention.",
      "Most likely to catfish someone online.",
      "Most likely to have a secret OnlyFans.",
      "Most likely to get into a bar fight.",
      "Most likely to cheat in a relationship.",
      "Most likely to become a sugar baby or sugar daddy.",
      "Most likely to get a tattoo they'll regret.",
      "Most likely to hook up with their boss.",
      "Most likely to lie about their body count.",
      "Most likely to ghost someone after one date.",
      "Most likely to stalk their crush.",
      "Most likely to get plastic surgery.",
      "Most likely to have a midlife crisis at 25.",
      "Most likely to become a stripper.",
    ],
    'spicy': [
      // Bold, daring predictions
      "Most likely to have a sex tape leaked.",
      "Most likely to join a swingers club.",
      "Most likely to have an affair with a married person.",
      "Most likely to experiment with BDSM.",
      "Most likely to have a threesome.",
      "Most likely to sleep with someone for money.",
      "Most likely to get caught cheating.",
      "Most likely to have sex in a public bathroom.",
      "Most likely to be into feet.",
      "Most likely to have a secret kink.",
      "Most likely to hook up with their ex's sibling.",
      "Most likely to be a freak in the sheets.",
      "Most likely to have the highest body count.",
      "Most likely to send unsolicited nudes.",
      "Most likely to be into role-play.",
      "Most likely to have sex on a first date.",
      "Most likely to watch adult content at work.",
      "Most likely to have a sugar daddy or sugar mommy.",
      "Most likely to be in an open relationship.",
      "Most likely to hook up with a celebrity.",
      "Most likely to get arrested for public indecency.",
      "Most likely to have a one-night stand with a stranger.",
      "Most likely to experiment with toys in the bedroom.",
      "Most likely to be caught having sex in public.",
    ],
  };

  // ============================================================================
  // TRUTH QUESTIONS - Organized by Difficulty
  // ============================================================================
  
  static const Map<String, List<String>> _truthsByDifficulty = {
    'mild': [
      // Light, safe questions
      "What's the most embarrassing thing you've done in public?",
      "What's your most irrational fear?",
      "What's the weirdest food combination you enjoy?",
      "What's your guilty pleasure TV show or movie?",
      "What's the longest you've gone without showering?",
      "What's the most childish thing you still do?",
      "What's your most embarrassing childhood memory?",
      "What's the worst gift you've ever received?",
      "What's your biggest pet peeve?",
      "What's the most embarrassing thing in your search history?",
      "What's your most unpopular opinion?",
      "What's the worst lie you've ever told?",
      "What's your biggest insecurity?",
      "What's the most trouble you've gotten into at school or work?",
      "What's your most cringe-worthy fashion phase?",
      "What's the most money you've wasted on something useless?",
      "What's your secret talent that no one knows about?",
      "What's the most embarrassing song on your playlist?",
    ],
    'moderate': [
      // Standard personal questions
      "What is the most embarrassing thing you've ever done drunk?",
      "Who is your secret crush right now?",
      "What is the biggest lie you've ever told your parents?",
      "Have you ever cheated on a test?",
      "What is your biggest turn-off?",
      "Who in this room would you trade lives with for a day?",
      "What's the most illegal thing you've ever done?",
      "Have you ever been in love with two people at the same time?",
      "What's the worst date you've ever been on?",
      "Have you ever snooped through someone's phone?",
      "What's your biggest regret in a relationship?",
      "Have you ever lied to get out of a relationship?",
      "What's the most embarrassing thing you've done to get someone's attention?",
      "Have you ever ghosted someone? Why?",
      "What's your body count?",
      "Have you ever cheated in a relationship?",
      "What's the biggest secret you're keeping from your parents?",
      "Have you ever stolen from a friend or family member?",
      "What's the meanest thing you've ever said about someone?",
      "Have you ever faked being sick to avoid someone?",
    ],
    'spicy': [
      // Bold, revealing questions
      "What's your wildest sexual fantasy?",
      "Have you ever had a one-night stand you regretted?",
      "What's the kinkiest thing you've ever done?",
      "Have you ever sent nudes to someone you shouldn't have?",
      "What's your favorite position?",
      "Have you ever hooked up with someone in this room?",
      "What's the weirdest place you've had sex?",
      "Have you ever watched adult content with someone else?",
      "What's your biggest turn-on?",
      "Have you ever faked an orgasm?",
      "What's the most people you've slept with in a week?",
      "Have you ever been to a sex shop? What did you buy?",
      "What's your most embarrassing sexual experience?",
      "Have you ever experimented with the same gender?",
      "What's the longest you've gone without sex?",
      "Have you ever used toys in the bedroom?",
      "What's the most adventurous sexual thing you've done?",
      "Have you ever had sex while someone else was in the room?",
      "What's your biggest sexual regret?",
      "Have you ever role-played? What was the scenario?",
    ],
  };

  // ============================================================================
  // DARE CHALLENGES - Organized by Difficulty
  // ============================================================================
  
  static const Map<String, List<String>> _daresByDifficulty = {
    'mild': [
      // Safe, fun dares
      "Do your best impression of someone in the room.",
      "Speak in an accent for the next 3 rounds.",
      "Call a random contact and sing Happy Birthday.",
      "Do 20 pushups right now.",
      "Talk without closing your mouth for the next 2 minutes.",
      "Let someone tickle you for 30 seconds without laughing.",
      "Dance with no music for 1 minute.",
      "Eat a spoonful of a condiment of the group's choice.",
      "Post an embarrassing photo from your camera roll.",
      "Let someone draw on your face with a marker.",
      "Wear your clothes backward for the rest of the game.",
      "Do your best celebrity impression.",
      "Sing everything you say for the next 3 rounds.",
      "Let the group go through your phone for 2 minutes.",
      "Do a handstand or attempt one.",
      "Imitate a baby being born.",
      "Let someone style your hair however they want.",
      "Eat a raw onion slice.",
    ],
    'moderate': [
      // Standard party dares
      "Let another player post a status on your social media.",
      "Let the group mix a drink for you with any available ingredients.",
      "Show the last photo in your camera roll.",
      "Text your crush and tell them you like them.",
      "Let someone read your last 5 text messages out loud.",
      "Call your ex and tell them you miss them.",
      "Post an embarrassing status on social media for 1 hour.",
      "Let the group look through your DMs.",
      "Kiss the person to your left.",
      "Take a shot of hot sauce.",
      "Let someone go through your search history.",
      "Send a risky text to someone the group chooses.",
      "Do a body shot off someone in the group.",
      "Let someone write a text to anyone in your contacts.",
      "Show your most embarrassing photo to the group.",
      "Prank call someone and try to keep them on the line for 2 minutes.",
      "Let the group create a Tinder profile for you.",
      "Wear someone else's underwear on your head for 5 minutes.",
      "Let someone give you a hickey.",
      "Take off an article of clothing (your choice).",
    ],
    'spicy': [
      // Bold, daring challenges
      "Give someone in the room a lap dance.",
      "Make out with the person to your right for 30 seconds.",
      "Send a nude to someone the group chooses.",
      "Let someone spank you.",
      "Take off your shirt for the rest of the game.",
      "Describe your last sexual experience in detail.",
      "Let someone give you a sensual massage for 2 minutes.",
      "Kiss the hottest person in the room.",
      "Show the group your nudes folder.",
      "Let someone lick whipped cream off your body.",
      "Demonstrate your favorite position using a pillow.",
      "Let the group read your sexts out loud.",
      "Give someone a hickey on their neck.",
      "Take a body shot off the person of your choice.",
      "Let someone remove an article of your clothing.",
      "Whisper something dirty in someone's ear.",
      "Twerk for 1 minute.",
      "Let someone tie you up for the next round.",
      "Send a sext to your most recent contact.",
      "Strip down to your underwear for the rest of the game.",
    ],
  };

  // ============================================================================
  // HELPER METHODS - Get content by difficulty level
  // ============================================================================
  
  /// Get Never Have I Ever statements for a specific difficulty level
  static List<String> getNeverHaveIEver(DifficultyLevel difficulty) {
    return _neverHaveIEverByDifficulty[difficulty.storageKey] ?? 
           _neverHaveIEverByDifficulty['moderate']!;
  }

  /// Get Most Likely To scenarios for a specific difficulty level
  static List<String> getMostLikelyTo(DifficultyLevel difficulty) {
    return _mostLikelyToByDifficulty[difficulty.storageKey] ?? 
           _mostLikelyToByDifficulty['moderate']!;
  }

  /// Get Truth questions for a specific difficulty level
  static List<String> getTruths(DifficultyLevel difficulty) {
    return _truthsByDifficulty[difficulty.storageKey] ?? 
           _truthsByDifficulty['moderate']!;
  }

  /// Get Dare challenges for a specific difficulty level
  static List<String> getDares(DifficultyLevel difficulty) {
    return _daresByDifficulty[difficulty.storageKey] ?? 
           _daresByDifficulty['moderate']!;
  }

  // ============================================================================
  // BACKWARD COMPATIBILITY - Keep old static lists for legacy code
  // ============================================================================
  
  /// @deprecated Use getNeverHaveIEver(DifficultyLevel.moderate) instead
  static List<String> get neverHaveIEver => 
      _neverHaveIEverByDifficulty['moderate']!;

  /// @deprecated Use getMostLikelyTo(DifficultyLevel.moderate) instead
  static List<String> get mostLikelyTo => 
      _mostLikelyToByDifficulty['moderate']!;

  /// @deprecated Use getTruths(DifficultyLevel.moderate) instead
  static List<String> get truths => 
      _truthsByDifficulty['moderate']!;

  /// @deprecated Use getDares(DifficultyLevel.moderate) instead
  static List<String> get dares => 
      _daresByDifficulty['moderate']!;
}
