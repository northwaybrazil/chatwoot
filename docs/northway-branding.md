# Northway Hub — Personalização visual

Este documento registra a troca de identidade visual do Chatwoot (base
`v4.12.1`) para a marca Northway Hub, feita na branch
`claude/northway-hub-design-system-rtuppv`.

## O que foi alterado

| Item | Antes | Depois | Arquivo |
| --- | --- | --- | --- |
| Nome da instalação | `Chatwoot` | `Northway Hub` | `config/installation_config.yml` (`INSTALLATION_NAME`, `BRAND_NAME`) |
| Logo (fundo claro) | `/brand-assets/logo.svg` | URL Supabase `logo-north-black.png` | `config/installation_config.yml` (`LOGO`) |
| Logo (fundo escuro) | `/brand-assets/logo_dark.svg` | URL Supabase `logo-north-white.png` | `config/installation_config.yml` (`LOGO_DARK`) |
| Favicon / thumbnail | `/brand-assets/logo_thumbnail.svg` | URL Supabase `favicon-north.png` | `config/installation_config.yml` (`LOGO_THUMBNAIL`) |
| Cor primária (`n-brand`) | `#2781F6` (azul Chatwoot) | `#EB5757` (coral Northway) | `theme/colors.js` |
| Favicon do navegador (todos os tamanhos) | PNGs locais em `public/` | `LOGO_THUMBNAIL` (dinâmico) | `app/views/layouts/vueapp.html.erb` |
| `theme-color` / `msapplication-TileColor` | `#1f93ff` | `#EB5757` | `app/views/layouts/vueapp.html.erb` |
| PWA manifest (nome, ícones, cor) | Chatwoot / azul | Northway Hub / coral | `public/manifest.json` |
| Favicon após notificação (aba em segundo plano) | sempre revertia para ícone antigo do Chatwoot | reverte para `LOGO_THUMBNAIL` | `app/javascript/dashboard/helper/AudioAlerts/faviconHelper.js` |
| Sidebar do Super Admin | logo + texto "Chatwoot" | logo + texto "Northway Hub" | `app/views/super_admin/application/_navigation.html.erb` |
| Tela de login do Super Admin (modo claro) | logo Chatwoot | logo Northway (preta) | `app/views/super_admin/devise/sessions/new.html.erb` |
| Título da aba do Super Admin | `SuperAdmin \| Chatwoot` | `SuperAdmin \| Northway Hub` | `app/views/super_admin/devise/sessions/new.html.erb` |

## O que foi mantido intencionalmente

- **Logo em fundo escuro (negativo) do console Super Admin**: por pedido
  explícito, a versão dark (`hidden dark:block`) da tela de login do
  Super Admin continua usando `/brand-assets/logo_dark.svg` (Chatwoot).
- **Tela de login, cadastro e SSO do app principal** (`app/javascript/v3/views/login/*`,
  `auth/signup/Index.vue`): não precisaram de nenhuma alteração de código —
  já são 100% dirigidas por `globalConfig` (`LOGO`, `LOGO_DARK`,
  `INSTALLATION_NAME`) e pela classe utilitária `n-brand`. Ao trocar os
  valores de config e o token de cor, elas já refletem a marca Northway
  automaticamente.
- **Textos de UI que dizem "Chatwoot"** (ex.: `LOGIN.TITLE` em `en.yml`/`en.json`):
  continuam com a palavra "Chatwoot" no arquivo de tradução, mas são
  substituídos em tempo de execução pelo composable `useBranding`
  (`replaceInstallationName`), que já é o mecanismo padrão do projeto para
  White-labeling. Não foi necessário (nem é recomendado) editar as strings
  de tradução.
- **Modo escuro do dashboard**: mantido funcional; a cor de marca (`n-brand`)
  tem valores de leitura adequados nos dois temas porque é uma cor sólida
  (`#EB5757`), não uma variável de tema.
- **Cores semânticas** (erro, sucesso, atenção, informação): não foram
  alteradas — o token `n-brand` é usado apenas para ação primária,
  seleção e foco, seguindo a regra de não usar a cor de marca como cor de
  estado.

## E-mails (idioma e marca)

| Item | Antes | Depois | Arquivo |
| --- | --- | --- | --- |
| Idioma padrão da instalação | `en` (implícito) | `pt_BR` | `config/application.rb` (`config.i18n.default_locale`) |
| Layout de e-mail (notificações via Liquid) | sem logo, borda `#0080f8` | logo Northway (`global_config['LOGO']`) + borda `#EB5757` | `app/views/layouts/mailer/base.liquid` |
| Rodapé "Powered by" do e-mail | `Powered by {{ BRAND_NAME }}` | `Desenvolvido por {{ BRAND_NAME }}` (já mostra "Northway Hub") | `app/views/layouts/mailer/base.liquid` |
| Conteúdo dos 24 templates `.liquid` de notificação (admin, agente, time, portal) | Inglês, hardcoded | Traduzido para português, variáveis/Liquid preservadas | `app/views/mailers/**/*.liquid` |
| Assuntos (subject) das notificações administrativas, de canal, integrações e conversas de agente | Inglês, hardcoded em Ruby | Traduzidos para português | `app/mailers/administrator_notifications/*.rb`, `app/mailers/agent_notifications/conversation_notifications_mailer.rb`, `app/mailers/team_notifications/automation_notification_mailer.rb` |
| Formatação de datas em e-mails (`account_notification_mailer.rb`, `account_compliance_mailer.rb`) | `strftime('%B %d, %Y')` (nomes de mês em inglês) | `strftime('%d/%m/%Y')` (padrão brasileiro, não depende de tradução de mês) | mesmos arquivos |
| E-mails transacionais do Devise (redefinir senha, confirmar conta, desbloquear conta, senha alterada) | Texto em inglês, hardcoded | Traduzido para português (visual apenas, lógica de autenticação intocada) | `app/views/devise/mailer/*.html.erb` |
| `global_config` disponível nos mailers | `BRAND_NAME`, `BRAND_URL` | + `LOGO` | `app/mailers/application_mailer.rb` |

**Por que o idioma padrão do app inteiro, e não só dos e-mails:** o modelo
`Account` tem `locale` com valor padrão `"en"` no nível do banco de dados
(`db/schema.rb`). Isso significa que toda conta — nova ou existente — já
tem um locale explícito (`en`), que tem prioridade sobre
`I18n.default_locale` no mailer (`ApplicationMailer#locale_from_account`).
Ou seja, mudar só o default do Rails **não muda sozinho** o idioma dos
e-mails de uma conta existente. Não alteramos esse default do banco por
ser uma migration (fora do escopo autorizado). **Ação necessária:** em
cada conta, um administrador precisa ir em Configurações → Geral →
Idioma e selecionar "Português (Brasil)" para que e-mails e o próprio
dashboard dessa conta passem a usar o idioma novo. As traduções pt_BR já
existem no projeto (`config/locales/pt_BR.yml`, `devise.pt_BR.yml`) e já
cobrem os assuntos de e-mail do Devise e do `ConversationReplyMailer`.

**Assuntos e corpos gerados por módulos Enterprise** (SLA em
`AgentNotifications::ConversationNotificationsMailer`, por exemplo) não
foram tocados — ficam em `enterprise/`, fora do escopo autorizado desta
tarefa. Os templates `.liquid` correspondentes (`sla_missed_*`) já foram
traduzidos, pois vivem em `app/views/mailers/` (código núcleo, não Enterprise).

**`MAILER_SENDER_EMAIL`**: o remetente padrão de fallback continua
`Chatwoot <accounts@chatwoot.com>` (só é usado se a variável de ambiente
não estiver configurada). Não inventamos um domínio Northway falso —
configure `MAILER_SENDER_EMAIL` no ambiente de produção com o domínio
real de vocês.

## Auditoria de cores azuis remanescentes (design system "next")

Depois do deploy, notou-se que abas, badges, links e o ícone circular do
canto superior esquerdo do sidebar continuavam azuis mesmo com
`theme/colors.js` (`n.brand`) já alterado. Investigação revelou a causa:

**Achado central:** no design system "next" (`app/javascript/dashboard/components-next`),
a escala `n-blue-1..12` (definida em `_next-colors.scss` como as variáveis
CSS `--blue-1..12`) **é** a escala de marca/interativa — `--blue-9` valia
exatamente `39 129 246` (`#2781F6`), o azul antigo do Chatwoot. Ela é usada
diretamente (não via `n-brand`) em abas ativas, badges de contagem, links,
checkboxes, inputs em foco e menus selecionados — por isso a troca de
`n.brand` sozinha não bastou.

### O que foi feito

| Token / arquivo | Antes | Depois |
| --- | --- | --- |
| `--blue-1..12` (`_next-colors.scss`, light e dark) | escala azul (`#2781F6` no passo 9) | escala coral Northway (`#EB5757` no passo 9) |
| `--text-blue`, `--solid-blue`, `--solid-blue-2`, `--border-blue-strong`, `--border-blue` | derivadas do azul | recalculadas a partir da escala coral |
| **Novo token `--info-1..12` / `n.info`** | — | escala azul original, preservada para uso semântico (não é mais o padrão de nenhum componente, só usada explicitamente) |
| `theme/colors.js` → paleta `woot` (design system antigo) | derivada de `@radix-ui/colors` blue | hex fixos na escala coral (passo 500 = `#EB5757`) |
| `app/javascript/widget/assets/scss/woot.scss`, `.../super_admin/index.scss`, `.../widget-preview/components/Widget.vue` | mesmas variáveis derivadas do azul | mesmas derivadas recalculadas para coral |
| `Banner.vue`, `label/Label.vue`, `BaseHeatmap.vue` (variante/cor `"blue"`) | usavam `n-blue-*` | repontados para `n-info-*` — são usos semânticos (banner informativo, etiqueta azul, heatmap), não de marca |
| `components-next/icon/Logo.vue` (fallback SVG, sem `LOGO_THUMBNAIL` configurado) | círculo azul com bolha de chat (logo antigo do Chatwoot) | quadrado `#09090B` com monograma "N" branco, seguindo o padrão do design system Northway |
| 8 hex hardcoded (`#2781F6`/`#1F93FF`/`#0080f8`) em `sdk.js`, `EmojiInput.vue`, `Dyte.vue`, `CreatePortalDialog.vue`, `AudioRecorder.vue`, `LabelSuggestion.vue`, `ChatInputWrap.vue`, `_icons.html.erb` | azul Chatwoot | `#EB5757` |

**Por que não foi preciso editar os ~90 componentes individualmente:**
todos os usos de `n-blue-*`/`text-woot-*`/`bg-woot-*` continuam funcionando
exatamente como antes — só o valor por trás do token mudou. Os únicos
componentes editados diretamente foram os 3 que usavam a variante
**semântica** `"blue"` (que precisava continuar azul) e que, portanto,
precisavam apontar para a nova escala `n-info-*` em vez de `n-blue-*`.

**O que foi preservado, conforme pedido:**
- Cores de etiquetas criadas pelo usuário (não são tokens de tema, são
  hex arbitrários salvos por conta).
- Vermelho de erro (`n-ruby-*`), âmbar de aviso (`n-amber-*`), verde de
  sucesso (`n-teal-*`) — nenhum desses tokens foi tocado.
- Cores dos canais WhatsApp/Instagram/Facebook (`#25D366`, `#1877F2` etc.)
  — não fazem parte da escala `n-blue`/`woot`, ficaram intactas.
- Banco, APIs, autenticação e regras de negócio — nada tocado.
- Modo claro e escuro: a escala coral tem variantes `:root` e `.dark`
  calculadas mantendo a mesma relação de contraste que a escala azul
  original tinha (mesma "distância" perceptual entre os 12 passos).

### Bolha de mensagem do agente (outgoing) — laranja suave dedicado

O token `--solid-blue` (usado em `bg-n-solid-blue`) também controla o fundo
das mensagens enviadas pelo agente (`message/bubbles/Base.vue`, bolha de
e-mail em `Email/Index.vue` e o assistente Captain em `MessageList.vue`).
A conversão mecânica inicial (derivada da mesma fórmula da escala `blue`)
resultou num tom coral apagado. A pedido, foi ajustado para um laranja
suave dedicado, mais quente e menos saturado que o coral principal:

| | Claro | Escuro |
| --- | --- | --- |
| `--solid-blue` | `rgb(255 231 209)` — pêssego suave | `rgb(74 46 22)` — terracota abafado |
| `--solid-blue-2` (gradiente da bolha de e-mail) | `rgb(255 244 232)` | `rgb(42 30 20)` |

### Ícone do canto superior esquerdo — o que ele realmente é

Não é logo da conta nem avatar do workspace: é o **fallback padrão do
Chatwoot** (`components-next/icon/Logo.vue`), renderizado só quando
`globalConfig.logoThumbnail` está vazio. Como a instalação já configurada
usa a URL do Supabase como `LOGO_THUMBNAIL`, esse SVG só aparece se esse
valor não estiver setado (ex.: banco de uma instalação antiga que ainda
não rodou a atualização manual descrita mais abaixo, na seção de
e-mails). Ele foi substituído pelo monograma "N" do design system.

## Pendências / follow-ups conhecidos

1. **`BRAND_URL` e `WIDGET_BRAND_URL`** em `config/installation_config.yml`
   continuam apontando para `https://www.chatwoot.com` (usado no link
   "Powered by" de e-mails e do widget). Não havia um domínio oficial da
   Northway para usar; atualizar assim que houver um.
2. **Dependência externa do Supabase**: `LOGO`, `LOGO_DARK` e
   `LOGO_THUMBNAIL` apontam para URLs públicas do bucket
   `image-website` no projeto Supabase "Northway Website". Caso esse bucket
   fique indisponível ou seja renomeado, a logo do Chatwoot vai parar de
   carregar. Recomendado migrar para `public/brand-assets/` (arquivos
   locais) quando for possível enviar os PNGs originais para o
   repositório.
3. **Badge de favicon com notificação não lida** (bolinha vermelha sobre o
   ícone, ver `showBadgeOnFavicon` em `faviconHelper.js`): continua usando
   os PNGs antigos (`/favicon-badge-*.png`, estilo Chatwoot). Não foram
   gerados equivalentes com a marca Northway.
4. **Ícones estáticos antigos** em `public/` (`apple-icon-*.png`,
   `android-icon-*.png`, `favicon-*.png`, `ms-icon-*.png`) não foram
   removidos — ficaram órfãos (não são mais referenciados pelo layout
   principal, mas ainda existem no disco). Podem ser removidos com
   segurança em uma limpeza futura.
5. **`config/installation_config.yml` é apenas o seed inicial.** Uma
   instalação já em produção (com `installation_configs` já gravado no
   banco) não vai pegar esses novos valores automaticamente — é preciso
   atualizar via Super Admin → Configurações, ou rodar novamente o seed,
   ou uma migration de dados dedicada.
