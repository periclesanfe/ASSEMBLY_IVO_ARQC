.data
option1: .asciiz "\nOpção 1: Calcular a sequência de Fibonacci\n"
option2: .asciiz "Opção 2: Converter Fahrenheit para Celsius\n"
option3: .asciiz "Opção 3: Calcular o enésimo número par\n"
option4: .asciiz "Opção 4: Encerrar o programa\n"
input_prompt: .asciiz "\nDigite sua escolha (1, 2, 3 ou 4): "
invalid_choice: .asciiz "Escolha inválida. Tente novamente.\n"
space: .asciiz " "  # String representando espaço em branco
func2: .asciiz "Opção 2 escolhida\n"
final: .asciiz "Avengers Assembly!"

# Mensagens para a parte do código que realiza a função do Enésimo Par:
previously_msg: .asciiz "Digite o enénesimo par que desejas: "
result_msg: .asciiz "Esse é o número par correspondente: "
zero_msg: .asciiz "Zero é par ou ímpar?"
 
prompt_fibonacci: .asciiz "Digite o valor de N para calcular o enésimo número da sequência de Fibonacci: "
sequence_label: .asciiz "O enésimo número da sequência de Fibonacci é: "

.text
.globl main

main:
    # Mostrar as opções para o usuário
    # Imprimi opção 1
    li $v0, 4             
    la $a0, option1       
    syscall

    # Imprimi opção 2
    li $v0, 4             
    la $a0, option2       
    syscall

    # Imprimi opção 3
    li $v0, 4             # Código do serviço 4: imprimir string
    la $a0, option3       # Carregar o endereço da string option1
    syscall

    # Ler a escolha do usuário
    li $v0, 4             
    la $a0, input_prompt  
    syscall

    # Ler a escolha do usuário
    li $v0, 5             
    syscall
    move $t0, $v0         

    # Verificar a escolha do usuário
    
    # Verificar se o número é menor que 1
    li $t1, 1          # $t1 = 1
    slt $t2, $t0, $t1  # $t2 = 1 se $t0 < $t1, caso contrário $t2 = 0
    
    # Se o valor de $t2 é 0:
    beqz $t2, number_in_range

   # Se o valor de $t2 for 1:
   beq $t2, 1, invalid

number_valid:
    # Código para cada escolha
    beq $t0, 1, fibonacci_option    # Se a escolha for 1, ir para fibonacci_option
    beq $t0, 2, fahrenheit_option   # Se a escolha for 2, ir para fahrenheit_option
    beq $t0, 3, par_option          # Se a escolha for 3, ir para par_option
    beq $t0, 4, exit_program         # Se a escolha for 4, fechar o programa

invalid:
    # Escolha inválida
    li $v0, 4
    la $a0, invalid_choice
    syscall

    # Voltar para o início para receber uma nova escolha
    j main    
      
number_in_range:
    # Verificar se o número é maior que 4
    li $t1, 4          
    sgt $t2, $t0, $t1  # $t2 = 1 se $t0 > $t1

    # Se o valor de $t2 = 0:
    beqz $t2, number_valid

    # Se o valor de $t2 = 1:
    beq $t2, 1, invalid

fibonacci:
    addiu $sp, $sp, -12      # Alocar espaço para os registradores $s0, $s1 e $s2
    sw $ra, 0($sp)           # Salvar o endereço de retorno
    sw $s0, 4($sp)           # Salvar $s0
    sw $s1, 8($sp)           # Salvar $s1

    move $s0, $a0            # $s0 = valor de N

    li $s1, 0                # $s1 = primeiro termo
    li $s2, 1                # $s2 = segundo termo

    bltz $s0, fibonacci_exit # Se N < 0, terminar
    beqz $s0, fibonacci_exit # Se N = 0, terminar

fibonacci_loop:
    add $s3, $s1, $s2        # $s3 = primeiro termo + segundo termo

    move $s1, $s2            # Atualizar primeiro termo
    move $s2, $s3            # Atualizar segundo termo

    addi $s0, $s0, -1        # Decrementar N
    bgtz $s0, fibonacci_loop # Se N > 0, repetir o loop

fibonacci_exit:
    move $v1, $s1            # Colocar o valor do enésimo número em $v1

    lw $ra, 0($sp)           # Restaurar o endereço de retorno
    lw $s0, 4($sp)           # Restaurar $s0
    lw $s1, 8($sp)           # Restaurar $s1
    addiu $sp, $sp, 12       # Liberar o espaço alocado

    jr $ra                   # Retornar

fibonacci_option:
    # Solicitar o valor de N para calcular o enésimo número
    li $v0, 4
    la $a0, prompt_fibonacci
    syscall

    # Ler o valor de N digitado pelo usuário
    li $v0, 5
    syscall
    move $a0, $v0

    jal fibonacci            # Chamar a função fibonacci para calcular o enésimo número

    # Imprimir a mensagem "O enésimo número da sequência de Fibonacci é:"
    li $v0, 4
    la $a0, sequence_label
    syscall

    # Imprimir o valor do enésimo número
    move $a0, $v1 # move valor de v1 para $a0
    li $v0, 1
    syscall

    j main               # Voltar para o início para receber uma nova escolha

par_option: # Código para a opção 3: calcular o enésimo número par
    
    # Aqui é o código para mensagem que será exibida anteriormente ao n° digitado
    li $v0, 4 # Imprimir string
    la $a0, previously_msg # Atribiu o valor da mensagem que deve ser mostrada antes do n° digitado (anteriormente - previously)
    syscall
    
    # Aqui é o código para absorver o n° digitado
    li $v0, 5 # Ler inteiro
    syscall
    move $t0, $v0  # Armazena o número em $t0

    # Verificar se o número é zero (Caso especifíco, já que não se sabe na matemática se 0 é ímpar ou par)
    beqz $t0, zero_case # Aqui temos o famoso "IF", se igual a 0, mostre o zero_case, definido lá em cima no .data, caso não, continua:
    
    # Para descobrir o par de um número, basta multiplicar o número por 2
    sll $t0, $t0, 1 # Aqui ocorre a multiplicação, mas por deslocamento, não necessariamente por operação, deslocando uma casa para a esquerda, o valor original dobra (logo *2)
    
    # Código para exibir a mensagem antes do resultado(resultado - result)
    li $v0, 4 # Imprimir string
    la $a0, result_msg # Aqui transferimos o valor de result_msg para o $a0 e printamos na tela a mensagem
    syscall
    
    # Código para exibir o resultado de qual é o enésimo par
    li $v0, 1
    move $a0, $t0 # Pega o valor de $t0 e coloca em $a0 para poder printar na tela como inteiro.
    syscall

 	j main               # Voltar para o início para receber uma nova escolha  

    zero_case:
    # Códdigo para exibir a mensagem para o número zero, definida anteriormente no .data
    li $v0, 4 # Imprimir string
    la $a0, zero_msg # Pega o valor de zero_msg e coloca em $a0 para poder printar na tela como string.
    syscall
    
	j main               # Voltar para o início para receber uma nova escolha
    

    
fahrenheit_option:
    li $v0, 4             # Código do serviço 4: imprimir string
    la $a0, func2       # Carregar o endereço da string option1
    syscall
    # Código para a opção 3: calcular o enésimo número par
    # Implemente o código para calcular o enésimo número par aqui

    j main               # Voltar para o início para receber uma nova escolha
 
exit_program:
    li $v0, 4             # Código do serviço 4: imprimir string
    la $a0, final       # Carregar o endereço da string option1
    syscall
    
    li $v0, 10    # Código do serviço 10: encerrar o programa
    syscall
