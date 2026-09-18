# Manual do Utilizador: Gestão P&L

Bem-vindo à aplicação de Gestão Financeira Pessoal e Empresarial. Este manual destina-se a ajudar utilizadores (Administradores ou Restritos) a tirar o máximo partido do sistema.

## Módulos de Negócio Disponíveis
A plataforma centraliza 3 esferas financeiras da tua vida, cada uma identificada por uma cor no Dashboard:

### 1. Orçamento Familiar (Verde)
Foca-se nas finanças correntes da casa. 
- **O que incluir**: Salários, Despesas de supermercado, faturas mensais (água, luz, telecomunicações).
- **Métricas Chave**: Cashflow mensal e distribuição de despesas.

### 2. Arrendamento (Azul Oceânico)
Foca-se na gestão do portfólio imobiliário e as suas margens de lucro.
- **O que incluir**: Rendas cobradas, prestação do Crédito Habitação, IMI, quotas de Condomínio e manutenções do espaço.
- **Métricas Chave**: Património líquido acumulado e rentabilidade do imóvel.

### 3. I Love Paul do Mar (Laranja Pôr do Sol)
Apoio ao e-commerce e merchandising do projeto.
- **O que incluir**: Receitas das vendas, despesas de matérias-primas e custos logísticos.
- **Métricas Chave**: Margem Bruta por Produto e Margem Líquida.

---

## 📥 Importação Bancária por CSV (Staging)
Uma das funcionalidades core é a facilidade em importar extratos bancários sem ter de inserir registos um a um.

1. Navega para o menu **Importar CSV**.
2. Faz o Upload do ficheiro do teu banco.
3. **Ecrã de Validação (Staging)**: O sistema não insere nada diretamente na base de dados. Em vez disso, apresenta uma grelha.
4. Para cada linha, ajusta rapidamente a **Categoria** e o **Módulo** de destino.
5. Clica no **Visto Verde** para aprovar e gravar, ou na **Cruz Vermelha** para descartar essa linha do extrato.

## 🛠️ Amortização de Equipamentos (CAPEX)
Ao adquirires um equipamento dispendioso para o projeto (ex: Gravadora Laser de 600€), não deves abater o custo todo no mês de compra para não distorcer a Margem Líquida.
1. No formulário de despesa, ativa a opção "É uma despesa de Equipamento".
2. Seleciona o número de meses em que pretendes amortizar o investimento (ex: 12 meses).
3. O sistema calcula e deduzirá de forma faseada 50€ mensais durante o período estipulado nos relatórios futuros.
