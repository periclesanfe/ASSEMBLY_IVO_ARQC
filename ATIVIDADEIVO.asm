.data

# MENU OPCOES

option1: .asciiz "\nOpcao 1: Calcular a sequencia de Fibonacci\n"
option2: .asciiz "Opcao 2: Converter Fahrenheit para Celsius\n"
option3: .asciiz "Opcao 3: Calcular o enesimo numero par\n"
option4: .asciiz "Opcao 4: Encerrar o programa\n"
input_prompt: .asciiz "\nDigite sua escolha (1, 2, 3 ou 4): "
invalid_choice: .asciiz "Escolha invalida. Tente novamente.\n"

# FENESIMO FIBONACCI

space: .asciiz " "  # String representando espaco em branco
prompt_fibonacci: .asciiz "Digite o valor de N para calcular o enesimo numero da sequencia de Fibonacci: "
out_fibonacci: .asciiz "\nO enesimo namero da sequencia de Fibonacci e: "

# CONVERSAO F -> C

prompt_far: .asciiz "Digite a temperatura em Fahrenheit: "
decimal: .float 100.0
out_far: .asciiz "\nA temperatura em Celcios e: "

# ENESIMO PAR
msg_par: .asciiz "Digite o enenesimo par que deseja: "
result_par: .asciiz "\nO enesimo numero par referente e: "

# ENCERRAR PROGRAMA
prompt_exit: .asciiz "Da 10 pra gente Ivo!!\nEncerrando..."

.text
.globl main

main:
    # OUTPUT MENU OPCOES
    
    li $v0, 4             
    la $a0, option1 # Imprimi opcao 1 
    syscall
    
    li $v0, 4             
    la $a0, option2   # Imprimi opcao 2    
    syscall
 
    li $v0, 4             
    la $a0, option3  # Imprimi opcao 3     
    syscall

    li $v0, 4             
    la $a0, input_prompt  # Imprimi mensagem imput
    syscall

    li $v0, 5  # Ler a escolha do usuario       
    syscall
    move $t0, $v0  # move para $t0

    # VALIDACAO DE ESCOLHA
    
    # Verificar se o numero e menor que 1
    li $t1, 1  # $t1 = 1
    slt $t2, $t0, $t1  # $t2 = 1 se $t0 < $t1, caso contrario $t2 = 0
    
    # Se $t2=0
    beqz $t2, number_in_range

   # Se $t2=1:
   beq $t2, 1, invalid

number_valid:
    # SWITCH DE FUNCOES
    beq $t0, 1, fibonacci_option    # $t0=1 -> fibonacci_option
    beq $t0, 2, fahrenheit_option   # $t0=2 -> fahrenheit_option
    beq $t0, 3, par_option          # $t0=3 -> par_option
    beq $t0, 4, exit_program         # $t0=4 -> exit_program

invalid:
    li $v0, 4
    la $a0, invalid_choice # Imprimi escolha invalida
    syscall

    j main # Chama funcao Main
      
number_in_range:
    # Verificar se o numero e maior que 4
    li $t1, 4          
    sgt $t2, $t0, $t1  # $t2 = 1 se $t0 > 4

    # Se $t2=0:
    beqz $t2, number_valid

    # Se $t2=1:
    beq $t2, 1, invalid

fibonacci:
    addiu $sp, $sp, -12      # Alocar espaco para os registradores $s0, $s1 e $s2
    sw $ra, 0($sp)           # Salvar o endereco de retorno
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
    move $v1, $s1            # Move o valor do enesimo numero em $v1

    lw $ra, 0($sp)           # Restaurar o endereco de retorno
    lw $s0, 4($sp)           # Restaurar $s0
    lw $s1, 8($sp)           # Restaurar $s1
    addiu $sp, $sp, 12       # Liberar o espaco alocado

    jr $ra                   # Retornar $ra 

fibonacci_option:
    # FIBONACCI_MAIN
    
    li $v0, 4
    la $a0, prompt_fibonacci # Imprimi Pedindo Enesimo Fibonacci
    syscall

    li $v0, 5 # Recebe Posicao de Enesimo
    syscall
    move $a0, $v0 # Move para $a0

    jal fibonacci  # Chama Funcao Fibonacci

    li $v0, 4
    la $a0, out_fibonacci # Imprimi Mensagem de Resultado
    syscall

    move $a0, $v1 # move valor do registrador de retorno para $a0
    li $v0, 1 # Imprimi valor de 
    syscall

    j main   # Chama Main

fahrenheit_option:
    li $v0, 4
    la $a0, prompt_far # Pede valor em Fahrenheit
    syscall

    li $v0, 6  # Ler valor Float do usuário
    syscall

    # Converte para Celsius usando a formula C = (F - 32) * 5/9
    li $t0, 5 		# $t0=5
    mtc1 $t0, $f1 	# move $t0 -> $f1
    cvt.s.w $f1, $f1 	# converte para precisao de uma casa decimal
    li $t0, 9 		# $t0=5
    mtc1 $t0, $f2 	# move $t0->$f2
    cvt.s.w $f2, $f2 	# converte para precisao de uma casa decimal
    div.s $f1, $f1, $f2 # divide $f2/$f1 e guarda em $f1
    li $t0, 32		# $t0=32
    mtc1 $t0, $f2	# move $t0 -> $f2
    cvt.s.w $f2, $f2	# converte para precisao de uma casa decimal
    sub.s $f0, $f0, $f2	# subtrai valor informado pelo usuario por $f2 32 e guarda em $f0
    mul.s $f12, $f0, $f1# multiplica $f0*$f1 e guarda em $f12

    # Arredonda o resultado para duas casas decimais
    lwc1   $f2,decimal 
    mul.s  $f12,$f12,$f2 # multiplica dois valores float e guarda em $f12
    round.w.s  $f12,$f12 # arredonda para inteiro mais proximo
    cvt.s.w  $f12,$f12 	 # converte novamente para float
    div.s  $f12,$f12,$f2 # divide por 100.0 e armazena em $f12

    li $v0, 4
    la $a0, out_far # Imprimi a mensagem de resultado
    syscall

    li $v0, 2 # Imprime o valor do resultado
    syscall
    
    j main # Voltar para Main
 
par_option:
    # ENESIMO PAR
    
    li $v0, 4 
    la $a0, msg_par # Imprimi prompt Par
    syscall
    
    li $v0, 5 # Recebe o valor Enesimo do usuario
    syscall
    move $t0, $v0 # Move para $t0

    sll $t0, $t0, 1 # Multiplica por 2 o valor descobrir Enesimo par

    li $v0, 4 
    la $a0, result_par # Imprimir mensagem resultado par
    syscall
    
    li $v0, 1 # Imprimir inteiro
    move $a0, $t0 # Move $t0 para $a0
    syscall

    j main  # Voltar para Main
    
exit_program:

    li $v0, 4
    la $a0, prompt_exit # Imprimi mensagem de saida
    syscall

    li $v0, 10    # Encerrar Programa
    syscall
       
