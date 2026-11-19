import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'erros.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nome = TextEditingController();
  final _telefone = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _carregando = false;

  void _msg(String t) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(t)));

  Future<void> _registrar() async {
    if (_nome.text.trim().isEmpty || _telefone.text.trim().isEmpty) {
      _msg('Preencha nome e telefone.');
      return;
    }
    setState(() => _carregando = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _senha.text);

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cred.user!.uid)
          .set({
        'nome': _nome.text.trim(),
        'telefone': _telefone.text.trim(),
        'email': _email.text.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _msg(traduzErro(e.code));
    } catch (e) {
      _msg('Erro ao salvar dados: $e');
    }
    if (mounted) setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                  controller: _nome,
                  decoration: const InputDecoration(
                      labelText: 'Nome', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(
                  controller: _telefone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'Telefone', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'E-mail', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(
                  controller: _senha,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Senha (mín. 6 caracteres)',
                      border: OutlineInputBorder())),
              const SizedBox(height: 16),
              _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: _registrar, child: const Text('Cadastrar')),
            ],
          ),
        ),
      ),
    );
  }
}
