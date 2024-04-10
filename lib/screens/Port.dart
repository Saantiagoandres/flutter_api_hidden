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
        toolbarHeight: 100,
        title: const Text("Hidden Talents"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 138, 80, 231),
        actions: [
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
        ],
        leading: Image.asset(
          "assets/images/logo.png",
          height: 100.0,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 104, 168, 211),
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
                  return ListTile(
                    title: Text('Nombre: ${userData['name'] ?? ''}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Apellido: ${userData['lastname'] ?? ''}'),
                        Text('Telefono: ${userData['telefono'] ?? ''}'),
                        Text('Email: ${userData['email'] ?? ''}'),
                        Text('Password: ${userData['password'] ?? ''}'),
                        Text('Role: ${userData['role']['nombre_rol'] ?? ''}'),
                      ],
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
      height: 250.0, // Define la altura deseada
      padding: EdgeInsets.all(10.0),
      color: Color.fromARGB(255, 138, 80, 231),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/perfil1.png',
                width: 100, // Ancho deseado de la imagen
                height: 100, // Alto deseado de la imagen
              ),
              _buildFooterIcon(Icons.audiotrack),
              _buildFooterIcon(Icons.fingerprint),
              _buildFooterIcon(Icons.call),
              Image.asset(
                'assets/images/perfil1.png',
                width: 180, // Ancho deseado de la imagen
                height: 180, // Alto deseado de la imagen
              ),
            ],
          ),
          const Text(
            'Copyright ©2024, All Rights Reserved.',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
              color: Color(0xFF162A49),
            ),
          ),
          const Text(
            'Powered by Your Company',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
              color: Color(0xFF162A49),
            ),
          ),
        ],
      ),
    );
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
}
