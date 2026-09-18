# Gestão Financeira Pessoal & Empresarial (P&L)

Aplicação Web otimizada para self-hosting em **NAS Synology** (via Docker), utilizando **Astro** (SSR) e **PocketBase**. A aplicação unifica a gestão financeira entre orçamentos familiares, gestão de arrendamento imobiliário e comércio eletrónico.

## Estrutura de Documentação
À semelhança da metodologia implementada no projeto BandOS, todo o progresso de desenvolvimento, decisões técnicas, arquitetura e atualizações ao longo do tempo encontram-se documentados e centralizados na diretoria `docs/`:

- 📜 [**CHANGELOG.md**](./docs/CHANGELOG.md): Registo das versões, novas features, e componentes desenvolvidos.
- ⚙️ [**NAS_DEPLOYMENT.md**](./docs/NAS_DEPLOYMENT.md): Configurações exclusivas para o alojamento no Synology (Reverse Proxy, Docker, Permissões).

## Módulos de Negócio
1. **Orçamento Familiar**: Controlo de receitas e despesas correntes (Cashflow da casa).
2. **Arrendamento**: Gestão de património imobiliário (rendas vs encargos, IMI, Condomínio).
3. **I Love Paul do Mar (Projeto)**: Margens brutas e líquidas de E-commerce, incluindo diluição de **Amortizações (CAPEX)**.

## Stack Técnica
- **Astro**: Para um Frontend reativo, com Server-Side Rendering (SSR).
- **Tailwind CSS**: Estilização Mobile-first baseada em _Bento Box_ (cores separadas por área de negócio).
- **PocketBase**: Solução _all-in-one_ leve (base de dados SQLite e Auth) embutida na plataforma para máxima fiabilidade local.
- **Docker Compose**: Para a orquestração dos serviços no NAS.

## Iniciar Localmente (Dev)

Para iniciares o servidor web de desenvolvimento (Frontend):
```bash
cd frontend
npm install
npm run dev
```

(Para levantar a base de dados via Docker, consulta o documento de deployment).
