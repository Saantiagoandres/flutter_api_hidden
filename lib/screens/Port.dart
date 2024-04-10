import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  toolbarHeight: 120, // Ajusta la altura del AppBar según el tamaño del logo
  title: const Text("Hidden Talents"),
  centerTitle: true,
  backgroundColor: Color.fromARGB(255, 158, 117, 224),
  actions: [
    IconButton(
      onPressed: () {
        // Acción al presionar el botón de búsqueda
      },
      icon: Icon(Icons.search),
    ),
    IconButton(
      onPressed: () {
        // Acción al presionar el botón de notificaciones
      },
      icon: Icon(Icons.notifications),
    ),
    Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu),
        );
      },
    ),
    IconButton(
      onPressed: () {
        // Acción al presionar el botón de perfil
      },
      icon: Icon(Icons.person),
    ),
  ],
  leading: Container(
    margin: EdgeInsets.all(0.0), // Margen alrededor del logo
    width: 120, // Ancho del logo
    height: 100, // Alto del logo
    child: Image.asset(
      "assets/images/logo.png",
      fit: BoxFit.scaleDown, // Ajusta la imagen dentro del contenedor sin distorsionarla
    ),
  ),
),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 90, 219, 228),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                height: 50.0, // Tamaño deseado del logo
              ),
            ),
            ListTile(
              title: Text('Lista De Usuarios'),
              onTap: () {
                // Navegar a la vista de lista de usuarios
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserList()),
                );
              },
            ),
            ListTile(
              title: Text('Inicio'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Quienes Somos'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Contactenos'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: const UserList(),
      bottomNavigationBar: MyFooter(),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Lista de Usuario de la Api'),
      centerTitle: true,
    ),
    body: FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final userData = snapshot.data![index];
                return Center( // Centra todo el ListTile
                  child: ListTile(
                    title: Text(
                      'Nombre: ${userData['name'] ?? ''}',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Centra el texto dentro de la columna
                      children: [
                        Text(
                          'Apellido: ${userData['lastname'] ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Telefono: ${userData['telefono'] ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Email: ${userData['email'] ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Password: ${userData['password'] ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Role: ${userData['role']['nombre_rol'] ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        }
      },
    ),
  );
}


  Future<List<dynamic>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/v1/users'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return []; // Devuelve una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al realizar la solicitud HTTP: $e');
      return []; // Devuelve una lista vacía en caso de error
    }
  }
}

class MyFooter extends StatelessWidget {
  @override
Widget build(BuildContext context) {
  return Container(
    height: 250.0,
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF9E47E7), Color.fromARGB(224, 255, 197, 161)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            _buildFooterIcon(Icons.camera),
            _buildFooterIcon(Icons.email),
            _buildFooterIcon(Icons.facebook),
            _buildFooterIcon(Icons.location_on),
            _buildFooterIcon(Icons.phone),
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '¡Conéctate con nosotros en redes sociales!',
            style: TextStyle(
              color: Color.fromARGB(255, 220, 16, 16),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Hidden Talents - Descubre tu talento oculto',
            style: TextStyle(
              color: const Color.fromARGB(255, 240, 10, 10),
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

  }

  Widget _buildFooterIcon(IconData iconData) {
    return Container(
      height: 45.0,
      width: 45.0,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: IconButton(
          icon: Icon(
            iconData,
            size: 20.0,
          ),
          color: Color(0xFF162A49),
          onPressed: () {},
        ),
      ),
    );
  }

