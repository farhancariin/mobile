import 'package:mobile_framwork/main.dart';
import 'package:mobile_framwork/pages/Login/login.dart';
import 'package:mobile_framwork/pages/absence/absences.dart';
import 'package:mobile_framwork/pages/absence/dinas.dart';
import 'package:mobile_framwork/pages/audit/audit.dart';
import 'package:mobile_framwork/pages/company_info/company_info.dart';
import 'package:mobile_framwork/pages/dashboard/dashboard.dart';
import 'package:mobile_framwork/pages/employee/employee.dart';
import 'package:mobile_framwork/pages/event/event.dart';
import 'package:mobile_framwork/pages/field_patrol/field_patrol.dart';
import 'package:mobile_framwork/pages/incident/incident.dart';
import 'package:mobile_framwork/pages/infomation_project/project_information.dart';
import 'package:mobile_framwork/pages/montly_report/monthly_report.dart';
import 'package:mobile_framwork/pages/report/report.dart';
import 'package:mobile_framwork/pages/project_visit/project_visit.dart';
import 'package:mobile_framwork/pages/slip/slip.dart';

final main = {
  '/' : (context) => MainApp(),
  '/login': (context) => LoginScreen(),
  '/dashboard': (context) => DashboardScreen(),
  '/company-info': (context) => CompanyInfoScreen(),
  '/project-information': (context) => ProjectInformationScreen(),
  '/employee': (context) => EmployeeScreen(),
  '/absence': (context) => AbsenceScreen(),
  '/project-visit': (context) => ProjectVisitScreen(),
  '/audit': (context) => AuditScreen(),
  '/field-patrol': (context) => FieldPatrolScreen(),
  '/report': (context) => ReportScreen(),
  '/monthly-report': (context) => MonthlyReportScreen(),
  '/slip': (context) => SlipScreen(),
  '/event': (context) => EventScreen(),
  '/incident': (context) => IncidentScreen(),
  '/dinas': (context) => DinasForm(),
};