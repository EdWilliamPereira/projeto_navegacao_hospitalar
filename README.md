DOCUMENTO DE REQUISITOS (SRS)
Controle de Versões
1. Introdução
1.1 Objetivo deste documento
1.2 Escopo do sistema
2. Visão Geral do Sistema
2.1 Perspectiva do sistema
2.2 Principais usuários (stakeholders)
3. Definições, Acrônimos e Abreviações
4. Requisitos Funcionais (RF)
5. Requisitos Não-Funcionais (RNF)
6. Casos de Uso / Histórias de Usuário (exemplos)
7. Modelos de Dados / Estrutura do Mapa (resumo)
8. Resumo dos Critérios de Aceitação e Casos de Teste
9. Requisitos de Segurança e Privacidade
10. Restrições, Premissas e Riscos
Premissas
Restrições
Riscos principais e mitigação
11. Plano de Entrega / Releases (sugestão)
12. Anexos (diagramas, protótipos, arquivos de exemplo)
13. Aprovação

Projeto: Aplicativo de Mapeamento e Navegação Interna de Hospital
Versão: 1.0
Data: 16/03/2026
Gerente do Projeto: Ed William Pereira
Patrocinador: Ana Júlia

Controle de Versões
Versão
Data
Autor
Descrição
1.0
16/03/2026
Ed William Pereira
Versão inicial do SRS


1. Introdução
1.1 Objetivo deste documento
Descrever os requisitos funcionais e não-funcionais do aplicativo móvel de mapeamento e navegação interna do hospital, servindo como referência para desenvolvimento, testes e aceitação.
1.2 Escopo do sistema
Aplicativo móvel (Android) que permite visualizar mapas internos do hospital, buscar destinos, calcular rotas ponto-a-ponto e fornecer instruções ao usuário, com foco em acessibilidade e operação offline.

2. Visão Geral do Sistema
2.1 Perspectiva do sistema
O aplicativo será cliente leve, capaz de operar offline.
2.2 Principais usuários (stakeholders)
Pacientes e visitantes (usuários finais)
Profissionais do hospital (uso eventual)

3. Definições, Acrônimos e Abreviações
POI: Point of Interest (Ponto de Interesse)
MVP: Produto Mínimo Viável
TTS: Text-to-Speech (síntese vocal)
GPS: Global Positioning System
BLE: Bluetooth Low Energy

4. Requisitos Funcionais (RF)
Código
Requisito
Prioridade (M/A/B)
Descrição
Critério de Aceitação
RF-01
Visualização multi-andar
A
Alternar andares; camadas (rota, POI, acessibilidade), zoom/pan com gestos simples.
Trocar andar e validar elementos visíveis.
RF-02
Busca por destino (texto, categorias, voz)
M
Buscar por nome, categoria ou número; aceitar entrada por texto e por comando de voz; resultados ordenados por relevância/proximidade.
Busca retorna lista e localiza POI.
RF-03
Cálculo de rota ponto-a-ponto
A
Gerar rota (menor caminho) entre origem e destino; apresentar rota no mapa; considerar restrições (evitar escadas, preferir elevador).
Selecionar origem/destino → rota exibida e coerente.
RF-04
Instruções passo a passo (texto/áudio)
M
Lista de segmentos com ações (virar à direita); distância e indicação de referência; TTS pode ler cada etapa.
Iniciar rota → TTS anuncia próxima ação e distância; lista textual sincroniza com mapa.
RF-05
Modo somente-áudio / interface sem mapa
B
Permitir operação completa via áudio (TTS) e comandos por voz; todos os elementos interativos terão labels/descrições semânticas; navegação compatível com TalkBack.
Ativar modo → Completar fluxo “buscar → iniciar → seguir rota” sem usar interface visual.
RF-06
Localização do usuário (manual/GPS)
A
Definir "Estou aqui" manualmente; integração opcional com BLE/beacons.
Definir posição → iniciar rota.
RF-07
Perfis e preferências
B
Preferências de rota (evitar escadas), idioma, modo acessível.
Configurar a preferência "evitar escadas" → rota alterada.
RF-08
Notificações de virada (visual/sonoro/vibração)
M
Quando se aproximar do próximo passo, emitir TTS, vibração e notificação visual configurável.
Ao atingir threshold (configurável), app vibra, mostra banner e TTS anuncia ação.
RF-09
Rotas acessíveis
M
Dar prioridade para rotas com elevadores, rampas, portas largas; opção “rota acessível”.
Selecionar rota acessível → verificar ausência de escadas.
RF-10
Tema de alto contraste e alternativas a cores
B
Tema de alto contraste; informações não transmitidas apenas por cor (ícones + texto).
Teste de contraste automático OK; simulador de daltonismo mantém a legibilidade.
RF-11
Integração opcional com beacons/BLE/NFC
B
Se infraestrutura disponível, permitir integração para melhorar posicionamento.
Integração ativável; sem infraestrutura, app permite posição manual.


5. Requisitos Não-Funcionais (RNF)
Código
Requisito
Meta / Critério de Aceitação
RNF-01
Desempenho
Busca/rota locais: resposta ≤ 2 s em dispositivo alvo (MVP).
RNF-02
Consumo de bateria
Mecanismos de baixo consumo durante navegação contínua; consumo aceitável em testes.
RNF-03
Disponibilidade/offline
Funções essenciais (busca/rota) funcionam com dados em cache sem rede.
RNF-04
Precisão do roteamento
≥95% das rotas testadas em campo são válidas / coerentes.
RNF-05
Segurança e privacidade
Consentimento explícito para coleta de localização; conformidade com LGPD.
RNF-06
Compatibilidade
Android 10+.
RNF-07
Acessibilidade
Conformidade com WCAG 2.1 onde aplicável; suporte TalkBack. (W3C)
RNF-08
Internacionalização
Suporte inicial em pt-BR; possibilidade de adicionar outros idiomas.
RNF-09
Manutenibilidade
Código modular, testes automatizados e documentação de API/CMS.
RNF-10
Usabilidade para baixa visão / daltonismo
Contraste mínimo (≥4.5:1 para texto pequeno onde aplicável); alternativas não-cromáticas para informação crítica.


6. Casos de Uso / Histórias de Usuário (exemplos)
Como visitante, quero buscar “Consultório 12” e ser guiado até lá, para não me perder.
Fluxo principal: Buscar → Selecionar → Iniciar navegação → Receber instruções.
Critério de aceite: Fluxo completo testado em campo.
Como usuário cego, quero receber instruções por áudio para seguir a rota sem olhar para a tela.
Critério de aceite: Completar fluxo usando somente leitor de tela e TTS.
Usuário com mobilidade reduzida: “Quero uma rota que evite escadas.”
CA: Selecionar preferência → rota sem escadas (se mapa suportar dados de acessibilidade).

7. Modelos de Dados / Estrutura do Mapa (resumo)
Formato sugerido: JSON ou SQLite local contendo:
Nós (id, nome, andar, coordenadas locais, tipo)
Arestas (origem, destino, distância, acessível boolean)
POIs (id, nome, categoria, descrição, horário, tags)
Metadados: versão do mapa, data da última atualização, autor.

8. Resumo dos Critérios de Aceitação e Casos de Teste
Para cada RF: definir 1–3 casos de teste automatizados/manual. Ex.: RF-04 (rota) — Teste: gerar rota entre dois POIs em andares diferentes; verificar uso de elevador se “evitar escadas” estiver ativo.
Incluir testes de acessibilidade (TalkBack), contraste, tamanhos de alvo e testes com usuários reais (beta limitado).

9. Requisitos de Segurança e Privacidade
Consentimento explícito para coleta de localização; opção de operação totalmente offline.

10. Restrições, Premissas e Riscos
Premissas
Hospital permitirá levantamento de planta e acesso às áreas definidas.
A equipe terá dispositivos para testes.
Restrições
Orçamento total R$ 300,00 (conforme TAP).
Prazo acadêmico fixo (09/03/2026 – 28/05/2026).
Riscos principais e mitigação
Risco: Acesso limitado ao hospital. Mitigação: priorizar áreas públicas.
Risco: Precisão da localização sem infraestrutura. Mitigação: modo manual/estimado e recomendação de integração BEACON fase 2.
Risco: Falta de infraestrutura (beacons) reduz a precisão. Mitigação: modo manual e aviso no app sobre limitações; priorizar qualidade do grafo (nós/arestas).

11. Plano de Entrega / Releases (sugestão)
Release 1 (MVP): Mapas básicos, busca, rota básica, modo offline.
Release 2: Perfis, rotas acessíveis, notificações configuráveis, CMS.
Release 3: Integração BLE/beacons, localizações em tempo real (se infraestrutura disponível)., suporte TalkBack.

12. Anexos (diagramas, protótipos, arquivos de exemplo)
Diagrama do grafo (nós/arestas).
Exemplo de JSON do mapa.
Protótipos de tela (wireframes).
Checklist de testes de acessibilidade.