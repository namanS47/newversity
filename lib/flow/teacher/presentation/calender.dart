import 'package:flutter/material.dart';
import 'package:newversity/themes/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCalendar(
          view: CalendarView.month,
          monthViewSettings: const MonthViewSettings(showAgenda: true, agendaViewHeight: -1, agendaItemHeight: 10),
          cellBorderColor: Colors.transparent,
          todayHighlightColor: AppColors.strongCyan,
          headerHeight: 80,
          selectionDecoration: BoxDecoration(

          ),
          headerStyle: const CalendarHeaderStyle(
              backgroundColor: AppColors.cyanBlue
          ),
          viewHeaderStyle: const ViewHeaderStyle(

          ),
          monthCellBuilder: (BuildContext buildContext, MonthCellDetails details) {
            return Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration( color: Colors.red,
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: Text(
                details.date.day.toString(),
                style: TextStyle(color: Colors.yellow),
              ),
            );
          },
        ),
      ),
    );
  }
}
