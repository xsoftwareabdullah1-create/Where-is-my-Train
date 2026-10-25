import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MethodChannel _cellChannel = MethodChannel('com.whereismytrain/cell');

class CellTowerStatusPage extends StatefulWidget {
  const CellTowerStatusPage({super.key});

  @override
  State<CellTowerStatusPage> createState() => _CellTowerStatusPageState();
}

class _CellTowerStatusPageState extends State<CellTowerStatusPage> {
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _snapshot;

  Future<void> _readCellInfo() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _cellChannel.invokeMapMethod<String, dynamic>(
        'getCellTowerSnapshot',
      );
      if (!mounted) return;
      setState(() => _snapshot = result);
    } on PlatformException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message ?? 'Cell information is unavailable.');
    } on MissingPluginException {
      if (!mounted) return;
      setState(() => _error = 'Cell information is not available on this build.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not read cell information. Check permissions and try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cells = (_snapshot?['cells'] as List<dynamic>?) ?? const [];
    final registered = cells.where((item) =>
        item is Map && item['registered'] == true).toList();
    final primary = registered.isNotEmpty ? registered.first : (cells.isNotEmpty ? cells.first : null);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101B2D),
        foregroundColor: Colors.white,
        title: const Text('Cell Tower Tracking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF172C49), Color(0xFF112039)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF29456A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.cell_tower, color: Color(0xFF65B8FF), size: 32),
                const SizedBox(height: 12),
                const Text('Cellular signal reader',
                    style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Reads cell identifiers and signal strength from this phone. It does not use internet speed as a location signal.',
                  style: TextStyle(color: Colors.blueGrey.shade100, height: 1.45),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _readCellInfo,
                    icon: _loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.radar),
                    label: Text(_loading ? 'Reading signal…' : 'Read cell tower data'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2684FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            _InfoCard(
              icon: Icons.info_outline,
              title: 'Cell data unavailable',
              body: _error!,
              color: const Color(0xFFFFC857),
            ),
          if (_snapshot != null) ...[
            _InfoCard(
              icon: Icons.network_cell,
              title: 'Detected cell records',
              body: '${cells.length} cell record(s) returned by Android. '
                  'Registered cell: ${registered.isEmpty ? 'not reported' : 'available'}.',
              color: const Color(0xFF65B8FF),
            ),
            if (primary is Map) ...[
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.cell_tower,
                title: 'Primary cell details',
                body: 'Network type: ${primary['type'] ?? 'Unknown'}\n'
                    'Cell ID: ${primary['cellId'] ?? 'Not reported'}\n'
                    'Area code: ${primary['areaCode'] ?? 'Not reported'}\n'
                    'Signal: ${primary['signalDbm'] ?? 'Not reported'} dBm\n'
                    'Registered: ${primary['registered'] == true ? 'Yes' : 'No'}',
                color: const Color(0xFF65D6AD),
              ),
            ],
          ],
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.route,
            title: 'Train location estimate',
            body: 'Not calculated yet. A cell ID alone does not include tower coordinates. This repository still needs an offline/online cell-tower coordinate dataset and railway route matching before it can honestly show a train location or High / Medium / Low confidence.',
            color: const Color(0xFFFFC857),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.offline_pin,
            title: 'Offline running status',
            body: 'The current project is a UI clone and does not yet contain an offline railway timetable database or a live-status provider. Until those are integrated, this screen will not invent an On time / Late result. A future offline view can show saved status with its last-updated time, plus schedule-based estimates clearly marked as estimates.',
            color: const Color(0xFFB8A1FF),
          ),
          if (_snapshot?['timestamp'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Cell scan time: ${DateTime.fromMillisecondsSinceEpoch(_snapshot!['timestamp'] as int).toLocal()}',
              style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121E30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF24354C)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 7),
                Text(body, style: TextStyle(color: Colors.blueGrey.shade100, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
