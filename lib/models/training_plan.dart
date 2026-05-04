// Complete training plans for every level × goal combination.
// Levels : Beginner | Intermediate | Advanced
// Goals  : Sprint | Olympic | Half Ironman | Ironman
// Each plan covers 8 weeks of structured swim / bike / run sessions.

class TrainingSession {
  final String discipline; // 'Swim' | 'Bike' | 'Run' | 'Rest'
  final String description;
  final String duration;
  final String distance;
  final bool isRest;

  const TrainingSession({
    required this.discipline,
    required this.description,
    required this.duration,
    required this.distance,
    this.isRest = false,
  });
}

class TrainingWeek {
  final int weekNumber;
  final String theme;
  final List<TrainingSession> sessions;

  const TrainingWeek({
    required this.weekNumber,
    required this.theme,
    required this.sessions,
  });
}

class TrainingPlan {
  final String level;
  final String goal;
  final String description;
  final List<TrainingWeek> weeks;

  const TrainingPlan({
    required this.level,
    required this.goal,
    required this.description,
    required this.weeks,
  });
}

// Convenience shorthand used throughout this file
const _rest = TrainingSession(
  discipline: 'Rest',
  description: 'Rest or light stretching',
  duration: '-',
  distance: '-',
  isRest: true,
);
const _fullRest = TrainingSession(
  discipline: 'Rest',
  description: 'Full rest',
  duration: '-',
  distance: '-',
  isRest: true,
);
const _raceDay = TrainingSession(
  discipline: 'Rest',
  description: 'Race Day',
  duration: '-',
  distance: '-',
  isRest: true,
);

class PlanRepository {
  static TrainingPlan getPlan(String level, String goal) {
    final key =
        '${level.toLowerCase()}_${goal.toLowerCase().replaceAll(' ', '_')}';
    // Fallback to beginner_sprint if somehow an unknown key is passed
    return _plans[key] ?? _plans['beginner_sprint']!;
  }

  static const Map<String, TrainingPlan> _plans = {
    // ════════════════════════════════════════════════════
    //  BEGINNER
    // ════════════════════════════════════════════════════

    // ── Beginner · Sprint ─────────────────────────────────
    'beginner_sprint': TrainingPlan(
      level: 'Beginner',
      goal: 'Sprint',
      description:
          '8-week plan to complete your first Sprint Triathlon '
          '(750m swim · 20km bike · 5km run). '
          'Focused on building base fitness across all three disciplines.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Getting Started',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy pool swim — focus on technique',
              duration: '20 min',
              distance: '400m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy jog or walk-run intervals',
              duration: '20 min',
              distance: '2 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy flat ride',
              duration: '30 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Drills and easy laps',
              duration: '25 min',
              distance: '500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Building Rhythm',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous easy swim',
              duration: '25 min',
              distance: '500m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy continuous run',
              duration: '25 min',
              distance: '3 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady flat ride',
              duration: '35 min',
              distance: '12 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Drills + 4×50m intervals',
              duration: '30 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Short brick run after bike',
              duration: '15 min',
              distance: '2 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Endurance Base',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy continuous swim',
              duration: '30 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Moderate ride with slight hills',
              duration: '40 min',
              distance: '15 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy run',
              duration: '30 min',
              distance: '4 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Technique + 6×50m intervals',
              duration: '35 min',
              distance: '700m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy technique swim',
              duration: '20 min',
              distance: '400m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy recovery run',
              duration: '20 min',
              distance: '2.5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy flat spin',
              duration: '30 min',
              distance: '10 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Pace Intro',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '750m at race pace effort',
              duration: '30 min',
              distance: '750m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady ride at race effort',
              duration: '45 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Tempo run',
              duration: '30 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '8×50m intervals',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick: bike then 10-min run',
              duration: '50 min',
              distance: '18 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Building Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 800m',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long ride',
              duration: '50 min',
              distance: '22 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long easy run',
              duration: '40 min',
              distance: '6 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Race simulation 750m',
              duration: '30 min',
              distance: '750m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Peak Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2×400m with 1 min rest',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace ride',
              duration: '45 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 5km',
              duration: '30 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick workout',
              duration: '50 min',
              distance: '18 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy taper swim',
              duration: '20 min',
              distance: '400m',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Short easy swim',
              duration: '15 min',
              distance: '300m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy shakeout run',
              duration: '15 min',
              distance: '2 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin',
              duration: '20 min',
              distance: '8 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Beginner · Olympic ────────────────────────────────
    'beginner_olympic': TrainingPlan(
      level: 'Beginner',
      goal: 'Olympic',
      description:
          '8-week introductory plan for the Olympic distance '
          '(1500m swim · 40km bike · 10km run). '
          'Builds aerobic base before progressing to race-pace work.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Base Building',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy technique swim',
              duration: '25 min',
              distance: '500m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy jog',
              duration: '25 min',
              distance: '3 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy flat ride',
              duration: '40 min',
              distance: '14 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Drills + 6×50m',
              duration: '30 min',
              distance: '600m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Building Rhythm',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 600m',
              duration: '30 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 4km',
              duration: '30 min',
              distance: '4 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady ride',
              duration: '45 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '8×50m intervals',
              duration: '35 min',
              distance: '700m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Short brick run',
              duration: '15 min',
              distance: '2 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Endurance Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 800m',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hilly 20km',
              duration: '55 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 5km',
              duration: '35 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '10×100m intervals',
              duration: '45 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 400m',
              duration: '20 min',
              distance: '400m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin',
              duration: '30 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 3km',
              duration: '25 min',
              distance: '3 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Pace Intro',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1000m at race effort',
              duration: '40 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 25km',
              duration: '60 min',
              distance: '25 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Tempo 6km',
              duration: '40 min',
              distance: '6 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '12×100m',
              duration: '50 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 20km + 3km run',
              duration: '65 min',
              distance: '20 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Volume Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 1200m',
              duration: '45 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 32km',
              duration: '75 min',
              distance: '32 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 8km',
              duration: '55 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race simulation',
              duration: '50 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Peak Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Race-pace 1500m',
              duration: '50 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 40km',
              duration: '90 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 10km',
              duration: '60 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 30km + 4km run',
              duration: '80 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy taper 600m',
              duration: '25 min',
              distance: '600m',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 500m',
              duration: '20 min',
              distance: '500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin',
              duration: '25 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 3km shakeout',
              duration: '20 min',
              distance: '3 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Beginner · Half Ironman ───────────────────────────
    'beginner_half_ironman': TrainingPlan(
      level: 'Beginner',
      goal: 'Half Ironman',
      description:
          '8-week foundation plan for the Half Ironman '
          '(1.9km swim · 90km bike · 21.1km run). '
          'Emphasises building aerobic capacity and time on feet.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Foundation',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '30 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 4km',
              duration: '30 min',
              distance: '4 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 20km',
              duration: '55 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Drills + 8×50m',
              duration: '35 min',
              distance: '700m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Aerobic Base',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 800m',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 6km',
              duration: '40 min',
              distance: '6 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady 30km',
              duration: '75 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '10×100m with 30s rest',
              duration: '45 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Brick run 3km',
              duration: '20 min',
              distance: '3 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Building Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1000m easy',
              duration: '40 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hilly 40km',
              duration: '100 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 8km',
              duration: '55 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m continuous',
              duration: '50 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '25 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 20km',
              duration: '50 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 4km',
              duration: '30 min',
              distance: '4 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Endurance Focus',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race simulation',
              duration: '60 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 60km',
              duration: '150 min',
              distance: '60 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 12km',
              duration: '75 min',
              distance: '12 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '16×100m',
              duration: '55 min',
              distance: '1600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 50km + 5km run',
              duration: '130 min',
              distance: '50 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Peak Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2000m mixed sets',
              duration: '60 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 75km',
              duration: '190 min',
              distance: '75 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 16km',
              duration: '100 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race pace',
              duration: '50 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Race Sharpening',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race effort',
              duration: '60 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 90km',
              duration: '225 min',
              distance: '90 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 18km',
              duration: '110 min',
              distance: '18 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy taper 800m',
              duration: '30 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '20 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 20km spin',
              duration: '45 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 5km shakeout',
              duration: '30 min',
              distance: '5 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Beginner · Ironman ────────────────────────────────
    'beginner_ironman': TrainingPlan(
      level: 'Beginner',
      goal: 'Ironman',
      description:
          '8-week preparatory block for the full Ironman '
          '(3.8km swim · 180km bike · 42.2km run). '
          'Designed for beginners who need a solid aerobic foundation.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Base Foundation',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 5km',
              duration: '35 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 30km',
              duration: '75 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '10×100m intervals',
              duration: '45 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Aerobic Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 1200m',
              duration: '45 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 8km',
              duration: '55 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady 50km',
              duration: '125 min',
              distance: '50 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '12×100m with 20s rest',
              duration: '50 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Brick run 5km',
              duration: '30 min',
              distance: '5 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Endurance Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Continuous 1500m',
              duration: '50 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 70km',
              duration: '175 min',
              distance: '70 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 12km',
              duration: '75 min',
              distance: '12 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m mixed',
              duration: '60 min',
              distance: '2000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '30 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 30km',
              duration: '75 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 6km',
              duration: '40 min',
              distance: '6 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Ironman Prep I',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2500m aerobic',
              duration: '65 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 90km',
              duration: '225 min',
              distance: '90 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 16km',
              duration: '100 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '20×100m',
              duration: '60 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 80km + 8km run',
              duration: '215 min',
              distance: '80 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Ironman Prep II',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3000m continuous',
              duration: '75 min',
              distance: '3000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '120km long ride',
              duration: '300 min',
              distance: '120 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 20km',
              duration: '130 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m race pace',
              duration: '60 min',
              distance: '2000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Taper Begins',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2000m race effort',
              duration: '55 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 80km',
              duration: '200 min',
              distance: '80 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 14km',
              duration: '90 min',
              distance: '14 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '30 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '25 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 30km spin',
              duration: '70 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 6km shakeout',
              duration: '35 min',
              distance: '6 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ════════════════════════════════════════════════════
    //  INTERMEDIATE
    // ════════════════════════════════════════════════════

    // ── Intermediate · Sprint ─────────────────────────────
    'intermediate_sprint': TrainingPlan(
      level: 'Intermediate',
      goal: 'Sprint',
      description:
          '8-week performance plan for Sprint Triathlon '
          '(750m swim · 20km bike · 5km run). '
          'Focuses on speed and race-day execution.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Speed Foundation',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '10×50m sprints',
              duration: '30 min',
              distance: '700m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 5km',
              duration: '30 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Interval ride 4×5min hard',
              duration: '45 min',
              distance: '18 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '750m time trial',
              duration: '25 min',
              distance: '750m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Speed Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '16×50m with 15s rest',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '4×1km race-pace intervals',
              duration: '40 min',
              distance: '6 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Threshold 25km',
              duration: '50 min',
              distance: '25 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '800m time trial',
              duration: '28 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 15km + 3km run',
              duration: '55 min',
              distance: '15 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Race Sharpness',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '20×50m with 10s rest',
              duration: '40 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hard 20km race effort',
              duration: '42 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '5km time trial',
              duration: '25 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1000m mixed pace',
              duration: '35 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '22 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 15km',
              duration: '35 min',
              distance: '15 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 4km',
              duration: '28 min',
              distance: '4 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Simulation',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Race-pace 750m',
              duration: '22 min',
              distance: '750m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'All-out 20km',
              duration: '38 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'All-out 5km',
              duration: '23 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '12×100m with 15s rest',
              duration: '48 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 20km + 5km run',
              duration: '60 min',
              distance: '20 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Speed Maintenance',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1000m at race pace',
              duration: '32 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Intervals 6×3min max',
              duration: '48 min',
              distance: '22 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '6×400m sprints',
              duration: '38 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '800m race simulation',
              duration: '25 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Final Sharpening',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '750m easy + 10×25m fast',
              duration: '30 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race effort 20km',
              duration: '38 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 5km',
              duration: '22 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 15km + 3km run',
              duration: '50 min',
              distance: '15 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 400m',
              duration: '15 min',
              distance: '400m',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 300m',
              duration: '12 min',
              distance: '300m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Shakeout 2km',
              duration: '12 min',
              distance: '2 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin 10km',
              duration: '22 min',
              distance: '10 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Intermediate · Olympic ────────────────────────────
    'intermediate_olympic': TrainingPlan(
      level: 'Intermediate',
      goal: 'Olympic',
      description:
          '8-week plan for the Olympic distance '
          '(1500m swim · 40km bike · 10km run). '
          'Assumes you can already complete a Sprint Triathlon.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Base Assessment',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Technique + 800m continuous',
              duration: '35 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady aerobic ride',
              duration: '50 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy aerobic run',
              duration: '40 min',
              distance: '6 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '10×100m intervals',
              duration: '45 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick: 30km bike + 3km run',
              duration: '65 min',
              distance: '30 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Aerobic Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1000m continuous',
              duration: '40 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Tempo intervals 4×1km',
              duration: '45 min',
              distance: '7 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hilly ride',
              duration: '60 min',
              distance: '25 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '12×100m intervals',
              duration: '50 min',
              distance: '1200m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Endurance Focus',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1200m continuous',
              duration: '45 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long ride',
              duration: '75 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long easy run',
              duration: '55 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Race simulation 1500m',
              duration: '50 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy recovery run',
              duration: '30 min',
              distance: '4 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '25 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy flat spin',
              duration: '40 min',
              distance: '15 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 4km',
              duration: '30 min',
              distance: '4 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Speed Work',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '16×100m with 20s rest',
              duration: '55 min',
              distance: '1600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace intervals',
              duration: '65 min',
              distance: '35 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '6×800m intervals',
              duration: '50 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race pace',
              duration: '50 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 35km + 5km run',
              duration: '80 min',
              distance: '35 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Peak Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2000m mixed paces',
              duration: '60 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long ride',
              duration: '90 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long run',
              duration: '65 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race simulation',
              duration: '50 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Race Sharpening',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Descending 400-300-200-100m',
              duration: '50 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 40km',
              duration: '85 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 10km',
              duration: '55 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '30 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '20 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin',
              duration: '25 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 3km shakeout',
              duration: '20 min',
              distance: '3 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Intermediate · Half Ironman ───────────────────────
    'intermediate_half_ironman': TrainingPlan(
      level: 'Intermediate',
      goal: 'Half Ironman',
      description:
          '8-week training block for the Half Ironman '
          '(1.9km swim · 90km bike · 21.1km run). '
          'For athletes with Olympic distance experience.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Base Assessment',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1200m aerobic',
              duration: '45 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Steady 40km',
              duration: '100 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 8km',
              duration: '55 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '14×100m',
              duration: '50 min',
              distance: '1400m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 35km + 5km run',
              duration: '95 min',
              distance: '35 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Aerobic Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1500m continuous',
              duration: '50 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Tempo 10km',
              duration: '60 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hilly 50km',
              duration: '125 min',
              distance: '50 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '16×100m with 20s rest',
              duration: '55 min',
              distance: '1600m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Endurance Block',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race simulation',
              duration: '60 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 70km',
              duration: '175 min',
              distance: '70 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 14km',
              duration: '88 min',
              distance: '14 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m mixed sets',
              duration: '60 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy recovery 5km',
              duration: '35 min',
              distance: '5 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '30 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 30km',
              duration: '75 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 6km',
              duration: '40 min',
              distance: '6 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Specificity',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2×1000m race pace',
              duration: '65 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 80km',
              duration: '200 min',
              distance: '80 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 16km',
              duration: '100 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race effort',
              duration: '58 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 60km + 8km run',
              duration: '170 min',
              distance: '60 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Peak Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2500m mixed',
              duration: '70 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 90km',
              duration: '225 min',
              distance: '90 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 20km',
              duration: '125 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race pace',
              duration: '48 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Race Sharpening',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race simulation',
              duration: '58 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 70km',
              duration: '175 min',
              distance: '70 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 18km',
              duration: '112 min',
              distance: '18 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '28 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m',
              duration: '20 min',
              distance: '600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 20km spin',
              duration: '48 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 5km shakeout',
              duration: '30 min',
              distance: '5 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Intermediate · Ironman ────────────────────────────
    'intermediate_ironman': TrainingPlan(
      level: 'Intermediate',
      goal: 'Ironman',
      description:
          '8-week block for the full Ironman '
          '(3.8km swim · 180km bike · 42.2km run). '
          'Requires Half Ironman experience and a solid aerobic base.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Volume Base',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2000m aerobic',
              duration: '58 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 80km',
              duration: '200 min',
              distance: '80 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 14km',
              duration: '88 min',
              distance: '14 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '18×100m',
              duration: '58 min',
              distance: '1800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 70km + 8km run',
              duration: '195 min',
              distance: '70 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Endurance Build',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2500m mixed sets',
              duration: '68 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hilly 100km',
              duration: '250 min',
              distance: '100 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 20km',
              duration: '125 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Technique + 1500m',
              duration: '50 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Peak Endurance',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3000m mixed paces',
              duration: '78 min',
              distance: '3000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '140km long ride',
              duration: '350 min',
              distance: '140 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '26km long run',
              duration: '160 min',
              distance: '26 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m race pace',
              duration: '58 min',
              distance: '2000m',
            ),
            _fullRest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '35 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 50km',
              duration: '125 min',
              distance: '50 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 10km',
              duration: '65 min',
              distance: '10 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Specificity',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3×1000m race pace',
              duration: '80 min',
              distance: '3000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 120km',
              duration: '300 min',
              distance: '120 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 24km',
              duration: '148 min',
              distance: '24 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m + drills',
              duration: '58 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 100km + 10km run',
              duration: '270 min',
              distance: '100 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Final Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3800m race simulation',
              duration: '85 min',
              distance: '3800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '160km ride',
              duration: '400 min',
              distance: '160 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '30km long run',
              duration: '185 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m easy',
              duration: '55 min',
              distance: '2000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Taper Begins',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2500m race effort',
              duration: '68 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Sharp 90km',
              duration: '225 min',
              distance: '90 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '16km race pace',
              duration: '100 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '30 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '28 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 40km spin',
              duration: '90 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 8km shakeout',
              duration: '48 min',
              distance: '8 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ════════════════════════════════════════════════════
    //  ADVANCED
    // ════════════════════════════════════════════════════

    // ── Advanced · Sprint ─────────────────────────────────
    'advanced_sprint': TrainingPlan(
      level: 'Advanced',
      goal: 'Sprint',
      description:
          '8-week peak-performance plan for Sprint Triathlon '
          '(750m swim · 20km bike · 5km run). '
          'Maximum speed, race efficiency, and podium readiness.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Speed Assessment',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '750m all-out time trial',
              duration: '20 min',
              distance: '750m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '5km time trial',
              duration: '22 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '20km TT effort',
              duration: '36 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '20×50m with 10s rest',
              duration: '40 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'VO2max Block',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '30×50m sprints',
              duration: '55 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '8×400m VO2 intervals',
              duration: '45 min',
              distance: '6 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '8×3min max effort',
              duration: '55 min',
              distance: '25 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1000m descending pace',
              duration: '32 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 20km + 3km run',
              duration: '55 min',
              distance: '20 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Speed Endurance',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '5×200m hard with 30s rest',
              duration: '45 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace + 5km TT',
              duration: '48 min',
              distance: '22 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '3×1600m intervals',
              duration: '45 min',
              distance: '7 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1200m race simulation',
              duration: '36 min',
              distance: '1200m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '25 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 15km',
              duration: '32 min',
              distance: '15 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 4km',
              duration: '25 min',
              distance: '4 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Specificity',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Race-pace 750m + 4×100m fast',
              duration: '38 min',
              distance: '1150m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Full race simulation 20km',
              duration: '34 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 5km + strides',
              duration: '24 min',
              distance: '5.5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m mixed sprints',
              duration: '44 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 20km + 5km race pace',
              duration: '58 min',
              distance: '20 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Speed Maintenance',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1000m hard + 10×25m sprint',
              duration: '40 min',
              distance: '1250m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '5×4min VO2 intervals',
              duration: '50 min',
              distance: '22 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '10×200m sprints',
              duration: '38 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '800m race pace',
              duration: '24 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Race Sharpening',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '750m race effort + 250m easy',
              duration: '30 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 20km',
              duration: '34 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 5km',
              duration: '20 min',
              distance: '5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 15km + 3km run',
              duration: '46 min',
              distance: '15 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 400m',
              duration: '14 min',
              distance: '400m',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 300m + 4×25m strides',
              duration: '15 min',
              distance: '400m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Shakeout 2km + strides',
              duration: '14 min',
              distance: '2.5 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin 8km',
              duration: '18 min',
              distance: '8 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Advanced · Olympic ────────────────────────────────
    'advanced_olympic': TrainingPlan(
      level: 'Advanced',
      goal: 'Olympic',
      description:
          '8-week high-performance plan for the Olympic distance '
          '(1500m swim · 40km bike · 10km run). '
          'Targets sub-2hr finish and podium performance.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Baseline Testing',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1500m time trial',
              duration: '48 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '40km TT effort',
              duration: '72 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '10km time trial',
              duration: '48 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '20×100m with 15s rest',
              duration: '60 min',
              distance: '2000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Threshold Work',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2000m threshold effort',
              duration: '58 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '5×1km at threshold',
              duration: '52 min',
              distance: '8 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '3×12min threshold',
              duration: '65 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '24×100m with 15s rest',
              duration: '70 min',
              distance: '2400m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 40km + 5km run',
              duration: '100 min',
              distance: '40 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'VO2 Block',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '10×200m VO2 effort',
              duration: '65 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '6×5min VO2 + 40km ride',
              duration: '90 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '8×800m VO2 intervals',
              duration: '60 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race simulation',
              duration: '46 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '32 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 25km',
              duration: '58 min',
              distance: '25 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 6km',
              duration: '38 min',
              distance: '6 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Specificity',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race effort + 500m cool',
              duration: '58 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 40km',
              duration: '72 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 10km',
              duration: '46 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m broken at race pace',
              duration: '58 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 40km + 8km run',
              duration: '105 min',
              distance: '40 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Peak Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3000m mixed paces',
              duration: '78 min',
              distance: '3000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 55km',
              duration: '100 min',
              distance: '55 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 14km',
              duration: '68 min',
              distance: '14 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race simulation',
              duration: '46 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Race Sharpening',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1500m race + 4×100m fast finish',
              duration: '55 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 40km',
              duration: '72 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 10km',
              duration: '46 min',
              distance: '10 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '25 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 600m + 4×25m fast',
              duration: '22 min',
              distance: '700m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy spin 12km',
              duration: '26 min',
              distance: '12 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 3km + strides',
              duration: '22 min',
              distance: '3.5 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Advanced · Half Ironman ───────────────────────────
    'advanced_half_ironman': TrainingPlan(
      level: 'Advanced',
      goal: 'Half Ironman',
      description:
          '8-week peak block for the Half Ironman '
          '(1.9km swim · 90km bike · 21.1km run). '
          'Targets sub-4hr performance for experienced athletes.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Volume Base',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2500m aerobic',
              duration: '68 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 80km',
              duration: '200 min',
              distance: '80 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 14km',
              duration: '88 min',
              distance: '14 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '20×100m with 15s rest',
              duration: '60 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 60km + 8km run',
              duration: '170 min',
              distance: '60 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Threshold Block',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3000m threshold effort',
              duration: '78 min',
              distance: '3000m',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '3×3km threshold',
              duration: '65 min',
              distance: '12 km',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '4×15min threshold ride',
              duration: '110 min',
              distance: '50 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m race pace',
              duration: '58 min',
              distance: '2000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Peak Endurance',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3500m mixed sets',
              duration: '88 min',
              distance: '3500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long 100km',
              duration: '250 min',
              distance: '100 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Long 22km',
              duration: '138 min',
              distance: '22 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race simulation',
              duration: '56 min',
              distance: '1900m',
            ),
            _fullRest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1200m',
              duration: '38 min',
              distance: '1200m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 40km',
              duration: '100 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 8km',
              duration: '50 min',
              distance: '8 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Specificity',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2×1000m + 4×200m fast',
              duration: '75 min',
              distance: '2800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 90km',
              duration: '225 min',
              distance: '90 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Race-pace 21km',
              duration: '128 min',
              distance: '21 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race effort',
              duration: '56 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 70km + 10km run',
              duration: '195 min',
              distance: '70 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Final Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3800m race simulation',
              duration: '85 min',
              distance: '3800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '110km ride',
              duration: '275 min',
              distance: '110 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '24km long run',
              duration: '148 min',
              distance: '24 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '1500m easy',
              duration: '46 min',
              distance: '1500m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Taper Begins',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '1900m race effort',
              duration: '56 min',
              distance: '1900m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Sharp 70km',
              duration: '175 min',
              distance: '70 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '16km race pace',
              duration: '96 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '26 min',
              distance: '800m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 800m',
              duration: '24 min',
              distance: '800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 25km spin',
              duration: '58 min',
              distance: '25 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 6km shakeout',
              duration: '36 min',
              distance: '6 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),

    // ── Advanced · Ironman ────────────────────────────────
    'advanced_ironman': TrainingPlan(
      level: 'Advanced',
      goal: 'Ironman',
      description:
          '8-week peak block for the full Ironman '
          '(3.8km swim · 180km bike · 42.2km run). '
          'Requires a strong aerobic base and prior long-course experience.',
      weeks: [
        TrainingWeek(
          weekNumber: 1,
          theme: 'Base Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3000m aerobic',
              duration: '70 min',
              distance: '3000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Long aerobic ride',
              duration: '180 min',
              distance: '80 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy long run',
              duration: '90 min',
              distance: '16 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '20×100m with 15s rest',
              duration: '60 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 100km + 8km run',
              duration: '220 min',
              distance: '100 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 2,
          theme: 'Endurance Block',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3800m continuous',
              duration: '85 min',
              distance: '3800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Hilly 120km',
              duration: '240 min',
              distance: '120 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '28km long run',
              duration: '150 min',
              distance: '28 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Technique + 2000m',
              duration: '60 min',
              distance: '2000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 3,
          theme: 'Peak Endurance',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '4000m mixed sets',
              duration: '90 min',
              distance: '4000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '160km long ride',
              duration: '360 min',
              distance: '160 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '32km run',
              duration: '175 min',
              distance: '32 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2500m race pace',
              duration: '65 min',
              distance: '2500m',
            ),
            _fullRest,
          ],
        ),
        TrainingWeek(
          weekNumber: 4,
          theme: 'Recovery',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1500m',
              duration: '40 min',
              distance: '1500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 60km',
              duration: '120 min',
              distance: '60 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 15km',
              duration: '80 min',
              distance: '15 km',
            ),
            _fullRest,
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 5,
          theme: 'Race Specificity',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3×1200m race pace',
              duration: '80 min',
              distance: '3600m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Race-pace 140km',
              duration: '300 min',
              distance: '140 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Ironman-pace 30km',
              duration: '165 min',
              distance: '30 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m + drills',
              duration: '55 min',
              distance: '2000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Brick 120km + 10km run',
              duration: '280 min',
              distance: '120 km',
            ),
          ],
        ),
        TrainingWeek(
          weekNumber: 6,
          theme: 'Final Volume',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '3800m race simulation',
              duration: '85 min',
              distance: '3800m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: '180km ride',
              duration: '390 min',
              distance: '180 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '35km long run',
              duration: '190 min',
              distance: '35 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: '2000m easy',
              duration: '55 min',
              distance: '2000m',
            ),
            _fullRest,
          ],
        ),
        TrainingWeek(
          weekNumber: 7,
          theme: 'Taper Begins',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: '2500m at race effort',
              duration: '60 min',
              distance: '2500m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Sharp 100km',
              duration: '210 min',
              distance: '100 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: '20km race pace',
              duration: '110 min',
              distance: '20 km',
            ),
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '30 min',
              distance: '1000m',
            ),
            _rest,
          ],
        ),
        TrainingWeek(
          weekNumber: 8,
          theme: 'Race Week',
          sessions: [
            TrainingSession(
              discipline: 'Swim',
              description: 'Easy 1000m',
              duration: '25 min',
              distance: '1000m',
            ),
            TrainingSession(
              discipline: 'Bike',
              description: 'Easy 40km spin',
              duration: '80 min',
              distance: '40 km',
            ),
            TrainingSession(
              discipline: 'Run',
              description: 'Easy 8km shakeout',
              duration: '45 min',
              distance: '8 km',
            ),
            _fullRest,
            _raceDay,
          ],
        ),
      ],
    ),
  };
}
