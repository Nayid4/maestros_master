import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_asistencia.dart';
import 'package:maestros_master/domain/models/asistencia.dart';
import 'package:maestros_master/domain/models/estado_asistencia.dart';

class AsistenciaItem extends StatelessWidget {
  final Asistencia asistencia;
  final AsistenciaController asistenciaController;

  const AsistenciaItem({
    Key? key,
    required this.asistencia,
    required this.asistenciaController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        trailing: IconButton(
          onPressed: () {
            _showDeleteConfirmationDialog(context, asistencia.idAsistencia);
          },
          icon: const Icon(Icons.delete),
        ),
        leading: Icon(
          Icons.checklist_outlined,
          color: Colors.greenAccent.shade400,
          size: 40,
        ),
        title: Text("Fecha: ${asistencia.fecha.toLocal().toString().split(' ')[0]}"),
        subtitle: Text("Total Estudiantes: ${asistencia.estadoEstudiantes.length}"),
        onTap: () {
          _showDetalleAsistenciaDialog(context, asistencia);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String idAsistencia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text("¿Está seguro de que desea eliminar esta asistencia?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                asistenciaController.deleteAsistencia(idAsistencia);
                Get.back();
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _showDetalleAsistenciaDialog(BuildContext context, Asistencia asistencia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Detalles de Asistencias",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: asistencia.estadoEstudiantes.map((estadoEstudiante) {
                        return _StudentAttendanceItem(
                          estadoEstudiante: estadoEstudiante,
                          asistenciaController: asistenciaController,
                          asistencia: asistencia,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cerrar"),
                    ),
                    TextButton(
                      onPressed: () {
                        asistenciaController.updateAsistencia(asistencia);
                        Get.back();
                      },
                      child: const Text("Guardar cambios"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StudentAttendanceItem extends StatefulWidget {
  final EstadoAsistencia estadoEstudiante;
  final AsistenciaController asistenciaController;
  final Asistencia asistencia;

  const _StudentAttendanceItem({
    Key? key,
    required this.estadoEstudiante,
    required this.asistenciaController,
    required this.asistencia,
  }) : super(key: key);

  @override
  __StudentAttendanceItemState createState() => __StudentAttendanceItemState();
}

class __StudentAttendanceItemState extends State<_StudentAttendanceItem> {
  late String _selectedState;
  late String _studentNombre;
  late String _studentCedula;

  @override
  void initState() {
    super.initState();
    _selectedState = widget.estadoEstudiante.estado;
    _studentNombre = '${widget.estadoEstudiante.estudiante.nombre} ${widget.estadoEstudiante.estudiante.apellidos}';
    _studentCedula = 'CC ${widget.estadoEstudiante.estudiante.cedula}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            Icons.perm_contact_calendar_sharp,
            color: Colors.greenAccent.shade400,
            size: 40,
          ),
          title: Text(_studentNombre),
          subtitle: Text(_studentCedula),
          trailing: DropdownButton<String>(
            value: _selectedState,
            items: ['presente', 'ausente', 'tarde'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedState = newValue!;
              });
              widget.asistenciaController.updateEstadoEstudiante(
                widget.asistencia.idAsistencia,
                widget.estadoEstudiante.idEstado,
                _selectedState,
              );
            },
          ),
        ),
      ),
    );
  }
}
