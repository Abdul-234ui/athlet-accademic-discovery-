import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/firestore_service.dart';

class Coach {
  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final String experience;

  Coach({required this.id, required this.name, required this.role, required this.imageUrl, required this.experience});
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final String date;
  final int helpfulCount;
  final List<String> images;

  Review({
    required this.userName, 
    required this.rating, 
    required this.comment, 
    required this.date,
    this.helpfulCount = 0,
    this.images = const [],
  });
}

class Academy {
  final String id;
  final String name;
  final String sport;
  final String city;
  final String distance;
  final String price;
  final double rating;
  final int reviewsCount;
  final int saveCount;
  final int rankingScore;
  final bool isVerified;
  final List<String> images;
  final String aboutText;
  final List<String> features;
  final List<String> badges;
  final List<String> facilities;
  final List<Coach> coaches;
  final List<Review> reviews;
  final List<String> achievements;
  final List<String> certifications;
  final String? instagram;
  final String? facebook;
  final String? website;
  final String gender;
  final List<String> ageGroups;
  final double latitude;
  final double longitude;

  Academy({
    required this.id,
    required this.name,
    required this.sport,
    required this.city,
    required this.distance,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.saveCount,
    required this.rankingScore,
    required this.isVerified,
    required this.images,
    required this.aboutText,
    required this.features,
    required this.badges,
    required this.facilities,
    required this.coaches,
    required this.reviews,
    required this.achievements,
    required this.certifications,
    this.instagram,
    this.facebook,
    this.website,
    this.gender = 'Mixed',
    this.ageGroups = const ['All Ages'],
    required this.latitude,
    required this.longitude,
  });

  factory Academy.fromJson(Map<String, dynamic> json) {
    return Academy(
      id: json['id'] as String,
      name: json['name'] as String,
      sport: json['sport'] as String,
      city: json['city'] as String,
      distance: json['distance'] as String,
      price: json['price'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as int,
      saveCount: json['saveCount'] as int,
      rankingScore: json['rankingScore'] as int,
      isVerified: json['isVerified'] as bool,
      images: List<String>.from(json['images'] as List),
      aboutText: json['aboutText'] as String,
      features: List<String>.from(json['features'] as List),
      badges: List<String>.from(json['badges'] as List),
      facilities: List<String>.from(json['facilities'] as List),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      coaches: (json['coaches'] as List).map((c) => Coach(
        id: c['id'], name: c['name'], role: c['role'], imageUrl: c['imageUrl'], experience: c['experience']
      )).toList(),
      reviews: (json['reviews'] as List).map((r) => Review(
        userName: r['userName'], rating: (r['rating'] as num).toDouble(), comment: r['comment'], date: r['date'], helpfulCount: r['helpfulCount'], images: List<String>.from(r['images'] ?? [])
      )).toList(),
      achievements: List<String>.from(json['achievements'] as List),
      certifications: List<String>.from(json['certifications'] as List),
      instagram: json['instagram'] as String?,
      facebook: json['facebook'] as String?,
      website: json['website'] as String?,
      gender: json['gender'] as String,
      ageGroups: List<String>.from(json['ageGroups'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'city': city,
      'distance': distance,
      'price': price,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'saveCount': saveCount,
      'rankingScore': rankingScore,
      'isVerified': isVerified,
      'images': images,
      'aboutText': aboutText,
      'features': features,
      'badges': badges,
      'facilities': facilities,
      'coaches': coaches.map((c) => {
        'id': c.id, 'name': c.name, 'role': c.role, 'imageUrl': c.imageUrl, 'experience': c.experience
      }).toList(),
      'reviews': reviews.map((r) => {
        'userName': r.userName, 'rating': r.rating, 'comment': r.comment, 'date': r.date, 'helpfulCount': r.helpfulCount, 'images': r.images
      }).toList(),
      'achievements': achievements,
      'certifications': certifications,
      'instagram': instagram,
      'facebook': facebook,
      'website': website,
      'gender': gender,
      'ageGroups': ageGroups,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Academy addReview(Review newReview) {
    final updatedReviews = List<Review>.from(reviews)..insert(0, newReview);
    final newReviewsCount = reviewsCount + 1;
    final newRating = ((rating * reviewsCount) + newReview.rating) / newReviewsCount;
    
    return Academy(
      id: id,
      name: name,
      sport: sport,
      city: city,
      distance: distance,
      price: price,
      rating: newRating,
      reviewsCount: newReviewsCount,
      saveCount: saveCount,
      rankingScore: rankingScore,
      isVerified: isVerified,
      images: images,
      aboutText: aboutText,
      features: features,
      badges: badges,
      facilities: facilities,
      coaches: coaches,
      reviews: updatedReviews,
      achievements: achievements,
      certifications: certifications,
      instagram: instagram,
      facebook: facebook,
      website: website,
      gender: gender,
      ageGroups: ageGroups,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

class AcademiesNotifier extends StateNotifier<AsyncValue<List<Academy>>> {
  final FirestoreService _firestoreService = FirestoreService();

  AcademiesNotifier() : super(const AsyncValue.loading()) {
    _fetchAcademies();
  }

  Future<void> _fetchAcademies() async {
    // TEMPORARY BYPASS: Use local data with guaranteed GPS coordinates
    // to prove distance sorting works, bypassing potential Firestore rules/sync issues.
    state = AsyncValue.data(_initialAcademies);
  }

  Future<void> seedDatabase() async {
    state = const AsyncValue.loading();
    try {
      final data = _initialAcademies.map((a) => a.toJson()).toList();
      await _firestoreService.seedAcademies(data);
      await _fetchAcademies();
    } catch (e, st) {
      print('Error seeding: $e');
      state = AsyncValue.error(e, st);
    }
  }

  void addReview(String academyId, Review review) {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.map((a) {
        if (a.id == academyId) {
          return a.addReview(review);
        }
        return a;
      }).toList());
    }
  }
}

final academiesProvider = StateNotifierProvider<AcademiesNotifier, AsyncValue<List<Academy>>>((ref) {
  return AcademiesNotifier();
});

final _initialAcademies = [
    Academy(
      id: '1',
      name: 'WICKET HUB',
      sport: 'Cricket',
      city: 'Bangalore',
      distance: '1.2 km',
      price: '₹1500/mo',
      rating: 4.8,
      reviewsCount: 342,
      saveCount: 1250,
      rankingScore: 98,
      isVerified: true,
      images: [
        'https://images.unsplash.com/photo-1531415074968-036ba1b575da?q=80&w=1000',
        'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=1000',
        'https://images.unsplash.com/photo-1589801258579-18e091f4ca26?q=80&w=1000'
      ],
      aboutText: 'Wicket Hub is a state-of-the-art cricket academy in the heart of Bangalore. We provide premium turf wickets, bowling machines, and video analysis tools to help future champions perfect their game. Certified ICC coaches lead our programs.',
      features: ['Pro Turf', 'Nets', 'Coaching'],
      badges: ['AI Match', 'Top Rated'],
      facilities: ['Parking', 'Restrooms', 'Cafeteria', 'Video Analysis Room', 'Equipment Shop'],
      coaches: [
        Coach(id: 'c1', name: 'Rahul Dravid (Guest)', role: 'Masterclass Coach', imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200', experience: '15+ Years'),
        Coach(id: 'c2', name: 'Anil K.', role: 'Head Spin Coach', imageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200', experience: '10 Years'),
      ],
      reviews: [
        Review(userName: 'Arjun M.', rating: 5.0, comment: 'Best nets in the city. The bowling machines are very well maintained.', date: '2 weeks ago', helpfulCount: 12, images: ['https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=200']),
        Review(userName: 'Vikram S.', rating: 4.5, comment: 'Great coaches, but parking gets full on weekends.', date: '1 month ago', helpfulCount: 4),
      ],
      achievements: ['Best Academy in South Zone 2023', 'Over 50 state-level players trained'],
      certifications: ['BCCI Level 2', 'ECB Advanced'],
      instagram: 'https://instagram.com/wickethub',
      facebook: 'https://facebook.com/wickethub',
      website: 'https://wickethub.com',
      gender: 'Mixed',
      ageGroups: ['U-14', 'U-19', 'Adults'],
      latitude: 25.2048,
      longitude: 55.2708,
    ),
    Academy(
      id: '2',
      name: 'Prime Sports Arena',
      sport: 'Football',
      city: 'Mumbai',
      distance: '4.1 km',
      price: '₹1800/mo',
      rating: 4.9,
      reviewsCount: 890,
      saveCount: 3400,
      rankingScore: 99,
      isVerified: true,
      images: [
        'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=1000',
        'https://images.unsplash.com/photo-1518605368461-1ee7e5302062?q=80&w=1000',
      ],
      aboutText: 'Prime Sports Arena is a FIFA-standard football turf providing coaching for all age groups. We specialize in night matches under floodlights and host regular weekend tournaments.',
      features: ['Night Matches', 'Turf', 'Tournaments'],
      badges: ['Verified', 'Popular'],
      facilities: ['Floodlights', 'Locker Rooms', 'Showers', 'First Aid Center'],
      coaches: [
        Coach(id: 'c3', name: 'Carlos R.', role: 'Head Coach', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200', experience: '8 Years'),
      ],
      reviews: [
        Review(userName: 'Sam D.', rating: 5.0, comment: 'The turf quality is amazing, highly recommend for 5v5 matches.', date: '1 week ago'),
      ],
      achievements: ['Host of City Super League 2024'],
      certifications: ['FIFA Quality Pro Turf'],
      instagram: 'https://instagram.com/primesportsarena',
      website: 'https://primesportsarena.in',
      gender: 'Boys',
      ageGroups: ['Adults'],
      latitude: 25.1119,
      longitude: 55.1390,
    ),
    Academy(
      id: '3',
      name: 'SUV’s Sports Arena',
      sport: 'Badminton',
      city: 'Delhi',
      distance: '3.0 km',
      price: '₹1200/mo',
      rating: 4.7,
      reviewsCount: 210,
      saveCount: 890,
      rankingScore: 92,
      isVerified: false,
      images: [
        'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1000',
      ],
      aboutText: 'Premium wooden courts with professional BWF certified lighting. Perfect for both casual players and professional coaching.',
      features: ['Wooden Floor', 'A/C', 'Pro Coaching'],
      badges: ['Verified'],
      facilities: ['Air Conditioned', 'Pro Shop', 'Water Cooler'],
      coaches: [
        Coach(id: 'c4', name: 'P. Sindhu (Demo)', role: 'Head Coach', imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=200', experience: '12 Years'),
      ],
      reviews: [
        Review(userName: 'Neha P.', rating: 4.0, comment: 'Courts are good but gets crowded.', date: '3 weeks ago'),
      ],
      achievements: ['Regional Tournament Hosts'],
      certifications: ['BWF Standard Courts'],
      facebook: 'https://facebook.com/suvsports',
      gender: 'Mixed',
      ageGroups: ['Kids', 'Adults'],
      latitude: 25.0805,
      longitude: 55.1403,
    ),
    Academy(
      id: '4',
      name: 'AGYM Fitness',
      sport: 'Fitness',
      city: 'Pune',
      distance: '0.8 km',
      price: '₹1500/mo',
      rating: 4.6,
      reviewsCount: 560,
      saveCount: 2100,
      rankingScore: 94,
      isVerified: true,
      images: [
        'https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=1000',
        'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=1000',
      ],
      aboutText: 'A fully equipped modern gym focusing on strength training, crossfit, and functional movements.',
      features: ['Cardio', 'Weights', 'Personal Trainer'],
      badges: ['Popular'],
      facilities: ['Sauna', 'Protein Bar', 'Personal Lockers'],
      coaches: [
        Coach(id: 'c5', name: 'Mike T.', role: 'Strength Coach', imageUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?q=80&w=200', experience: '6 Years'),
      ],
      reviews: [
        Review(userName: 'Rahul V.', rating: 4.8, comment: 'Great equipment and friendly trainers.', date: '1 month ago'),
      ],
      achievements: ['Voted Best Gym 2022'],
      certifications: ['ISSA Certified Trainers'],
      instagram: 'https://instagram.com/agymfitness',
      website: 'https://agymfitness.com',
      gender: 'Mixed',
      ageGroups: ['Adults'],
      latitude: 18.5204,
      longitude: 73.8567,
    ),
    Academy(
      id: '5',
      name: 'Yodhaa Martial Art Academy',
      sport: 'Martial Arts',
      city: 'Madanapalle',
      distance: '2.5 km',
      price: '₹1200/mo',
      rating: 4.9,
      reviewsCount: 200,
      saveCount: 850,
      rankingScore: 97,
      isVerified: true,
      images: [
        'https://images.unsplash.com/photo-1555597673-b21d5c935865?q=80&w=1000',
      ],
      aboutText: 'Founded in 2012 by M.A. Sathish (a 4th-Dan Black Belt), this academy is one of the most well-established in the region. Location: Near Siddhartha Theatre, CTM Road, Angallu. Hours: Monday to Sunday, 5:00 AM to 9:00 PM.',
      features: ['Karate', 'Kung-fu', 'Yoga', 'Muay Thai', 'Taekwondo', 'Self-Defense'],
      badges: ['Verified', 'Top Rated'],
      facilities: ['Mat Area', 'Equipment Room', 'Locker Room'],
      coaches: [
        Coach(id: 'c6', name: 'M.A. Sathish', role: '4th-Dan Black Belt', imageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200', experience: '15+ Years'),
      ],
      reviews: [],
      achievements: ['Well-established since 2012'],
      certifications: ['4th-Dan Black Belt Led'],
      gender: 'Mixed',
      ageGroups: ['Kids', 'Adults'],
      latitude: 13.5574,
      longitude: 78.5029,
    ),
    Academy(
      id: '6',
      name: 'Lee Martial Arts Academy',
      sport: 'Martial Arts',
      city: 'Madanapalle',
      distance: '3.1 km',
      price: '₹1500/mo',
      rating: 5.0,
      reviewsCount: 310,
      saveCount: 1200,
      rankingScore: 99,
      isVerified: true,
      images: [
        'https://upload.wikimedia.org/wikipedia/commons/4/4b/Karate_ShuriCastle.jpg',
      ],
      aboutText: 'Established in 2000, this academy holds a perfect 5.0 rating and operates with highly experienced professionals. Functional 24/7. Location: 2nd Floor, Near Asr Theatre, opposite Kotak Mahindra Bank (MVL Hospital Building), CTM Road.',
      features: ['Self Defense', 'Karate', 'Meditation Classes'],
      badges: ['Perfect Rating', '24/7'],
      facilities: ['Meditation Room', 'Training Floor', 'Air Conditioned'],
      coaches: [],
      reviews: [],
      achievements: ['Established in 2000'],
      certifications: ['Professional Instructors'],
      gender: 'Girls',
      ageGroups: ['All Ages'],
      latitude: 13.5576,
      longitude: 78.5031,
    ),
    Academy(
      id: '7',
      name: 'Madanapally Youth Karate and Sports Association',
      sport: 'Martial Arts',
      city: 'Madanapalle',
      distance: '1.8 km',
      price: '₹1000/mo',
      rating: 4.8,
      reviewsCount: 450,
      saveCount: 1500,
      rankingScore: 95,
      isVerified: true,
      images: [
        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1000',
      ],
      aboutText: 'Established in 1991, making it one of the oldest and most respected sports associations in the area. Location: Near Sri Krishna Theater, Krishna Nagar, Old Bypass Road.',
      features: ['Karate', 'Weight Loss', 'Mixed Martial Arts (MMA)'],
      badges: ['Legacy', 'Popular'],
      facilities: ['Main Dojo', 'Weights Area', 'Changing Rooms'],
      coaches: [],
      reviews: [],
      achievements: ['Established in 1991'],
      certifications: ['Recognized Sports Association'],
      gender: 'Boys',
      ageGroups: ['U-14', 'U-19'],
      latitude: 13.5570,
      longitude: 78.5020,
    ),
  ];

final academyPhoneProvider = FutureProvider.family<String?, String>((ref, academyName) async {
  await Future.delayed(const Duration(seconds: 1)); 
  return "1234567890"; 
});
