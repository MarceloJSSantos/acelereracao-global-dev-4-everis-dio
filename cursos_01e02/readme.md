# **<u>Cursos: "Linux: A introdução ao sistema operacional" e "Shell script - Manipulando Arquivos"</u>**

------

 **sites interessantes**

- https://guiafoca.org// (material extenso sobre Linux)
- https://bellard.org/ (Diversas ferramenas, entre tanats, a JSLinux (simula linux no navegador)

Guia + completo

- [Guia_Comandos_LINUX.pdf](./arquivos/Guia_Comandos_LINUX.pdf) - por: [Bruno Andrade (GNU/Linux - Brasil](https://www.facebook.com/gnulinuxbr))



**copiar/colar**

- MobaXTerm

  - Shift  + Delete
  - Shift + Insert

- Terminal

  - Ctrl + Shift + C
  - Ctrl + Shift + V



**ATALHOS DE TERMINAL**

- Ctrl + Alt + T: Acessa o terminal

- Ctrl+C: Cancela/para a execução de comando atual

- Ctrl+Z: Pausa a execução de comando atual

- Ctrl+D: Sai do terminal (equivale a ``exit``)

- Ctrl+W: Apaga uma palavra na linha atual

- Ctrl+U: Apaga a linha inteira

- Ctrl+R: Busca um comando recente

- Ctrl + L: Limpa a tela (equivale a ``clear``)

  

**COMANDOS DE TERMINAL**

- Estrutura comando/parâmetros

  \<comando> -[parâmetro letra] 

  \<comando> --[parâmetro por extenso]

  ```bash
  ls -a
  ls -all
  ```

- chamar o manual dos comandos
	
	- $ man \<comando>
	
	  nota:  para sair do manual digitamos 'h' ou 'q'
	
	  ```bash
	  man ls
	  ```
	
	- $ \<comando> --help (na língua da instalação do SO, mas alguns comandos pode não estar disponíveis)
	
	  ```bash
	  ls --help
	  ```

- listar um históricos de comandos utilizados recentemente
	
	```bash
	history
	history -c	#(apaga o histórico)
	```
	
- executar o último comando novamente
	
	```bash
	!!
	```
	
- para autopreenchimento do nome de uma pasta ou arquivo comece a digitar + Tab
	
- para nomes de arquivo ou pastas com mais de uma palavra, usar  aspas simples ''
	
- mostrar o caminho atual
	
	```bash
	pwd 
	```

- mostrar os arquivos e pastas do caminho atual

  ```bash
  ls
  ```
  ```
  Desktop      Downloads   Modelos	Público		snap
  Documentos   Imagens     Música		Vídeos
  ```

  - mostra só as pastas

    ```bash
    dir
    ```

  - mostrar as pastas e arquivos de um caminho específico

    $ ls \<caminho da pasta>

    ```bash
    ls Desktop
    ```

  - parâmetros

    - ls -l (mostrar detalhes das pastas e arquivos)
    - ls -F (coloca um '/' na frente dos diretórios)
    - ls -a (mostra arquivos e pastas ocultos ('.' na frente) - azul: diretórios / branco: arquivos)
    - ls -s (mostra os arquivos e pastas c/ tamanho alocado por bloco)

- lista árvore de pastas, subpastas e arquivos

  ```bash
  tree
  ```

  ```bash
  .
  └── curso linux
      ├── arquivo_vazio
      ├── arquivo_vazio_2
      └── pasta_cp_mv
  ```

- Entrar em pasta específica
  

$ cd \<caminho da pasta>

  ```bash
  cd Desktop
  ```

  -  variações
    - cd .. (p/ pasta acima da atual)
    - cd / (p/ o diretório raiz do SO)
      - cd ~ (p/ o diretório pessoal)
    
- criar pasta
	
	$ mkdir \<nome da pasta>
	
	```bash
	mkdir Documentos/'curso linux'
	```
	
- criar arquivo vazio s/conteúdo

  $ touch \<nome do arquivo>

  ```bash
  touch 'curso linux'/arquivo_vazio
  ```
  - atualizar metadados de arquivo
    - $ touch -a (altera a hora de acesso e cria um novo arquivo)
    - $ touch -m (altera a hora de modificação e cria um novo arquivo)
    - $ touch -c (altera a hora de acesso s/ criar um novo arquivo)
    - $ touch -t YYYYMMDDhhmm.ss (altera a hora de acesso e modificação para horário específico)

- copiar arquivo ou pasta
  
  $ cp \<nome do item> \<caminho para onde vai a copia>
  
  ```sh
  cp arq.txt /home/Documentos
  ```

  - parâmetros
    - $ cp -i (confirma a substituição se já existir)
    - $ cp -v (copia e exibe detalhadamente os arquivos copiados em uma pasta)
    - $ cp -l (cria hard link)
    - $ cp -s (cria link, não um novo arquivo)
    - $ cp -u (copia)
    - $ cp -r (copia diretório inteiro (inclusive o diretório)
    - $ cp -r . <destino> (copia diretório inteiro (inclusive o diretório)
      - $ cp -v <arq1> <arq2> <arqn> <destino>
    
- renomear arquivo ou pasta

  $ mv \<nome item a ser renomeado> \<novo nome do item>

  ```bash
  mv arquivo_vazio arquivo_vazio_2
  ```

- mover arquivo ou pasta

  $ mv \<nome item a ser movido> \<caminho para onde o item var ser movido>

  ```bash
  # move o arquivo para pasta hierarquicamente superior ('..') a atual
  mv arquivo_vazio_2 ..
  ```

  - parâmetros
    - mv -i (confirma antes de substituir)
    - mv -n (não substitui)
    - mv -b (substitui pelo backup)
    - mv -u (substitui só se arquivo de destino for mais antigo ou não existir)

- remover/deletar pasta
  
  $ rmdir \<nome da pasta> (vazios)

  $ rmdir -rf \<nome da pasta> (não vazios)
  
  ```bash
  rmdir 'curso linux'/teste
  # rmdir: falhou em remover 'curso linux/teste': Diretório não vazio
rmdir -rf 'curso linux'/teste
  ```
  
- remover arquivos
	
	$ rm \<nome do arquivo>
	
	$ rm -r * (apaga todos os arquivos de dentro do diretório)
	
	```bash
	rm 'curso linux'/teste/arq.txt 'curso linux'/teste/arq_4.txt
	rm -r 'curso linux'/*
	```
	
- visualizar o conteúdo de um arquivo

  - $ cat \<nome do arquivo> (ordem normal do texto)

    ```bash
    cat 'curso linux'/arq1.txt
    ```

  - $ tac \<nome do arquivo> (ordem inversa do texto)

    ```bash
    tac 'curso linux'/arq1.txt
    ```

  - $ head \<nome do arquvio> (10 primeiras linhas)

    ```bash
    head 'curso linux'/arq1.txt
    ```

  - $ tail \<nome do arquvio> (10 últimas linhas)

    ```bash
    tail 'curso linux'/arq1.txt
    ```

- criar novo arquivo baseado na saída de outro comando

  ```bash
  $ tree > arq_tree.txt
  ```

- adicionar saída de outro comando ao final de um arquivo (append)

  ```bash
  echo '123' >> arq_tree
  
  cat arq1.txt >> arq2.txt
  ```

- mostrar calendário
	
	nota: no Lubuntu foi preciso instalar ``sudo apt install ncal``
	
	- $ cal					           (só mês atual)
	- $ cal -m \<mês 1 a 12>(mês específico)
	- $ cal \<ano>		           (todo ano)
	- $ cal -m \<mês 1 a 12> \<ano> (mês e ano)
	- $ cal > calendario.txt (cria um arquivo com o conteúdo da saída do comando)

- destacando termo em arquivo
	
	$ grep \<termo> \<arquivo>
	
	```bash
	grep 'casa' 'curso linux'/arq1.txt
	```
	
	- parâmetros
	  - $ grep - c (retorna o número de ocorrências do termo)
	  - $ grep - n (retorna o termo com o número da linha em que aparece)
	
- juntando comandos ('|')
  
  $ tail \<nome arquivo> | grep \<termo>
  
  ```sh
  tail 'curso linux'/arq1.txt | grep 'casa'
  ```

- ler arquivo por página
	
	$ cat \<nome arquivo> | more
	
	$ cat \<nome arquivo> | less
	
	```bash
	cat curso\ linux/arq1.txt | more
	
	cat curso\ linux/arq1.txt | less # para sair do modo 'q'
	```

- executar comando em conjunto
	
	$ ... & ...		(c/ pausa na saída)
	
	$ ... && ...	(s/ pausa na saída)
	
	```bash
	ls -l . & tree 'curso linux'
mkdir dir1 && cd dir1 # cria pasta e entra nela
	```
	
- exibe qual o tipo de arquivo ou diretório
	
	$ file \<nome do item>
	
	```bash
	file arq1.txt
	# todos arquivos e pastas da pasta atual
	file *
	```
	
	```
	curso linux/arq1.txt: UTF-8 Unicode text
	curso linux/arq_tree: UTF-8 Unicode text
	curso linux/dir25:    directory
	```

- saber o que um determinado comando faz
	
	$ whatis \<comando>
	
	```bash
	whatis file tree cat
	```
	
	```
	file (1)             - determine file type
	tree (1)             - list contents of directories in a tree-like format.
	cat (1)              - concatenate files and print on the standard output
	```
	
- mostra o local do comando e local de seu manual

  $ whereis \<comando>

  $ which \<comando> 	(só o caminho do programa)

  ```bash
  whereis tree
  which tree
  ```

- procurar arquivo por nome retorna o caminho

  $ find \<pasta> \<pelo que> \<termo>

  - parâmetros
    - $ find ~ -name "termo" (procura arquivo e diretório pelo nome)
    - $ find ./ -type d -name "?ermo*" (procura diretório pelo nome usando coringas (?/\*) no termo)
    - $ find ./ -type f -name "?ermo*" (procura arquivo e diretório oculto pelo nome usando coringas (?/\*) no termo)

  ```bash
  find ./'curso linux' -name "*.txt"
  ```

  ```
  ./curso linux/arq_q.txt
  ./curso linux/arq1.txt
  ```

- variáveis de ambiente

  - mostra as variáveis

    ```bash
    # todas
    env
    
    #específica
    printenv SHELL
    ```
    
  - cria e define

    $ export \<nome>=\<valor>

    ```bash
    export MEUNOME="Marcelo"
    ```

  - encontrar por valor ou variável

    ```bash
    env | grep -n lubuntu
    ```

    ```
    7:LOGNAME=lubuntu
    10:HOME=/home/lubuntu
    20:USER=lubuntu
    ```

  - uso

    ```bash
    echo "Meu nome é $MEUNOME"
    ```

  - destrói

    ```bash
    unset MEUNOME
    ```

- dar um apelido para comando

  - criar o apelido

    $ alias var=<comando>

    ```bash
    # cria um apelido do comando history que retorne os últimos 10 comandosbash
    alias hh='history 10'
    # executa o comando
    hh
    ```

    nota: para substituir o comando de um apelido é só "settar" novamente

  - verificar os apelido criados

    ```bash
  alias
    ```

    ```
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias hh='ls'
    alias l='ls -CF'
    alias la='ls -A'
    alias ll='ls -alF'
    alias ls='ls --color=auto'
    ```

  - excluir um apelido

    - específico

      $ unalias <nome do apelido>

    - todos

      $ unalias -a

    ```bash
  unalias hh
    ```

    ```
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias l='ls -CF'
    alias la='ls -A'
    alias ll='ls -alF'
    alias ls='ls --color=auto'
    ```

- exibir um arquivo com o nr das linhas (não conta as linhas em branco)

  $ nl \<nome do arquivo>

  - mostra a quantidade de linhas/palavras do arquivo
       - $ wc -l  \<nome do arquivo>	(nr. de linhas)
       - $ wc -w \<nome do arquivo>	(nr. de palavras)
       - $ wc -m \<nome do arquivo>	(nr. de caracteres)
    - $ wc -c \<nome do arquivo>	  (nr. de bytes)

    ```sh
    #retorna a quantidade de:
    #-linhas
    #-palavras
    #-caracteres
    #-bytes
    wc -l -w -m -c 'curso linux'/arq1.txt
    ```

    ```
    37  52 220 245 curso linux/arq1.txt   
    ```

- classifica o conteúdo de um arquivo (não modifica)
	
	$ sort \<nome arquivo>
	
	```bash
	# sem modificar
	sort arq_a.txt
	
	# cria um novo arquivo classificado
	sort -r arq_a.txt arq_classificado.txt
	```
	
	- parâmetros
	  - $ sort -n \<nome arquivo> (classifica considerando valores numéricos)
	  - $ sort -r \<nome arquivo> (ordem decrescente)
  - $ sort -nr \<nome arquivo> (numéricos decrescente)
	
- mostra diferença entre arquivos
	
	$ diff \<nome arquivo> \<nome arquivo>
	
- mostra uma sequencia de números
	
	$ seq 1 100
	
- mostra o tempo que um processo leva
	
	$ time \<comando>
	
	```bash
	time tree
	```
	
	```
	
	real    0m0,003s
	user    0m0,003s
	sys     0m0,000s
	```
	
- mostra o tempo que o sistema está rodando
  

$ uptime

- mostra todas as reinicializações
  

$ last reboot

- logout
  

$ logout

- desligar a maquina
	
	$ sudo init 0
	
	$ sudo telinit 0
	
	$ sudo halt	(pede uma senha para desligar)
	
	```bash
	sudo halt
	```



**EDIÇÃO DE ARQUIVOS**

- Editor de arquivos padrão do Ubuntu
	
	$ nano \<nome do arquivo>
	
	nota para criar um novo arquivo já editando é só abrir um arquivo não existente, editá-lo e salvá-lo.
	
	```bash
	nano dir25/arq.txt
	```
	
- comando de menu do nano

  - ^ = Ctrl

    - Ctrl + G: Obter ajuda

    - Ctrl + X: Sair do Editor

    - Ctrl + O: Gravar

    - Ctrl + R: Ler o arquivo

      nota: ao indicar o caminho do arquivo c/ espaço não devemos colocar entre aspas simples ('')

    - Ctrl + U: Colar o texto

    -  Ctrl + W: Buscar texto

    - Ctrl + \: Substituir texto

  - M = Alt

    - Alt + J: Justificar o texto
    - Alt + U: Desfaz a ação
    - Alt + E: Refazer a ação
    - Alt + A: Marcar toda a linha
    - Alt + 6: Copiar seleção ou toda a linha (se não houver nada selecionado)



- Manipulação de Arquivo (não modifica o arquivo)
  - retorna o arquivo sem a 1ª linha 

    $ sed '<numero da linha>d' <nome do arquivo>

    ```
    sed '1d' arq1.txt
    ```

  - substitui "string1" com a "string2" no arquivo

    $ sed 's/string1/string2/g' <nome do arquivo>

    ```
    sed 's/casa/naipe/g' arq1.txt
    ```

  - Remove todas as linhas em branco

    $ sed '/^$/d' <nome do arquivo>

  - Exclui comentários e linhas em branco

    $ sed '/ *#/d; /^$/d' <nome do arquivo>

  - Exibi somente as linhas que contêm a “string”

    $ sed -n '/string/p' <nome do arquivo>

    

**PRINCIPAIS DIRETÓRIOS**

- /bin/: binários principais dos usuários
- /boot/: arquivos do sistema e boot
- /dev/: arquivos de dispositivo
- /etc/: arquivos de configuração do sistema
- /home/: diretório dos usuários comuns do sistema
- /lib/: bibliotecas essenciais do sistema e os módulos do kernel
- /media/: diretório de montagem de dispositivo
- /mnt/: diretório de montagem de dispositivo, como o 'media'
- /opt/: diretório de instalações de progamas não-oficiais e por conta do usuário
- /sbin/: arquivos executáveis que representam comandos administrativos. Ex. shutdow
- /srv/: diretório para dados de serviços fornecidos pelo sistema
- /tmp/	- arquivos temporários
- /usr/	- segunda hierarquia do sistema, onde ficam os usuários comuns do sistema e programas
- /var/	- arquivos variáveis gerados pelos programas do sistema. Ex. log, impressoras, email e cache
- /root/	- arquivos do usuário root
  - $ sudo su p/mudar o usuário root
- /proc/	- diretório virtual controlado pelo kernel



**COMANDOS DE REDE**

- informações sobre dispositivos de rede

  ```bash
  ifconfig
  ```

  nota: se ainda não estiver instalado

  ```bash
  sudo apt install net-tools
  ```

- descobrir o nome do nosso computador na rede
	- $ hostname
	- $ hostname -I	(retorna o IPv4)
	- $ hostname -i	(retorna o endereço de loopback (localhost))

- informações de como estamos logado
	- $ who           (retorna o nome de usuário e quando entramos na rede)
	- $ whoami	(retorna o nome de usuário)
	- $ w	            (dados mais completos sobre usuário)

- verificar se um host está respondendo
	
	$ ping <host>
	
	```bash
	ping www.google.com
	# receberá 4 pacotes e parará de "ouvir"
	ping www.google.com -w 4
	```
	
- informações sobre o DNS
  
  $ dig www.google.com

  $ dig www.google.com +short
  
- traçar rota até a um host específico
  

$ traceroute www.google.com

nota: caso não instalado, opções:

  -  $ sudo apt install inetutils-traceroute
- $ sudo apt install traceroute
  
- informações sobre o usuário logado em nossa máquina
	
	$ finger (caso necessite instalar ``sudo apt install finger```)
	
- mostra informações de roteamento
	
	$ route -n



**USUÁRIOS E CONTAS**

- adicionar usuário
	
	$ sudo adduser \<nome do usuario>
	
	```bash
	sudo adduser user_teste
	```
	
- trocar usuário
	
	$ sudo su <nome usuário>
	
	$ sudo su  (troca para root)
	
	```bash
	sudo su user_teste
	```
	
- trocar senha
	

$ sudo passwd \<nome usuario>
	
- listar todos os usuários do sistema
	
	$ lastlog
	
	```bash
	# lista de usuários logados nos últimos 10 dias
	lastlog -t 10
	```

- lista as entradas e saídas de um usuário
	
	$ last	(usuário atual)
	
	$ last \<nome usuário>	(usuário específico)
	
	```bash
last user_teste
	```

- mostrar usuário logado atualmente no sistema
	
	$ logname
	
- mostrar id do usuário e todos os grupos desse usuário

  $ id	

- mostrar arquivo /etc/passwd

  $ cat /etc/passwd

- exibir todos os grupos do sistema

  $ cat /etc/group

- exibir todos os grupos do usuário

  $ groups

- criar grupo

  $ sudo addgroup \<nomegrupo>

- remover grupo

  $ sudo groupdel \<nomegrupo>

- adicionar usuário a um grupo

  $ sudo adduser \<usuario> \<grupo>

  $ sudo gpasswd -a \<usuario> \<grupo>

- remover usuário de um grupo

  $ sudo gpasswd -d \<usuario> \<grupo>	

- remover um usuário e a pasta do usuário

  $ userdel -r \<nome usuario>



**PERMISSÕES (arquivos e pastas)**

r - read (leitura)

w - write (escrita)

x - eXecution (execução)



- posição

  | posição | permissão                           |
  | ------- | ----------------------------------- |
  | 1       | se é d = diretório ou '-' = arquivo |
  | 2 a 4   | permissões do dono                  |
  | 5 a 7   | permissões do grupo                 |
  | 8  a 10 | permissões de outros usuários       |

  

- verifica as permissões em arquivos/diretórios
	
	```bash
	ls -lh
	```
	
	```bash
	-rwxrw-r-- 1 lubuntu lubuntu   27 mar 30 22:22 app.sh
	-rw-rw-r-- 1 lubuntu lubuntu  245 mar 29 20:13 arq1.txt
	-rw-rw-r-- 1 lubuntu lubuntu    0 mar 30 14:21 arq_q.txt
	-rw-rw-r-- 1 lubuntu lubuntu  111 mar 29 18:58 arq_tree
	drwxrwxr-x 2 lubuntu lubuntu 4,0K mar 30 15:04 dir25
	```

- mudar a permissão de um arquivo/diretório
	
	$ chmod \<cod octal> \<nome do arquivo ou pasta>
	
	modo octal 
	r = 4
	w = 2
	x = 1
	rw = 6 (soma rw)
	rwx = 7 (soma rwx)
	
	```
	chmod 764 app.sh
	```



**COMPACTAÇÃO**

- gzip

  O arquivo (ou conjunto de arquivos) é substituído por um arquivo compactado (para cada arquivo) com a extensão *.gz*. Entretanto, são mantidos o dono, as permissões e as datas de modificação do arquivo.

  - compactar

    - $ gzip \<nome arquivo ou pasta> (taxa de compactação normal)
    - $ gzip -9 \<nome arquivo ou pasta><taxa de compactacao> (taxa de compactação máxima)

    ```
    gzip -9 arq_gzip/*
    ```

    ```
    .
    ├── arq
    ├── arq_a.txt
    ├── arq_b.txt
    ├── arq_gzip
    │   ├── arq_a.txt.gz
    │   ├── arq_b.txt.gz
    │   ├── arq.gz
    │   └── arq_o.gz
    └── arq_o
    ```

    - parâmetros
      - **-c** : grava o resultado na saída padrão e mantém o arquivo original inalterado.
      - **-d** : descompacta (igual ao comando *gunzip*).
      - **-l** : lista informações sobre os arquivos compactados/descompactados.
      - **-r** : compacta/descompacta recursivamente (navega a estrutura de diretórios recursivamente).
      - **-t** : verifica a integridade do arquivo compactado.

  - descompactar
    
  
  $ gunzip \<arquivo gz>
  
    $ gzip -d \<arquivo gz>



- zip

  - compactar usando zip
    
  
  $ zip \<nome do arquivo zipado> \<lista de arquivos a ser zipado>]
  
    ```bash
    zip arq_zip/arqs.zip arq_zip/*
    ```
  
   - mesmo após já criado o zip podemos adicionar outros arquivos
    
       ```bash
       zip -u arq_zip/arqs.zip new_arq.txt
     ```
    
  - descompactar
  	
  	$ unzip \<arquivo zip> (todos os arquivos)
  	
  	```
  	unzip arq_zip/arqs.zip
  	```
  	
  	$ unzip \<arquivo zip> \<arquivo especifico> (arquivo específico)
  	
  	```
  	unzip arq_zip/arqs.zip new_arq.txt
  	```
  	
  	$ unzip -r \<arquivo zip> (todos os arquivos e subpastas)
  	
  	```
  	unzip -r arq_zip/arqs.zip
  	```



- bzip2 (mais atual que os anteriores)

  O arquivo (ou conjunto de arquivos) é substituído por um arquivo compactado (para cada arquivo) com a extensão *.bz2* (igual gzip)

  - compactar
    
    $ bzip2 \<arquivo ou pasta ou lista a ser compactados>
    
  - descompactar
  	
  	$ bzip2 -d \<arquivo bz2>



- rar

  Necessita ser instalado ``sudo apt install rar``

  - compactar
  	
  	$ rar a \<arquivo rar> \<arquivos ou pastas a ser compactado>
  	
  	nota: 'a' é um comando do comando 'rar', e não um parâmetro, por isso não é '-a'
  	
  - descompactar
  	
  	$ rar x \<arquivo rar>



**ARQUIVADORES**

- arquivar (conjunto de arquivos)

  $ tar -cf \<arquivo tar> \<arquivos a ser arquivado>
  nota: após arquivarmos podemos compactar esse conjunto de arquivos

- desarquivar
	
	$ tar -jx \<arquivo tar> ou \<arquivo tar gz> (se compactado)
	
- parâmetros
	- **-c** : cria um novo arquivo *tar*.
	- **-j** ou **−−bzip2** : compacta/descompacta os arquivos usando bzip2
	- **-J** ou **−−xz** : descompacta os arquivos .xz e .lzma.
	- **-t** : lista o conteúdo do arquivo *tar*.
	- **-x** : extrai o conteúdo do arquivo *tar*.
	- **-v** : mostra mensagens.
	- **-f arquivo** : define o nome do arquivo *tar*.
	- **-z** ou **−−gzip** ou **−−gunzip** : compacta/descompacta os arquivos usando gzip**/**gunzip
	- **-Z** ou **−−compress** ou **−−uncompress** : compacta/descompacta os arquivos usando **compress**.
	- **-?, −−help** : mostra as opções do comando.
	- **−−version** : mostra informações sobre o aplicativo.



**GERENCIAMENTO DE PACORTES**

sites de pacotes

- pkgs.org

- rpm.pbone.net



**Debian (Ubuntu, Linux Mint, etc.)**

- apt

  - instalação
    
  
  $ sudo apt install \<pacote>
  
  - atualizar
  	
  	$ sudo apt upgrade \<pacote>
  	
  - remover
  	
  	$ sudo apt remove \<pacote>
  	
  - atualizar o sistema junto com os pacotes
  	
  	$ sudo apt update && apt upgrade
  	
  - Verifica se as resoluções das dependências estão corretas.
  	
  	$ sudo apt-get check
  	
  - Limpa o cache de pacotes baixados
  	
  	$ sudo apt-get clean
  	
- Retorna a lista de pacotes que corresponde à série ‘pacotes’
  
    sudo apt-cache search searched-package



- dplg (pacotes .deb baixados)
  - instalação
    
    $ sudo dpkg -i \<arquivo baixado deb>
  
- obtendo a descrição do pacote
  
  $ sudo dpkg -I \<arquivo deb>
  
  - remover
    
    $ sudo dpkg -r \<nome do pacote> (package na descrição do pacote)
    	

**Redhat (Fedora, CentOS, RHEL)**

- rpm
  - instalação
    
    $ sudo rpm -ivh \<pacote rpm> (baixado de sites como o dpkg.com)
    
    $ sudo rpm -ivh --nodeps \<pacote rpm> (se houver problemas com dependências)
    
  - atualização
  	
	
  $ sudo rpm -U \<pacote rpm>
  	
  - remoção
  	
  	$ sudo rpm -e \<pacote rpm>
  
- yum
  - instalação
    
    $ sudo yum install \<nome do pacote>
  
- atualização
  	
  $ sudo yum update \<nome do pacote>
  	
  - remoção
  	
  	$ sudo yum remove \<nome do pacote>