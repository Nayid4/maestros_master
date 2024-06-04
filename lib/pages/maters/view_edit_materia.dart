import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/models/dias.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:uuid/uuid.dart';

class EditMateria extends StatefulWidget {
  final Materia materia;
  const EditMateria({Key? key, required this.materia}) : super(key: key);

  @override
  _EditMateriaState createState() => _EditMateriaState();
}

class _EditMateriaState extends State<EditMateria> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController horaFinController = TextEditingController();
  String selectedDay = 'Lunes';
  final List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];
  List<Dia> selectedDays = [];
  final MateriasController materiasController = Get.find();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.materia.nombre;
    selectedDays = List.from(widget.materia.dias);
  }

  @override
  Widget build(BuildContext context) {
    const Color miColor = Color.fromRGBO(0, 191, 99, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Materia", style: TextStyle(color: Colors.white)),
        backgroundColor: miColor,
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso a blanco
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: nombreController,
              labelText: "Nombre de la materia",
            ),
            const SizedBox(height: 20),
            _buildIconButtonAddDay(),
            const SizedBox(height: 20),
            _buildDaysList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 191, 99, 1), // Cambia el color del botón
          ),
          onPressed: () {
            _editMateria(
              widget.materia.idMateria,
              nombreController.text,
              selectedDays,
              widget.materia.estudiantes,
              materiasController,
              context,
            );
          },
          child: const Text("Guardar Cambios", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildIconButtonAddDay() {
    return IconButton(
      onPressed: () {
        _showAddDayDialog(context);
      },
      icon: const Icon(Icons.add_circle_outline),
    );
  }

  Widget _buildDaysList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Días de clase"),
        if (selectedDays.isNotEmpty)
          Column(
            children: selectedDays.map((day) {
              return Card(
                child: ListTile(
                  title: Text(day.nombreDia),
                  subtitle: Text(
                      'Inicio: ${_formatTimeOfDay(day.horaInicio)} - Fin: ${_formatTimeOfDay(day.horaFin)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDayDialog(context, day);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            selectedDays.remove(day);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  String _formatTimeOfDay(DateTime dateTime) {
    final TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  Widget _buildDropDownButton(void Function(String) onChanged) {
    return DropdownButton<String>(
      value: selectedDay,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTimePicker(
      {required BuildContext context,
      required TextEditingController controller,
      required String labelText,
      required Function(TimeOfDay) onTimeSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        ElevatedButton(
          onPressed: () {
            _showTimePicker(context, controller, onTimeSelected);
          },
          child: const Text("Seleccionar hora"),
        ),
        if (controller.text.isNotEmpty)
          Text("Hora seleccionada: ${controller.text}"),
      ],
    );
  }

  void _showTimePicker(BuildContext context, TextEditingController controller,
      Function(TimeOfDay) onTimeSelected) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        controller.text = value.format(context);
        onTimeSelected(value);
      }
    });
  }

  void _editMateria(
      String idMateria,
      String nombre,
      List<Dia> dias,
      List<Estudiante> estudiantes,
      MateriasController materiasController,
      BuildContext context) async {
    final Materia materiaEditada = Materia(
      idMateria: idMateria,
      nombre: nombre,
      idUsuario: widget.materia.idUsuario,
      dias: dias,
      estudiantes: estudiantes,
    );

    await materiasController.updateMateria(materiaEditada);
    Get.back(result: true);
  }

  void _showAddDayDialog(BuildContext context) {
    TextEditingController horaInicioController = TextEditingController();
    TextEditingController horaFinController = TextEditingController();
    TimeOfDay? selectedHoraInicio;
    TimeOfDay? selectedHoraFin;
    String tempSelectedDay = selectedDay;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Agregar Horario"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropDownButton((newDay) {
                    setState(() {
                      tempSelectedDay = newDay;
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildTimePicker(
                    context: context,
                    controller: horaInicioController,
                    labelText: "Hora de inicio",
                    onTimeSelected: (time) {
                      setState(() {
                        selectedHoraInicio = time;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTimePicker(
                    context: context,
                    controller: horaFinController,
                    labelText: "Hora de fin",
                    onTimeSelected: (time) {
                      setState(() {
                        selectedHoraFin = time;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedHoraInicio != null && selectedHoraFin != null) {
                      setState(() {
                        Dia newDay = Dia(
                          idDia: const Uuid().v4(),
                          nombreDia: tempSelectedDay,
                          horaInicio: DateTime(0, 0, 0,
                              selectedHoraInicio!.hour, selectedHoraInicio!.minute),
                          horaFin: DateTime(0, 0, 0,
                              selectedHoraFin!.hour, selectedHoraFin!.minute),
                        );
                        selectedDays.add(newDay);
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Handle the case where one or both times are not selected
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});  // Ensure the parent state updates after the dialog is closed
    });
  }

  void _showEditDayDialog(BuildContext context, Dia dia) {
    TextEditingController horaInicioController = TextEditingController();
    TextEditingController horaFinController = TextEditingController();
    TimeOfDay selectedHoraInicio =
        TimeOfDay.fromDateTime(dia.horaInicio);
    TimeOfDay selectedHoraFin =
        TimeOfDay.fromDateTime(dia.horaFin);
    String tempSelectedDay = dia.nombreDia;

    horaInicioController.text = selectedHoraInicio.format(context);
    horaFinController.text = selectedHoraFin.format(context);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Editar Horario"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropDownButton((newDay) {
                    setState(() {
                      tempSelectedDay = newDay;
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildTimePicker(
                    context: context,
                    controller: horaInicioController,
                    labelText: "Hora de inicio",
                    onTimeSelected: (time) {
                      setState(() {
                        selectedHoraInicio = time;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTimePicker(
                    context: context,
                    controller: horaFinController,
                    labelText: "Hora de fin",
                    onTimeSelected: (time) {
                      setState(() {
                        selectedHoraFin = time;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dia.nombreDia = tempSelectedDay;
                      dia.horaInicio = DateTime(0, 0, 0,
                          selectedHoraInicio.hour, selectedHoraInicio.minute);
                      dia.horaFin = DateTime(0, 0, 0,
                          selectedHoraFin.hour, selectedHoraFin.minute);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});  // Ensure the parent state updates after the dialog is closed
    });
  }
}
