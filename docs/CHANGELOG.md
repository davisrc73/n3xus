# Changelog e Registo de Desenvolvimento

Este documento mantém o registo contínuo de todas as atualizações, novas features e correções aplicadas à aplicação P&L. Segue a metodologia baseada em versões (SemVer).

## [Unreleased]
### Adicionado
- Setup inicial da infraestrutura (`docker-compose.yml`) com serviços para o Astro (Frontend) e PocketBase (Backend).
- Implementação visual do Dashboard Global com a metodologia Bento Box.
- Ecrã de "Staging / Validação" de CSV (Staging Grid).
- Criação do sistema centralizado de documentação.

### Por Fazer
- Ligação do SDK do PocketBase ao Astro.
- Configuração das coleções no PocketBase (`users`, `transactions`, `categories`, `assets_amortizations`).
- Lógica de autenticação e RBAC.
- Parsing e upload real de ficheiros CSV.

## [0.1.0] - 2026-09-18
- Inicialização do repositório P&L.
- Levantamento de requisitos arquiteturais (NAS Synology, Docker, Astro, PocketBase).
