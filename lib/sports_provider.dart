import 'package:flutter_riverpod/flutter_riverpod.dart';

class Benefit {
  final String title;
  final String description;

  Benefit({required this.title, required this.description});
}

class Sport {
  final String id;
  final String name;
  final String heroImage;
  final String description;
  final List<Benefit> physicalBenefits;
  final List<Benefit> mentalBenefits;

  Sport({
    required this.id,
    required this.name,
    required this.heroImage,
    required this.description,
    required this.physicalBenefits,
    required this.mentalBenefits,
  });
}

final sportsProvider = Provider<List<Sport>>((ref) {
  return [
    Sport(
      id: 'cricket',
      name: 'Cricket',
      heroImage: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?q=80&w=1000',
      description: 'Cricket is a bat-and-ball game played between two teams of eleven players on a field at the centre of which is a 22-yard pitch with a wicket at each end.',
      physicalBenefits: [
        Benefit(title: 'Stamina', description: 'Improves cardiovascular health through constant running and quick sprints.'),
        Benefit(title: 'Hand-Eye Coordination', description: 'Enhances motor skills by tracking the fast-moving ball.'),
        Benefit(title: 'Agility', description: 'Develops quick reflexes required for fielding and batting.'),
      ],
      mentalBenefits: [
        Benefit(title: 'Strategic Thinking', description: 'Requires planning and tactical adjustments based on the game situation.'),
        Benefit(title: 'Teamwork', description: 'Fosters collaboration and communication with teammates.'),
        Benefit(title: 'Patience', description: 'Builds resilience and patience, especially in longer formats of the game.'),
      ],
    ),
    Sport(
      id: 'football',
      name: 'Football',
      heroImage: 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=1000',
      description: 'Football is a family of team sports that involve, to varying degrees, kicking a ball to score a goal.',
      physicalBenefits: [
        Benefit(title: 'Cardiovascular Fitness', description: 'Running across the field improves heart health and endurance.'),
        Benefit(title: 'Muscle Strength', description: 'Builds lower body strength and core stability.'),
        Benefit(title: 'Bone Density', description: 'Weight-bearing exercises improve bone strength.'),
      ],
      mentalBenefits: [
        Benefit(title: 'Quick Decision Making', description: 'Players must analyze the field and make split-second decisions.'),
        Benefit(title: 'Discipline', description: 'Requires strict adherence to rules and regular practice schedules.'),
      ],
    ),
    Sport(
      id: 'badminton',
      name: 'Badminton',
      heroImage: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1000',
      description: 'Badminton is a racquet sport played using racquets to hit a shuttlecock across a net.',
      physicalBenefits: [
        Benefit(title: 'Flexibility', description: 'Constant stretching and reaching improves overall flexibility.'),
        Benefit(title: 'Metabolism', description: 'High-intensity rallies burn significant calories.'),
        Benefit(title: 'Reflexes', description: 'The fast pace of the shuttlecock requires lightning-fast reactions.'),
      ],
      mentalBenefits: [
        Benefit(title: 'Focus', description: 'Intense concentration is needed to track the shuttlecock.'),
        Benefit(title: 'Stress Relief', description: 'The physical exertion releases endorphins, reducing stress.'),
      ],
    ),
    Sport(
      id: 'fitness',
      name: 'Fitness',
      heroImage: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1000',
      description: 'Fitness training encompasses a range of physical activities focused on strength, endurance, and overall well-being.',
      physicalBenefits: [
        Benefit(title: 'Overall Strength', description: 'Lifting and resistance exercises build muscle mass.'),
        Benefit(title: 'Immunity', description: 'Regular exercise boosts the immune system.'),
      ],
      mentalBenefits: [
        Benefit(title: 'Confidence', description: 'Achieving fitness goals boosts self-esteem and body image.'),
        Benefit(title: 'Mental Clarity', description: 'Exercise increases blood flow to the brain, improving cognitive function.'),
      ],
    ),
    Sport(
      id: 'martial_arts',
      name: 'Martial Arts',
      heroImage: 'https://images.unsplash.com/photo-1555597673-b21d5c935865?q=80&w=1000',
      description: 'Martial arts are codified systems and traditions of combat practiced for a number of reasons such as self-defense; military and law enforcement applications; competition; physical, mental, and spiritual development.',
      physicalBenefits: [
        Benefit(title: 'Flexibility & Balance', description: 'Enhances body control through dynamic stretching and postures.'),
        Benefit(title: 'Core Strength', description: 'Builds immense core power necessary for striking and grappling.'),
        Benefit(title: 'Cardiovascular Health', description: 'Intense sparring and drills significantly improve heart rate and stamina.'),
      ],
      mentalBenefits: [
        Benefit(title: 'Discipline', description: 'Instills deep respect, self-control, and adherence to tradition.'),
        Benefit(title: 'Stress Relief', description: 'Releases tension through controlled physical exertion and focus.'),
        Benefit(title: 'Self-Confidence', description: 'Empowers individuals with the knowledge and capability of self-defense.'),
      ],
    ),
  ];
});
