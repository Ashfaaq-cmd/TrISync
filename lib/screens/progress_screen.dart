import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workouts = context.watch<WorkoutProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Progress',
          style: TextStyle(
            color: Color(0xFF023E8A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0077B6),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF0077B6),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'By Sport'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(workouts: workouts),
          _BySportTab(workouts: workouts),
          _HistoryTab(workouts: workouts),
        ],
      ),
    );
  }
}

// Overview tab
class _OverviewTab extends StatelessWidget {
  final WorkoutProvider workouts;
  const _OverviewTab({required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No data yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Log your first workout to see your progress.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Build bar chart data for the last 7 days
    final now = DateTime.now();
    final barGroups = <BarChartGroupData>[];
    final dayLabels = <String>[];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final count = workouts.workouts
          .where(
            (w) =>
                w.date.year == day.year &&
                w.date.month == day.month &&
                w.date.day == day.day,
          )
          .length;
      barGroups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: const Color(0xFF0077B6),
              width: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      dayLabels.add(days[day.weekday - 1]);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Total stats
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Sessions',
                value: '${workouts.totalWorkouts}',
                icon: Icons.fitness_center,
                color: const Color(0xFF0077B6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'This Week',
                value: '${workouts.weeklyWorkouts.length}',
                icon: Icons.calendar_today,
                color: const Color(0xFF48CAE4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Swim km',
                value: workouts
                    .totalDistanceForDiscipline(Discipline.swim)
                    .toStringAsFixed(1),
                icon: Icons.pool,
                color: const Color(0xFF48CAE4),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Bike km',
                value: workouts
                    .totalDistanceForDiscipline(Discipline.bike)
                    .toStringAsFixed(1),
                icon: Icons.directions_bike,
                color: const Color(0xFF0096C7),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'Run km',
                value: workouts
                    .totalDistanceForDiscipline(Discipline.run)
                    .toStringAsFixed(1),
                icon: Icons.directions_run,
                color: const Color(0xFF023E8A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Bar chart: workouts per day (last 7 days)
        const Text(
          'Workouts — Last 7 Days',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023E8A),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
              ),
            ],
          ),
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text(
                      dayLabels[value.toInt()],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) =>
                        value == value.roundToDouble()
                        ? Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              maxY: 4,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Pie chart: discipline split
        const Text(
          'Discipline Split',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023E8A),
          ),
        ),
        const SizedBox(height: 14),
        _DisciplinePieChart(workouts: workouts),
      ],
    );
  }
}

// Discipline pie chart
class _DisciplinePieChart extends StatelessWidget {
  final WorkoutProvider workouts;
  const _DisciplinePieChart({required this.workouts});

  @override
  Widget build(BuildContext context) {
    final swim = workouts.workouts
        .where((w) => w.discipline == Discipline.swim)
        .length;
    final bike = workouts.workouts
        .where((w) => w.discipline == Discipline.bike)
        .length;
    final run = workouts.workouts
        .where((w) => w.discipline == Discipline.run)
        .length;
    final total = swim + bike + run;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  if (swim > 0)
                    PieChartSectionData(
                      value: swim.toDouble(),
                      color: const Color(0xFF48CAE4),
                      title: '${((swim / total) * 100).round()}%',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: 55,
                    ),
                  if (bike > 0)
                    PieChartSectionData(
                      value: bike.toDouble(),
                      color: const Color(0xFF0096C7),
                      title: '${((bike / total) * 100).round()}%',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: 55,
                    ),
                  if (run > 0)
                    PieChartSectionData(
                      value: run.toDouble(),
                      color: const Color(0xFF023E8A),
                      title: '${((run / total) * 100).round()}%',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: 55,
                    ),
                ],
                centerSpaceRadius: 28,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legend(const Color(0xFF48CAE4), Icons.pool, 'Swim ($swim)'),
              const SizedBox(height: 10),
              _legend(
                const Color(0xFF0096C7),
                Icons.directions_bike,
                'Bike ($bike)',
              ),
              const SizedBox(height: 10),
              _legend(
                const Color(0xFF023E8A),
                Icons.directions_run,
                'Run ($run)',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, IconData icon, String label) => Row(
    children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 13, color: Color(0xFF023E8A)),
      ),
    ],
  );
}

// By Sport tab
class _BySportTab extends StatelessWidget {
  final WorkoutProvider workouts;
  const _BySportTab({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: Discipline.values.map((d) {
        final sessions =
            workouts.workouts.where((w) => w.discipline == d).toList()
              ..sort((a, b) => b.date.compareTo(a.date));
        final totalDist = workouts.totalDistanceForDiscipline(d);
        final totalMins = workouts.totalMinutesForDiscipline(d);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(d.icon, color: const Color(0xFF0077B6), size: 26),
                  const SizedBox(width: 10),
                  Text(
                    d.label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023E8A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Sessions',
                      value: '${sessions.length}',
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      label: 'Distance',
                      value: '${totalDist.toStringAsFixed(1)} km',
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      label: 'Time',
                      value: '${(totalMins / 60).toStringAsFixed(1)} h',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0077B6),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

// History tab
class _HistoryTab extends StatelessWidget {
  final WorkoutProvider workouts;
  const _HistoryTab({required this.workouts});

  @override
  Widget build(BuildContext context) {
    final sorted = [...workouts.workouts]
      ..sort((a, b) => b.date.compareTo(a.date));

    if (sorted.isEmpty) {
      return const Center(
        child: Text(
          'No workouts logged yet.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sorted.length,
      itemBuilder: (context, i) {
        final w = sorted[i];
        return Dismissible(
          key: Key(w.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<WorkoutProvider>().deleteWorkout(w.id);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Workout deleted')));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0077B6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    w.discipline.icon,
                    color: const Color(0xFF0077B6),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w.discipline.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023E8A),
                        ),
                      ),
                      Text(
                        '${w.distanceDisplay} · ${w.durationMinutes} min · ${w.paceOrSpeed}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      if (w.notes.isNotEmpty)
                        Text(
                          w.notes,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  '${w.date.day}/${w.date.month}/${w.date.year}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Stat card widget
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
