# Changelog e Registo de Desenvolvimento

Este documento mantém o registo contínuo de todas as atualizações, novas features e correções aplicadas à aplicação P&L. Segue a metodologia baseada em versões (SemVer).

## [Unreleased]
### Adicionado
- Setup inicial da infraestrutura (`docker-compose.yml`) com serviços para o Astro (Frontend) e PocketBase (Backend).
- Implementação visual do Dashboard Global com a metodologia Bento Box.
- Scripting de automação DevOps (`git_sync.sh` e `nas_autoupdate.sh`).
- Esquema de coleções para importação direta no PocketBase (`pb_schema.json`).
- Integração da framework **Svelte** no Astro para estado reativo.
- Componente de Validação interativo com leitura *Client-Side* de ficheiros Excel (XLS/XLSX) via `SheetJS (xlsx)` (`CsvStaging.svelte`).
- Cliente oficial SDK ligado ao frontend (`pocketbase.ts`).
- Manuais complementados (`VERSIONAMENTO.md`, `MANUAL_UTILIZADOR.md`).

### Por Fazer
- Injeção das aprovações da grelha de Staging diretamente na DB (transações).
- Desenvolvimento do Dashboard com leitura real a partir do PocketBase.
- Lógica de autenticação e RBAC.

## [0.1.0] - 2026-09-18
- Inicialização do repositório P&L.
- Levantamento de requisitos arquiteturais (NAS Synology, Docker, Astro, PocketBase).
