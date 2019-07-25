import 'package:flutter/material.dart';

class FieldPatrolScreen extends StatefulWidget {
  @override
  final String title = "Patroli Lapangan";
  _FieldPatrolScreenState createState() => _FieldPatrolScreenState();
}

class _FieldPatrolScreenState extends State<FieldPatrolScreen> {
  List<Patrols> users;
  List<Patrols> selectedUsers;
  bool sort;

  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    users = Patrols.getUsers();
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.projectName.compareTo(b.projectName));
      } else {
        users.sort((a, b) => b.projectName.compareTo(a.projectName));
      }
    }
  }

  onSelectedRow(bool selected, Patrols user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Patrols> temp = [];
        temp.addAll(selectedUsers);
        for (Patrols user in temp) {
          users.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
//        sortAscending: sort,
//        sortColumnIndex: 0,
        columns: [
          DataColumn(
              label: Text("No"),
              numeric: false
          ),
          DataColumn(
            label: Text("Nama Project"),
          ),
          DataColumn(
            label: Text("Jumlah Karyawan"),
            numeric: false,
          ),

        ],
        rows: users
            .map(
              (item) => DataRow(
              cells: [
                DataCell(
                    Text(item.index.toString())
                ),DataCell(
                    Text(item.projectName.toString())
                ),
                DataCell(
                  Text(item.data.toString()),
                ),
              ]),
        )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: dataBody(),
          ),
        ],
      ),
    );
  }
}


class Patrols {
  String projectName;
  String data;
  int index;

  Patrols({this.projectName, this.data, this.index});

  static List<Patrols> getUsers() {
    return <Patrols>[
      Patrols(projectName: "Jakarta", data: "17/20", index: 1),
      Patrols(projectName: "Bandung", data: "17/20", index: 2),
      Patrols(projectName: "Bekasi", data: "17/20", index: 3),
    ];
  }
}
