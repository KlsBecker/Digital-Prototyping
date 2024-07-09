# Relatório do Projeto: Cronômetro Digital

#### Universidade do Vale do Rio dos Sinos – UNISINOS
#### Prototipação Digital
#### Professor: Sandro Binsfeld Ferreira
#### Estudante: Klaus Becker

---

## Introdução
Este projeto descreve o desenvolvimento de um cronômetro digital utilizando a placa DE10-Lite. O cronômetro foi implementado em VHDL e inclui funcionalidades de contagem regressiva e progressiva, armazenamento de tempos em memória, e exibição dos tempos em um display de 7 segmentos.

## Objetivos
Desenvolver um cronômetro digital com as seguintes características:
- Contagem regressiva e progressiva.
- Capacidade de pausar e reiniciar a contagem.
- Armazenamento de três tempos em memória.
- Configuração de tempo de contagem programável: 30s, 1, 2 ou 5 minutos.
- Exibição do tempo no display de 7 segmentos com piscamento dos dois pontos separadores a cada segundo.
- Indicador visual no final da contagem.

## Descrição do Projeto
O cronômetro foi implementado utilizando VHDL e prototipado na placa DE10-Lite. O código foi estruturado em diferentes processos para dividir as responsabilidades, incluindo controle do temporizador, contagem, e exibição no display de 7 segmentos.

## Funcionamento

O funcionamento do cronômetro é dividido em várias partes, cada uma responsável por uma função específica do cronômetro.

### 1. Divisor de Clock
A placa DE10-Lite fornece um clock de 50 MHz. Para gerar um pulso de 1 segundo, é necessário dividir a frequência do clock. Isso é feito com um contador que conta até 50.000.000 ciclos de clock. Quando esse valor é atingido, um pulso de 1 segundo é gerado e o contador é reiniciado. Este pulso é usado para atualizar a contagem do cronômetro.

**Lógica:**
- O processo `clock_divisor` verifica se o botão de start/stop foi pressionado (`start_stop_button`).
- Se pressionado, o contador do prescaler (`psc_count`) é zerado e o sinal de clock do cronômetro (`clk_timer`) é desativado.
- Se o clock de entrada (`CLK`) estiver na borda de subida, o contador do prescaler é incrementado até atingir o valor máximo (`PRESCALER`).
- Quando atinge o valor máximo, o contador do prescaler é reiniciado e o sinal de clock do cronômetro é invertido, gerando um pulso de 1 segundo.

### 2. Controle do Temporizador
O controle do temporizador é feito através dos botões `KEY0` e `KEY1`:
- `KEY0` é utilizado para iniciar e pausar a contagem. Um mecanismo de detecção de borda é usado para garantir que a ação ocorra apenas uma vez por clique, alternando o estado do cronômetro (running).
- `KEY1` é utilizado para gravar o tempo atual em uma das três memórias disponíveis. O tempo é salvo na primeira memória livre disponível.

**Lógica:**
- O processo `control_timer` verifica se ambos os botões são pressionados simultaneamente para resetar o cronômetro e limpar as memórias.
- Se `KEY0` for pressionado, o estado do cronômetro (running) é alternado utilizando detecção de borda.
- Se `KEY1` for pressionado, o tempo atual é salvo na próxima memória disponível.

### 3. Contagem do Tempo
O cronômetro pode operar em dois modos: contagem regressiva e contagem progressiva, definidos pela chave `SW0`.
- **Contagem Progressiva:** A contagem começa de zero e incrementa até atingir o tempo programado. Se atingir o tempo programado, o cronômetro para e sinaliza a expiração do tempo.
- **Contagem Regressiva:** A contagem começa do tempo programado e decrementa até zero. Quando atinge zero, o cronômetro para e sinaliza a expiração do tempo.

**Lógica:**
- O processo `counter_process` lida com a contagem baseada no sinal `clk_timer` e no modo selecionado (`upcount`).
- Se `running` for verdadeiro, o cronômetro incrementa ou decrementa a contagem (`count_aux`) dependendo do modo.
- Quando a contagem atinge o limite (zero para regressiva e `time_set` para progressiva), o sinal `timer_expired` é ativado.

### 4. Programação do Tempo de Contagem
O tempo de contagem é programável através das chaves `SW4` e `SW3`, que definem quatro tempos pré-configurados:
- `OFF/OFF`: 30 segundos.
- `OFF/ON` : 1 minuto.
- `ON/OFF` : 2 minutos.
- `ON/ON`  : 5 minutos.

**Lógica:**
- O processo `control_timer` ajusta o tempo de contagem (`time_set`) e atualiza os LEDs (`LEDR`) para refletir o tempo selecionado.
- A seleção é feita com base nos valores das chaves `SW4` e `SW3`.

### 5. Seleção de Memória
As chaves `SW2` `SW1` são usadas para selecionar qual memória será exibida no display:
- `OFF/OFF`: Exibe a contagem atual.
- `OFF/ON` : Exibe o valor salvo na memória 1.
- `ON/OFF` : Exibe o valor salvo na memória 2.
- `ON/ON`  : Exibe o valor salvo na memória 3.

**Lógica:**
- O processo `control_timer` ajusta a contagem exibida (`count`) com base na memória selecionada pelas chaves `SW2` e `SW1`.
- Os LEDs são atualizados para indicar qual memória está sendo exibida.

### 6. Exibição no Display de 7 Segmentos
O valor da contagem é convertido para o formato adequado para ser exibido nos displays de 7 segmentos. O display é atualizado em tempo real para mostrar minutos e segundos:
- `DISPLAY_MIN_TENS` e `DISPLAY_MIN_UNIT` exibem os minutos.
- `DISPLAY_SEC_TENS` e `DISPLAY_SEC_UNIT` exibem os segundos.

**Lógica:**
- O processo `display_process` converte a contagem atual (`count`) para um formato de 7 segmentos utilizando a função `to_7segment`.
- Quando o cronômetro expira (`timer_expired`), todos os segmentos do display piscam para indicar que o tempo terminou.
- O ponto decimal (`DISPLAY_DOT`) pisca a cada segundo enquanto o cronômetro está em execução, proporcionando um indicador visual adicional do funcionamento do cronômetro.

## Resultados e Discussão
O cronômetro foi testado e demonstrou atender aos requisitos especificados. As funcionalidades de contagem progressiva e regressiva, armazenamento de tempos em memória, e exibição correta nos displays de 7 segmentos foram verificadas e funcionaram conforme o esperado.

A implementação utilizando VHDL e a prototipagem na placa DE10-Lite proporcionaram uma excelente plataforma para a construção e testes do cronômetro digital. A precisão da contagem foi garantida pela divisão correta do clock e pelo controle eficiente dos estados do cronômetro.

## Conclusão
O projeto do cronômetro digital foi concluído com sucesso, implementando todas as funcionalidades requeridas. O uso do VHDL e da placa DE10-Lite proporcionou uma excelente plataforma para a prototipagem digital. As funcionalidades adicionais, como armazenamento de tempos em memória e exibição no display de 7 segmentos, foram implementadas e testadas com sucesso.

## Referências
- Documentação da placa DE10-Lite.
- Material didático do curso de Prototipação Digital.
