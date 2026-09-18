# Regras de Versionamento e Controlo de Lançamentos

Este documento define os princípios de versão do código base do P&L (estilo BandOS) de forma a manter os ciclos de lançamento (deploy) organizados para o NAS Synology.

## Semantic Versioning (SemVer)
Adotamos a especificação `MAJOR.MINOR.PATCH` (ex: `1.2.5`):
- **MAJOR (1.x.x)**: Mudanças arquiteturais ou de Base de Dados (PocketBase Schema) incompatíveis com as anteriores. Se mudarmos o schema central do SQL, incrementamos isto.
- **MINOR (x.2.x)**: Novas features implementadas na UI (Dashboard, novo gráfico, exportação PDF), mas que mantêm a base de dados retrocompatível.
- **PATCH (x.x.5)**: Correções de bugs, pequenas otimizações de Tailwind, ou fixes nos scripts de automação.

## Fluxo de Deploy
1. **Ambiente Local**: Testamos e fechamos a feature.
2. **Commit e Sync**: Corremos `./scripts/git_sync.sh` que empurra o código.
3. **NAS Pull**: O `nas_autoupdate.sh` que reside no NAS executa periodicamente, deteta a nova versão na branch principal e efetua o `docker-compose up -d --build`, reiniciando com *downtime* mínimo.

## Registo Histórico
O histórico textual da evolução técnica do produto mantém-se centralizado no `CHANGELOG.md`. Sempre que fecharmos uma **MINOR** ou **MAJOR** release, atualizamos o título Unreleased para a respetiva versão no Changelog.
