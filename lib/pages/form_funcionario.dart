import 'package:flutter/material.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class FormFuncionarioPage extends StatefulWidget {
  const FormFuncionarioPage({super.key});

  @override
  __FormFuncionarioPageState createState() => __FormFuncionarioPageState();
}

class __FormFuncionarioPageState extends State<FormFuncionarioPage> {
  String nome = '';
  String? ocupacao; // Start with null
  String? genero; // Start with null
  String cpf = '';
  String email = '';
  String endereco = '';
  String? cidade; // Start with null
  String cep = '';
  String senha = '';
  String dataNascimento = '';
  List<String> ocupacaoItems = [];
  List<String> generoItems = ['Masculino - Teste', 'Feminino', 'Outro'];
  List<String> cidadeItems = [
    'São Paulo',
    'Rio de Janeiro',
    'Belo Horizonte'
  ];

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOcupacoes();
  }

  Future<void> fetchOcupacoes() async {
  QueryBuilder<ParseObject> queryOcupacao =
      QueryBuilder<ParseObject>(ParseObject('ocupacao'));
  final ParseResponse apiResponse = await queryOcupacao.query();

  if (apiResponse.success && apiResponse.results != null) {
    setState(() {
      // Aqui, garantimos que estamos tratando corretamente o tipo de resultado.
      ocupacaoItems = (apiResponse.results as List<ParseObject>)
          .map((item) => item.get<String>('nome_ocupacao') ?? '')
          .where((nome) => nome.isNotEmpty) // Filtra nomes vazios, se necessário
          .toList();
    });
  } else {
    // Caso não haja sucesso ou os resultados sejam nulos
    setState(() {
      ocupacaoItems = []; // Define como uma lista vazia
    });
  }
}

  Future<void> saveFuncionario() async {
    final funcionario = ParseObject('Funcionario')
      ..set('nome', nome)
      ..set('ocupacao', ocupacao)
      ..set('genero', genero)
      ..set('cpf', cpf)
      ..set('email', email)
      ..set('endereco', endereco)
      ..set('cidade', cidade)
      ..set('cep', cep)
      ..set('senha', senha)
      ..set('data_nascimento', dataNascimento);

    await funcionario.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cadastro Funcionário"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.person, size: 60)),
              SizedBox(height: 20),

              TextField(
                onChanged: (text) {
                  nome = text;
                },
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: selectDate,
              ),

              SizedBox(height: 10),

              // Dropdown for Ocupação
              DropdownButtonFormField<String>(
                value: ocupacao,
                decoration: const InputDecoration(
                  labelText: 'Ocupação',
                  border: OutlineInputBorder(),
                ),
                items: ocupacaoItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    ocupacao = newValue;
                  });
                },
              ),
              SizedBox(height: 10),

              // Password Field
              TextField(
                obscureText: true,
                onChanged: (text) {
                  senha = text;
                },
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Dropdown for Gênero
              DropdownButtonFormField<String>(
                value: genero,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                items: generoItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    genero = newValue;
                  });
                },
              ),
              SizedBox(height: 10),

              TextField(
                onChanged: (text) {
                  cpf = text;
                },
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                onChanged: (text) {
                  email = text;
                },
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                onChanged: (text) {
                  endereco = text;
                },
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Dropdown for Cidade
              DropdownButtonFormField<String>(
                value: cidade,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                items: cidadeItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    cidade = newValue;
                  });
                },
              ),
              SizedBox(height: 10),

              TextField(
                onChanged: (text) {
                  cep = text;
                },
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    saveFuncionario();
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        dataNascimento = _dateController.text; // Save the date
      });
    }
  }
}
