# Configurações e Atualizações - NAS Synology

Este documento serve como guia de implementação, configuração contínua e resolução de problemas específicos do ambiente de alojamento local (NAS Synology).

## 1. Topologia da Arquitetura

O projeto utiliza a stack:
- **Astro (Node.js SSR)**: Processa e serve a interface de utilizador web.
- **PocketBase (SQLite)**: Gere a base de dados de ficheiro único (ideal para I/O do NAS) e lida com a autenticação de utilizadores.

## 2. Configuração Inicial via Docker Compose

### Pré-Requisitos no NAS
1. Instalar o **Container Manager** (ou Docker) através do Package Center do DSM.
2. Criar uma pasta partilhada para o projeto (ex: `/volume1/docker/pn-l-app`).
3. Conceder permissões de leitura/escrita à pasta `pb_data` para evitar erros do PocketBase (normalmente precisa que o user do docker tenha UID/GID adequado).

### Levantar a Infraestrutura
A partir do terminal do NAS (SSH) ou através da interface do Container Manager:
```bash
docker-compose up -d --build
```
*Isto irá inicializar a porta 8090 para o backend e a porta 4321 para o frontend.*

## 3. Configuração do Reverse Proxy (Synology DSM)
Para aceder à aplicação sem usar portas (ex: `https://financas.local`):
1. Ir a **Control Panel > Login Portal > Advanced > Reverse Proxy**.
2. Criar uma nova regra:
   - **Source**: Protocol `HTTPS`, Hostname `financas.local` (ou o DDNS), Port `443`
   - **Destination**: Protocol `HTTP`, Hostname `localhost`, Port `4321` (Frontend).

*(Opcional)* Se for necessário acesso direto à API/Admin UI fora do frontend:
- Criar regra paralela: `https://api.financas.local` -> `http://localhost:8090`.

## 4. Atualizações Automáticas (Estilo BandOS)
O NAS está desenhado para atualizar de forma autónoma através do script `scripts/nas_autoupdate.sh` sempre que o código no repositório GitHub for alterado.

### Configurar Automação no NAS (Task Scheduler):
1. No DSM, abre o **Control Panel > Task Scheduler** (Agendador de Tarefas).
2. Cria uma nova tarefa agendada: **Create > Scheduled Task > User-defined script**.
3. **General**: Dá um nome à tarefa (ex: `P&L AutoUpdate`) e atribui o utilizador `root` ou o teu utilizador com privilégios Docker.
4. **Schedule**: Define para correr diariamente (ex: às 03:00) ou a cada 4 horas.
5. **Task Settings**: Na caixa de *Run command*, insere o seguinte caminho:
   ```bash
   /volume1/docker/pn-l-app/scripts/nas_autoupdate.sh >> /volume1/docker/pn-l-app/logs/cron_update.log 2>&1
   ```
   *(Substitui `/volume1/docker/pn-l-app` pelo caminho real da tua instalação no NAS).*

Ao ser corrido, o NAS faz um Git Pull e, se houver código novo (visto no CHANGELOG.md), ele fará o build do Frontend limpo e reiniciará o contentor sem interferir com os dados persistentes (`pb_data`).
