import 'package:crypto_coin/configs/app_settings.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:crypto_coin/repositories/coin_repository.dart';
import 'package:crypto_coin/utils/priceFormat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraphicHistory extends StatefulWidget {
  final Coin coin;

  GraphicHistory({Key? key, required this.coin}) : super(key: key);

  @override
  _GraphicHistoryState createState() => _GraphicHistoryState();
}

enum Period { hour, day, week, month, year, total }

class _GraphicHistoryState extends State<GraphicHistory> {
  List<Color> colors = [
    Colors.white,
  ];
  Period period = Period.hour;
  List<Map<String, dynamic>> history = [];
  List completedData = [];
  List<FlSpot> graphicData = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;

  ValueNotifier<bool> loaded = ValueNotifier(false);
  late CoinRepository coinRepository;

  late Map<String, String> loc;
  late PriceFormat priceFormat;

  readNumberFormat() {
    loc = Provider.of<AppSettings>(context).locale;
    priceFormat =
        PriceFormat(locale: loc['locale'] ?? '', name: loc['name'] ?? '');
  }

  Future<void> setData() async {
    loaded.value = false;
    graphicData = [];

    if (history.isEmpty)
      history = await coinRepository.getHistoryCoin(widget.coin);

    completedData = history[period.index]['prices'];
    completedData = completedData.reversed.map((item) {
      double price = double.parse(item[0]);
      int time = int.parse(item[1].toString() + '000');

      return [price, DateTime.fromMillisecondsSinceEpoch(time)];
    }).toList();

    maxX = completedData.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var item in completedData) {
      maxY = item[0] > maxY ? item[0] : maxY;
      minY = item[0] < minY ? item[0] : minY;
    }

    for (int i = 0; i < completedData.length; i++) {
      graphicData.add(FlSpot(
        i.toDouble(),
        completedData[i][0],
      ));
    }

    loaded.value = true;
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: graphicData,
          isCurved: true,
          colors: colors,
          barWidth: 2,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors: colors.map((color) => color.withOpacity(0.15)).toList(),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black,
            getTooltipItems: (data) {
              return data.map((item) {
                final date = getDate(item.spotIndex);
                return LineTooltipItem(
                  priceFormat.format(item.y),
                  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\n $date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(.5),
                      ),
                    )
                  ],
                );
              }).toList();
            }),
      ),
    );
  }

  String getDate(int index) {
    DateTime date = completedData[index][1];

    if (period != Period.year && period != Period.total)
      return DateFormat('dd/MM - hh:mm').format(date);
    else
      return DateFormat('dd/MM/y').format(date);
  }

  Widget chartButton(Period p, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () => setState(() => period = p),
        child: Text(label),
        style: (period != p)
            ? ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey))
            : ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.indigo[50]),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    coinRepository = context.read<CoinRepository>();

    readNumberFormat();
    setData();

    return Container(
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  chartButton(Period.hour, '1H'),
                  chartButton(Period.day, '24H'),
                  chartButton(Period.week, '7D'),
                  chartButton(Period.month, 'Month'),
                  chartButton(Period.year, 'Year'),
                  chartButton(Period.total, 'Total'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ValueListenableBuilder(
                valueListenable: loaded,
                builder: (contex, bool isLoaded, _) {
                  return (isLoaded)
                      ? LineChart(getChartData())
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
