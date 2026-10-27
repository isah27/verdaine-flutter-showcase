/// The five quick questions, in order. Each one pours a layer into the bottle.
enum OnboardingQuestion {
  name('What should we call you?', 'Your name goes on the label.'),
  skinType(
    'How does your skin feel?',
    'Pick the one that sounds most like you.',
  ),
  concerns('What should it work on?', 'Choose up to three.'),
  moment('When is your ritual?', 'This sets the mood of your home screen.'),
  minutes('How long can you give it?', "We'll fit the steps into this time.");

  const OnboardingQuestion(this.title, this.hint);

  final String title;
  final String hint;

  bool get isLast => this == OnboardingQuestion.minutes;
}
