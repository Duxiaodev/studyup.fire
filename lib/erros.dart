String traduzErro(String code) {
  switch (code) {
    case 'invalid-email': return 'E-mail inválido.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential': return 'E-mail ou senha incorretos.';
    case 'email-already-in-use': return 'Este e-mail já está cadastrado.';
    case 'weak-password': return 'Senha fraca (mínimo 6 caracteres).';
    case 'too-many-requests': return 'Muitas tentativas. Aguarde um pouco.';
    default: return 'Erro: $code';
  }
}
