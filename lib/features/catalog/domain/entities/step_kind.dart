/// A step in a skin ritual, with its default time in minutes.
enum StepKind {
  cleanse('Cleanse', 2, core: true),
  tone('Tone', 1),
  exfoliate('Polish', 2),
  serum('Treat', 1, core: true),
  eye('Eyes', 1),
  oil('Seal', 1),
  moisturise('Moisturise', 1, core: true),
  spf('Protect', 1, core: true);

  const StepKind(this.label, this.minutes, {this.core = false});

  final String label;
  final int minutes;

  /// Core steps are never dropped to fit the time budget.
  final bool core;
}
