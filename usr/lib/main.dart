import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const NanchongAirQualityApp());
}

class NanchongAirQualityApp extends StatelessWidget {
  const NanchongAirQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '南充市大气质量实时监测预警系统',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1890FF),
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  // 模拟数据：南充市各区县监测点
  final List<Map<String, dynamic>> stations = [
    {'name': '顺庆区监测站', 'aqi': 42, 'status': '优', 'pm25': 28, 'pm10': 45},
    {'name': '高坪区监测站', 'aqi': 56, 'status': '良', 'pm25': 35, 'pm10': 60},
    {'name': '嘉陵区监测站', 'aqi': 38, 'status': '优', 'pm25': 22, 'pm10': 40},
    {'name': '阆中市监测站', 'aqi': 35, 'status': '优', 'pm25': 20, 'pm10': 38},
    {'name': '南部县监测站', 'aqi': 65, 'status': '良', 'pm25': 42, 'pm10': 72},
    {'name': '西充县监测站', 'aqi': 40, 'status': '优', 'pm25': 25, 'pm10': 42},
    {'name': '仪陇县监测站', 'aqi': 48, 'status': '优', 'pm25': 30, 'pm10': 50},
    {'name': '营山县监测站', 'aqi': 52, 'status': '良', 'pm25': 32, 'pm10': 55},
    {'name': '蓬安县监测站', 'aqi': 45, 'status': '优', 'pm25': 28, 'pm10': 48},
  ];

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

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF52C41A); // 优 - Green
    if (aqi <= 100) return const Color(0xFFFAAD14); // 良 - Yellow
    if (aqi <= 150) return const Color(0xFFFA8C16); // 轻度 - Orange
    if (aqi <= 200) return const Color(0xFFFF4D4F); // 中度 - Red
    if (aqi <= 300) return const Color(0xFF722ED1); // 重度 - Purple
    return const Color(0xFF820014); // 严重 - Maroon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '南充市大气质量实时监测预警系统',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1890FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('暂无新的预警信息')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                // 模拟刷新数据
                stations.shuffle();
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '实时概览'),
            Tab(text: '监测站点'),
            Tab(text: '数据分析'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildStationsTab(),
          _buildAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    // 计算全市平均AQI
    int avgAqi = (stations.map((e) => e['aqi'] as int).reduce((a, b) => a + b) / stations.length).round();
    Color statusColor = _getAQIColor(avgAqi);
    String statusText = avgAqi <= 50 ? "优" : (avgAqi <= 100 ? "良" : "轻度污染");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部大卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor.withOpacity(0.8), statusColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '南充市实时空气质量指数 (AQI)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  '$avgAqi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHeaderMetric('PM2.5', '32', 'μg/m³'),
                    _buildHeaderMetric('PM10', '58', 'μg/m³'),
                    _buildHeaderMetric('O3', '45', 'μg/m³'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            '主要污染物实时监测',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildPollutantCard('SO2', '二氧化硫', '8', 'μg/m³', Colors.blue),
              _buildPollutantCard('NO2', '二氧化氮', '24', 'μg/m³', Colors.orange),
              _buildPollutantCard('CO', '一氧化碳', '0.6', 'mg/m³', Colors.green),
              _buildPollutantCard('TVOC', '挥发性有机物', '0.12', 'mg/m³', Colors.purple),
            ],
          ),
          
          const SizedBox(height: 24),
          const Text(
            '预警信息',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 36),
              title: const Text('未来24小时空气质量预报'),
              subtitle: const Text('预计明日南充市空气质量为良，首要污染物为PM2.5，建议敏感人群减少户外活动。'),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMetric(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPollutantCard(String name, String fullName, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              Icon(Icons.analytics_outlined, color: color.withOpacity(0.5), size: 20),
            ],
          ),
          Text(fullName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        final int aqi = station['aqi'];
        final Color color = _getAQIColor(aqi);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$aqi',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'AQI',
                        style: TextStyle(color: color, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniTag('PM2.5: ${station['pm25']}', Colors.grey),
                          const SizedBox(width: 8),
                          _buildMiniTag('PM10: ${station['pm10']}', Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    station['status'],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '24小时AQI变化趋势',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: TrendChartPainter(),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '污染物占比分析',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProgressRow('PM2.5', 0.35, Colors.blue),
                const SizedBox(height: 12),
                _buildProgressRow('PM10', 0.45, Colors.orange),
                const SizedBox(height: 12),
                _buildProgressRow('O3', 0.15, Colors.green),
                const SizedBox(height: 12),
                _buildProgressRow('NO2', 0.05, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 10,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text('${(value * 100).toInt()}%', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// 简单的自定义画笔来模拟图表，避免引入外部依赖
class TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1890FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random(42); // 固定种子以保持一致性
    
    double stepX = size.width / 23;
    
    path.moveTo(0, size.height * 0.7);
    
    for (int i = 1; i <= 23; i++) {
      double x = i * stepX;
      // 模拟数据波动
      double y = size.height * 0.5 + (random.nextDouble() - 0.5) * size.height * 0.6;
      y = y.clamp(10.0, size.height - 10.0);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    // 绘制填充区域
    final fillPaint = Paint()
      ..color = const Color(0xFF1890FF).withOpacity(0.1)
      ..style = PaintingStyle.fill;
      
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, fillPaint);
    
    // 绘制基准线
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;
      
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), linePaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
